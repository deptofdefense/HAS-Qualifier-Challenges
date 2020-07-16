#!/usr/bin/env python3

import app_api
import argparse
import random
import sys
import os
import time
import subprocess
import pickle
from datetime import datetime, timezone, timedelta
import json
from signal import SIGTERM
from app_api import CH_CONF_PATH as CONFIG_PATH

def init_tel(logger):
    name   = 'initial_tel_data'
    args = '''["-f","tel-data/CLYDE_EPS.csv", "/challenge/mission-apps/tel-data/NOVATEL_GPS.csv", 
    "/challenge/mission-apps/tel-data/REACTION_WHEEL.csv"]'''

    start_app_request = '''
 mutation{
     startApp(name: "%s", config: "%s", args: %s){
         success,
         errors,
         pid
     }
 }
    ''' % (name, CONFIG_PATH, args)

    app_status_req = '{appStatus(name: "initial_tel_data"){pid}}'
    app_unin_req   = 'mutation{uninstall(name: "initial_tel_data"){success, errors}}'

    try:
        response = SERVICES.query(service='app-service', query=start_app_request)
        # #print(response)
        pid = response['startApp']['pid']
        # #print(pid)
        while((SERVICES.query(service='app-service', query=app_status_req))['appStatus'][0]['pid'] == pid):
            #print(f'{logger} info: Waiting for initalization to finish...')
            time.sleep(1)
        response = SERVICES.query(service='app-service', query=app_unin_req)
        # #print(response)
    except Exception as e:
        error_msg =  "Initializing Telemetry data failed: " + str(e) + ""
        print(error_msg)

    return

def find_kill_services(logger):

    # Kill all kubos services.

    pid_list = []
    list_cmds = []
    ports = ['8000', '8010', '8020', '8030', '8110', '8120']

    for port in ports:
        list_cmds.append(['lsof', '-t','-i:%s' % port])

    for cmd in list_cmds:
        start_sch = subprocess.Popen(cmd, stdout=subprocess.PIPE)
        ppid = start_sch.stdout.read().decode('ascii').split('\n')
        for pid in ppid:
            if pid != '':
                pid_list.append(pid)

    for pid in pid_list:
        #print("Killing %s" % pid)
        os.kill(int(pid), SIGTERM)

    return

def delete_by_force(logger):

    sch_path = '/challenge/target/release/schedules/stage_one/'

    if os.path.exists(sch_path):
        f_list = os.listdir(sch_path)
        for f in f_list:
            os.unlink(sch_path + f.split('/')[-1])  # in case of malicious file names.
        os.rmdir(sch_path)

    return

def delete_all_info(logger):

    requests = []
    requestSafeMode = 'mutation{safeMode{success, errors}}'
    requestRemoveMode = 'mutation{removeMode(name:"stage_one"){success, errors}}'

    mapps = ['critical_tel_check', 'initial_tel_data', 'update_tel', 'housekeeping',
    'request_flag_telemetry', 'sunpoint', 'enable_groundlink', 'groundpoint', 'sunpoint']


    for mapp in mapps:
        requestUninstall = 'mutation{uninstall(name: "%s"){success, errors}}' % mapp
        requests.append(requestUninstall)

    app_count = 0
    for request in requests:
        try:
            response = SERVICES.query(service='app-service', query=request)
            #print(f"Deleted %s: {response['uninstall']['success']} | {response['uninstall']['errors']}" % mapps[app_count])                        # DEBUG TAKE OUT
        except Exception as e:
            error_msg =  "Deleting app %s failed: " % request + str(e) + ""
            print(error_msg)
        app_count += 1
    
    try:
        response = SERVICES.query(service='scheduler-service', query=requestSafeMode)
        #print("Turned on safe mode.")
        time.sleep(1)
        response = SERVICES.query(service='scheduler-service', query=requestRemoveMode)
        #print("Removed mode stage_one.")
    except Exception as e:
        error_msg =  "Deleting all schedules failed: " + str(e) + ""
        print(error_msg)
        delete_by_force(logger)

    find_kill_services(logger)
    
    return


def activate_mode(logger, mode_name):
    
    request = '''
mutation {
    activateMode(name: "%s") {
        success
        errors
    }
}   ''' % mode_name

    #print(f"{logger} info: Activating mode %s." % mode_name)                         # DEBUG

    try:
        response = SERVICES.query(service='scheduler-service', query=request)
        # #print(response)
    except Exception as e:
        error_msg =  "Starting mode %s failed: " % mode_name + str(e) + ""
        print(error_msg)                                                        # DEBUG
    
    return

def create_mode(logger, mode_name):               #Create the stage 1 mode

    request = """
mutation {
    createMode(name: "%s") {
        success
        errors
    }
}""" % mode_name

    #print(f"{logger} info: Creating mode %s." % mode_name)                           # DEBUG
    try:
        response = SERVICES.query(service='scheduler-service', query=request)
        # #print(response)
    except Exception as e:
        error_msg =  "Creating mode %s failed: " % mode_name + str(e) + ""
        print(error_msg)                                                        # DEBUG

    return

def create_mode_schedule(logger, mode_name):
    sch_name = "nominal-op"
    schedule_path = os.getcwd() + f"/../{mode_name}.json"
    request = '''    
mutation {
    importTaskList(name: "%s", path: "%s", mode: "%s") {
        success
        errors
    }
}   ''' % (sch_name, schedule_path, mode_name)

    #print(f"{logger} info: Creating schedule %s for mode %s." % (sch_name, mode_name))
    try:
        response = SERVICES.query(service='scheduler-service', query=request)
        #print(response)
    except Exception as e:
        error_msg =  "Importing schedule %s in mode %s failed: " % (sch_name, mode_name) + str(e) + ""
        print(error_msg)

    return

def register_all_apps(logger):
    cwd = os.getcwd()

    # Stage one apps to register
    init_tel_app    = cwd + "/../initial_tel_data"
    crit_check_app  = cwd + "/../critical_tel_check"
    eps_tel_app     = cwd + "/../update_tel"

    # Stage two apps to register
    p_apps_app       = cwd + "/../../stage_two/print_all_apps"
    req_flag_app    = cwd + "/../../stage_two/req_flag_base"
    en_down_app     = cwd + "/../../stage_two/enable_downlink"
    gndpoint_app    = cwd + "/../../stage_two/groundpoint"
    sunpoint_app    = cwd + "/../../stage_two/sunpoint"
    low_power_app   = cwd + "/../../stage_two/low_power"
    act_trans_app   = cwd + "/../../stage_two/activate_tranmsission_mode"

    registrations = [init_tel_app, crit_check_app, eps_tel_app, p_apps_app, req_flag_app, en_down_app, gndpoint_app, sunpoint_app, low_power_app, act_trans_app]

    for mapp in registrations:
        #print(f"{logger} info: Registering, %s" % mapp.split('/')[-1] + " app.")
        register_app(logger, mapp)

    return

def register_app(logger, app_path):
    
    request = """
mutation {
  register(path: "%s") {
    success,
    errors,
    entry {
      app {
        name
        executable
      }
    }
  }
}   """ % app_path

    try:
        response = SERVICES.query(service='app-service', query=request)
        ##print(response)
    except Exception as e:
        error_msg =  "Registering %s failed: " % app_path + str(e) + ""
        print(error_msg)

def store_latest_json(logger):

    current_tel = ""

    with open('/challenge/mission-apps/pkls/current_tel.json', 'w') as js_file:
        json.dump(current_tel, js_file)

    return

def store_low_power_json(logger, low_power_time):

    with open('../low_power.json', 'r') as js_file:
        low_power_json = json.load(js_file)

    low_power_json['tasks'][1]['time'] = low_power_time

    with open('../low_power.json', 'w') as js_file:
        json.dump(low_power_json, js_file)
    


def store_transmission_json(logger):
    SEED = int(os.getenv('SEED', 0))
    random.seed(SEED)

    utc_dt = datetime.now(tz=timezone.utc)
    base_time = utc_dt + timedelta(  seconds= ( (60.0) * (50.0 + random.randrange(0,10)) )  )

    time_offsets = [0.0, 20.0, 25.0, 30.0]
    
    with open('../transmission.json', 'r') as js_file:
        transmission_json = json.load(js_file)

    for app, offset in zip(transmission_json['tasks'], time_offsets):
        app['time'] = (base_time + timedelta(seconds=offset)).strftime("%Y-%m-%d %H:%M:%S")

    # print("DEBUG: " + str(transmission_json))

    with open('../transmission.json', 'w') as js_file:
        json.dump(transmission_json, js_file)

    low_power_time_str = (base_time + timedelta(seconds=-10)).strftime("%Y-%m-%d %H:%M:%S")
    #low_power_time_obj = (base_time + timedelta(seconds=-10))

    with open('/challenge/mission-apps/pkls/transmission_time.pkl', 'wb') as pkl_file:
        pickle.dump(low_power_time_str, pkl_file)

    return low_power_time_str

def main():

    logger = "start_stage_one "
    
    parser = argparse.ArgumentParser()
    
    parser.add_argument('--config', '-c', nargs=1)
    parser.add_argument('--delete', '-d', help='Deletes all app and service data', action='store_true')
    
    args = parser.parse_args()
    
    if args.config is not None:
        global SERVICES
        SERVICES = app_api.Services(args.config[0])
    else:
        SERVICES = app_api.Services(CONFIG_PATH)
    
    #print(f"{logger} info: Begining stage_one")

    if args.delete:
        #print(f"{logger} info: Deleting app and service data.")
        delete_all_info(logger)
    else:
        register_all_apps(logger)
        init_tel(logger)

        create_mode(logger, "transmission")
        low_power_time_str = store_transmission_json(logger)
        create_mode_schedule(logger, "transmission")

        create_mode(logger, "low_power")
        store_low_power_json(logger, low_power_time_str)
        create_mode_schedule(logger, "low_power")

        create_mode(logger, "station-keeping")
        create_mode_schedule(logger, "station-keeping")

        activate_mode(logger, "station-keeping")
        store_latest_json(logger)
    
    print("\n** Welcome to spaceDB **\n" + '-'* 25)
    
if __name__ == "__main__":
    main()
