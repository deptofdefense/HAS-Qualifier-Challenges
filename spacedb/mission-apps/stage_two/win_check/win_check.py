#!/usr/bin/env python3

# What needs to be done:

# Prints flag to the log on reboot.

import argparse
import json
import app_api
import sys
import os
import subprocess
import shutil
import time
import toml
import random
import pickle
import csv
import re
from operator import itemgetter
from signal import SIGTERM
from datetime import datetime, timedelta, timezone
from app_api import CH_CONF_PATH as CONFIG_PATH

def get_current_time():
    with open('/challenge/mission-apps/pkls/transmission_time.pkl', 'rb') as pkl_file:
        transmission_time = pickle.load(pkl_file)

    return datetime.strptime(transmission_time, '%Y-%m-%d %H:%M:%S')

CURRENT_TIME = get_current_time()            # Time that delays will be offset by. This is technically the time that transmission mode is activated.


def check_mode(logger, tsun_start):

    request = """{
  availableModes(name: "transmission"){
    name,
    schedule{
        tasks{time, delay, app{name}},
        filename
    },
    active
  }
}"""

    try:
        response = SERVICES.query(service='scheduler-service', query=request)
    except Exception as e:
        sys.stderr.write(f"{logger} err: Checking win failed (kids most likely deleted mode): %s" % str(e) + "")
        print("Deleting the mode won't do anything. Think like a satellite. Be the satellite.")
        lose_game()
        close_game_scheduler_service()
        return False

    # sys.stderr.write('\n' + str(response) + '\n')

    time.sleep(0.5)

    close_game_scheduler_service()
    
    # {'activeMode': {'name': 'transmission', 'schedule': 
    # [{'tasks': [
    # {'time': '2020-05-07 01:52:46', 'delay': None, 'app': {'name': 'groundpoint'}}, 
    # {'time': '2020-05-07 01:53:06', 'delay': None, 'app': {'name': 'enable_downlink'}}, 
    # {'time': '2020-05-07 01:53:11', 'delay': None, 'app': {'name': 'disable_downlink'}}, 
    # {'time': '2020-05-07 01:53:16', 'delay': None, 'app': {'name': 'sunpoint'}}
    # ], 
    # 'filename': 'nominal-op'}], 'active': True}}

    app_order       = []
    team_app_times  = {'tasks': []}
    team_flag_time  = {'name': '', 'time': '', 'delay': ''}
    real_app_names  = []
    real_app_times  = {'tasks': []}

    # Get the teams scheduled apps and their registered times.
    try:
        for sch in response['availableModes'][0]['schedule']:
            for task in sch['tasks']:
                if task['app']['name'] == 'request_flag_telemetry':
                    team_flag_time['name'] = 'request_flag_telemetry'
                    team_flag_time['time'] = task['time']
                    team_flag_time['delay'] = task['delay']
                else:
                    team_app_times['tasks'].append({'name': task['app']['name'], 'time': task['time'], 'delay': task['delay']})
    except Exception as e:      ## Add specific scenarios
        print("(BAD): Broke at loading team times: " + str(e), file=sys.stderr)
        lose_game()
        return False

    if len(team_app_times['tasks']) > 4 and tsun_start is not None:
        print("(GOOD): More than 5 tasks.", file=sys.stderr)
        lose_game()
        return False
    elif len(team_app_times['tasks']) > 5:
        print("(GOOD): More than 5 tasks.", file=sys.stderr)
        lose_game()
        return False
    elif len(team_app_times['tasks']) < 4:
        print("(GOOD): Less than 4 tasks.", file=sys.stderr)
        lose_game()
        return False

    # Get original task times to compare.
    with open('/challenge/mission-apps/stage_one/transmission.json', 'r') as js_file:
        task_times = json.load(js_file)
    
    for task in task_times['tasks']:
        real_app_times['tasks'].append({'name': task['app']['name'], 'time': task['time']})

    win_bounds = ['','']

    win_bounds[0] = list(filter(lambda app: app['name'] == 'groundpoint', real_app_times['tasks']))[0]['time']
    win_bounds[1] = list(filter(lambda app: app['name'] == 'sunpoint', real_app_times['tasks']))[0]['time']

    win_bounds[0] = datetime.strptime(win_bounds[0], '%Y-%m-%d %H:%M:%S') - CURRENT_TIME - timedelta(seconds=(60 * 5))
    win_bounds[1] = datetime.strptime(win_bounds[1], '%Y-%m-%d %H:%M:%S') - CURRENT_TIME + timedelta(seconds=(60 * 5))


    times_okay, fail_reason = check_time_okay(team_app_times['tasks'], team_flag_time, tsun_start, win_bounds)

    sys.stderr.write(f"\nDEBUG: Fail reason -- {fail_reason}")

    if fail_reason == 0:
        sys.stderr.write("DEBUG: (Impossible) One or more of the apps are scheduled before satellite is finished charging.\n")
    if fail_reason == 9:
        sys.stderr.write("DEBUG: Missed groundstation window.\n")
    if fail_reason == 1:
        sys.stderr.write("DEBUG: Flag was not scheduled for grab.\n")
    if fail_reason == 2:
        sys.stderr.write("DEBUG: Neither enable nor disable scheduled.\n")
    if fail_reason == 3:
        sys.stderr.write("DEBUG: Enable downlink not scheduled.\n")
    if fail_reason == 4:
        sys.stderr.write("DEBUG: Disable downlink not scheduled.\n")
    if fail_reason == 5:
        sys.stderr.write("DEBUG: Downlink window scheduled too close together or scheduled backwards.\n")
    if fail_reason == 6:
        sys.stderr.write("DEBUG: Downlink window scheduled too far together or scheduled backwards.\n")
    if fail_reason == 7:
        sys.stderr.write("DEBUG: Flag was scheduled before enable.\n")
    if fail_reason == 8:
        sys.stderr.write("DEBUG: Flag was scheduled after enable.\n")

    if fail_reason == 9:
        check_time_okay(team_app_times['tasks'], team_flag_time, tsun_start, win_bounds, True)
        
    if not times_okay and fail_reason < 1:
        return extra_lose(fail_reason, [])
    try:
        #print(team_app_times)
        app_order = sorted(team_app_times['tasks'], key=itemgetter('time'))
        if not times_okay:
            for app in app_order:
                app['delay'] = False
            return extra_lose(fail_reason, app_order)
    except Exception as e:
        print(f'(BAD): Failed at app sort. Error: {str(e)}', file=sys.stderr)
        extra_lose(0, [])
        return False

    #print(f"DEBUG: {app_order}")
    real_app_names = ['groundpoint', 'enable_downlink', 'disable_downlink', 'sunpoint']
    for app_index in range(0, len(app_order)):
        if real_app_names[app_index] != app_order[app_index]['name']:
            extra_lose(1, app_order)

    return True

def check_time_okay(team_app_times, team_flag_time, tsun_start, win_bounds, lost_game=False):

    if (len(team_flag_time['name']) > 2):
        team_app_times.append(team_flag_time)

    team_soonest_time = datetime.fromtimestamp(0)
    # convert delays to times so that all schedules are represented as a datetime object.
    # should have used regex. Sorry.

    downlink_delta = [None, None]           # will contain two datetime objects

    for app in team_app_times:
        sys.stderr.write('\nDEBUG: %s ' % str(app) + '\n')
        if app['delay'] != None:    # App times and app delays are mutually exclusive.
            app_delay_times = app['delay'].split(' ')
            temp = []               # Placeholder until we can use name for readability
            for d in app_delay_times:
                m = re.search("(\d+)([smh])", d)
                value = int(m.group(1))
                units = m.group(2)
                temp.append({'value': value, 'units': units})

            app_delay_times = temp
            delay_as_delta = timedelta()
            for d in app_delay_times:
                if d['units'].lower() == 's':
                    delay_as_delta += timedelta(seconds=d['value'])
                elif d['units'].lower() == 'm':
                    delay_as_delta += timedelta(minutes=d['value'])
                elif d['units'].lower() == 'h':
                    delay_as_delta += timedelta(hours=d['value'])
            
            # if delay_as_delta < timedelta(seconds=5) and not lost_game:
            #     if not (tsun_start == None and app['name'] == 'sunpoint'):
            #         return False, 0     # One or more of the apps are scheduled before satellite is finished charging.
            if delay_as_delta > win_bounds[1] or delay_as_delta < win_bounds[0] and not lost_game:
                sys.stderr.write("DEBUG: Losing with 9 in block 1" + "\n")
                return False, 9     # Missed groundstation window
            app['time'] = CURRENT_TIME + delay_as_delta
        
        elif (type(app['time'] != datetime)):   # Must have an app time. Take it out here. (See if above)
            app['time'] = datetime.strptime(app['time'], '%Y-%m-%d %H:%M:%S')
            if app['time'] < CURRENT_TIME and not lost_game:
                return False, 0     # One or more of the apps are scheduled before satellite is finished charging.
            elif app['time'] > CURRENT_TIME + win_bounds[1] or app['time'] < CURRENT_TIME + win_bounds[0] and not lost_game:
                sys.stderr.write("DEBUG: Losing with 9 in block 2" + "\n")
                return False, 9
        else:   # Must have an app time. Take it out here. (See if above)
            if app['time'] < CURRENT_TIME and not lost_game:
                return False, 0     # One or more of the apps are scheduled before satellite is finished charging.
            elif app['time'] > CURRENT_TIME + win_bounds[1] or app['time'] < CURRENT_TIME + win_bounds[0] and not lost_game:
                sys.stderr.write("DEBUG: Losing with 9 in block 1 + 1" + "\n")
                return False, 9
        
        if app['name'] == 'enable_downlink':
            downlink_delta[0] = app['time']
        elif app['name'] == 'disable_downlink':
            downlink_delta[1] = app['time']

        team_soonest_time = min(team_soonest_time, app['time']) 

    if lost_game:
        return False, 0

    # sys.stderr.write("DEBUG: %s" % str(team_app_times))

    if tsun_start == None:
        sun_correct = False
        sun_correct_time = None
        for app in team_app_times:
            if app['name'] == 'sunpoint' and app['time'] < (CURRENT_TIME + win_bounds[1] - timedelta(minutes=30)):
                sun_correct_time = app['time']
                sun_correct = True
        if not sun_correct:
            return False, 0
        elif sun_correct_time > datetime.utcnow() + 3:
            print('sunpoint  info: Adjusting to sunpoint...')
            print(f'sunpoint  info: [{sun_correct_time.strftime("%Y-%m-%d %H:%M:%S")}] Sunpoint panels: SUCCESS')
        else:
            time.sleep(3)

    if (len(team_flag_time['name']) < 2):
        return False, 1             # flag was not scheduled for grab.
    if downlink_delta[0] is None and downlink_delta[1] is None:
        return False, 2             # neither enable nor disable scheduled
    if downlink_delta[0] == None:
        return False, 3             # enable not scheduled.
    if downlink_delta[1] == None:
        return False, 4             # disable not scheduled.
    if (downlink_delta[1] - downlink_delta[0] <= timedelta(seconds=1)):
        return False, 5             # scheduled too close together or scheduled backwards.
    if (downlink_delta[1] - downlink_delta[0] >= timedelta(minutes=1)):
        return False, 6             # scheduled too far together or scheduled backwards.

    team_flag_time = team_app_times[-1]
    del(team_app_times[-1])

    if team_flag_time['time'] <= downlink_delta[0]:
        return False, 7             # scheduled before enable.
    if team_flag_time['time'] >= downlink_delta[1]:
        return False, 8             # scheduled after disable.

    return True, None

def extra_lose(loss_reason, app_order):
    if loss_reason == 0:
        print("WARN: Battery critical.")
        print("INFO: Shutting down.")
        print("Goodbye")
    elif loss_reason == 9:
        verbal_lose_apps(app_order, False, True)
    elif loss_reason == 6:
        verbal_lose_apps(app_order, True, ted_out=True)
    else:
        verbal_lose_apps(app_order, False)

def verbal_lose_apps(app_order, low_bat, missed_window=False, ted_out=False):

    groundpoint_ran = False
    enable_ran      = False
    req_ran         = False

    for app in app_order:
        if app['name'] == 'groundpoint':
            print("INFO: Adjusting to groundpoint...")
            print("INFO: Pointing at ground: SUCCESS\n")
            groundpoint_ran = True
        elif app['name'] == 'enable_downlink':
            if groundpoint_ran == False:
                print("ERROR: Not pointed at ground")
                print("ERROR: enable_downlink: FAIL\n")
            elif missed_window == True:
                print("INFO: Powering-up antenna")
                print("ERROR: Cannot find groundstation")
                print("INFO: Powering-down antenna\n")
            elif ted_out == True:
                print("INFO: Powering-up antenna")
                print("WARN: Downlink window too large. Canceling...\n")
            else:
                print("INFO: Powering-up antenna")
                print("WARN: No data to transmit\n")
                enable_ran = True
        elif app['name'] == 'disable_downlink':
            if enable_ran == True:
                print("INFO: Powering-down antenna")
                print("INFO: Downlink disable: SUCCESS\n")
            else:
                print("INFO: Powering-down antenna")
                print("WARN: Downlink not running\n")
        elif app['name'] == 'request_flag_telemetry':
            if(not enable_ran and not req_ran):
                print("ERROR: Not currently transmitting.")
                print("WARN: Could not downlink flag.\n")
                req_ran = True
        elif app['name'] == 'sunpoint':
            print("INFO: Adjusting to sunpoint...")
            print("INFO: Sunpoint panels: SUCCESS\n")

    if low_bat:
        print("WARN: LOW Battery.")
        print("INFO: Shutting down...\n")

    print("Goodbye")
    return 

def find_kill_services():

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
    

def close_game_scheduler_service():

    active_conf_path        = "/etc/nginx/conf.d/active.conf"
    no_access_conf_path     = "/challenge/crit.conf"

    sch_access = subprocess.call(f"diff -q {active_conf_path} {no_access_conf_path} > /dev/null", shell=True)
    # sch_access = subprocess.call(f"diff -q crit.conf noncrit.conf > /dev/null", shell=True)

    if(sch_access):
        shutil.copyfile(f'{no_access_conf_path}', f'{active_conf_path}')
        cmd_list = ['service', 'nginx', 'restart']
        sch_sub = subprocess.Popen(cmd_list, stdout=subprocess.PIPE)
        sch_sub.communicate()


def close_all_services():   # Reroute nginx and remove tasks

    close_game_scheduler_service()

    appDeleteRequests = []
    modeDeleteRequests = []
    requestModes = '{availableModes{name}}'
    requestSafeMode = 'mutation{safeMode{success, errors}}'

    mapps = ['critical_tel_check', 'initial_tel_data', 'update_tel', 'housekeeping',
    'request_flag_telemetry', 'sunpoint', 'enable_groundlink', 'groundpoint', 'sunpoint']

    try:
        response = SERVICES.query(service='scheduler-service', query=requestModes)
    except Exception as e:
        error_msg =  "Couldn't get list of modes: " + str(e) + ""
        print("(BAD)" + error_msg, file=sys.stderr)

    # print("DEBUG: %s" % response)

    for mode in response['availableModes']:
        if mode['name'] != 'safe':
            modeDeleteRequests.append('mutation{removeMode(name:"%s"){success, errors}}' % mode['name'])

    for mapp in mapps:
        requestUninstall = 'mutation{uninstall(name: "%s"){success, errors}}' % mapp
        appDeleteRequests.append(requestUninstall)

    app_count = 0
    for request in appDeleteRequests:
        try:
            response = SERVICES.query(service='app-service', query=request)
            #print(f"Deleted %s: {response['uninstall']['success']} | {response['uninstall']['errors']}" % mapps[app_count])                        # DEBUG TAKE OUT
        except Exception as e:
            error_msg =  "Deleting app %s failed: " % request + str(e) + ""
            print(error_msg)
        app_count += 1
    
    try:
        response = SERVICES.query(service='scheduler-service', query=requestSafeMode)
        time.sleep(1)
    except Exception as e:
        error_msg =  "Deleting all schedules failed: " + str(e) + ""
        print(error_msg)

    for request in modeDeleteRequests:
        try:
            response = SERVICES.query(service='scheduler-service', query=request)
            #print("Removed mode stage_one.")
        except Exception as e:
            error_msg =  "Deleting all schedules failed: " + str(e) + ""
            print(error_msg)

    find_kill_services()

    return

def lose_game(ground=False, low_power=False):
    if not ground:
        print("WARN: Could not establish downlink.")
        print("ERROR: Downlink: FAILED")
    
    if not low_power:
        print("WARN: LOW battery.")
        time.sleep(0.5)
        print("Shutting down...")
        print("Goodbye.")
    else:
        print("")
    return

def get_flag():

    flag = os.getenv('FLAG', 'flag{GOAT_FLAG}')

    return flag


def sun_check():

    with open('/challenge/mission-apps/pkls/sunpoint_on.pkl', 'rb') as pkl_file:
        sunpoint_on = pickle.load(pkl_file)
        tsun_start = pickle.load(pkl_file)

    # {'activeMode': {'name': 'transmission', 'schedule': 
    # [{'tasks': [
    # {'time': '2020-05-07 01:52:46', 'delay': None, 'app': {'name': 'groundpoint'}}, 
    # {'time': '2020-05-07 01:53:06', 'delay': None, 'app': {'name': 'enable_downlink'}}, 
    # {'time': '2020-05-07 01:53:11', 'delay': None, 'app': {'name': 'disable_downlink'}}, 
    # {'time': '2020-05-07 01:53:16', 'delay': None, 'app': {'name': 'sunpoint'}}
    # ], 
    # 'filename': 'nominal-op'}], 'active': True}}

    if not sunpoint_on:
        request = """{
  activeMode{
    name,
    schedule{
        tasks{time, delay, app{name}},
        filename
    },
    active
}}"""
        try:
            response = SERVICES.query(service='scheduler-service', query=request)
        except Exception as e:
            sys.stderr.write(f"err: Checking win failed @ sun_check: %s" % str(e) + "")
            return False, None
        for app in response['activeMode']['schedule'][0]['tasks']:
            if app['app']['name'] == 'sunpoint':
                return True, datetime.utcnow()
    
    return sunpoint_on, tsun_start

def check_active_mode(logger):

    request = """{
  activeMode{
    name
}}"""

    try:
        response = SERVICES.query(service='scheduler-service', query=request)
    except Exception as e:
        sys.stderr.write(f"{logger} err: Checking win failed: %s" % str(e) + "")
        return False

    sys.stderr.write('\n' + str(response) + '\n')

    if response['activeMode']['name'] != 'low_power':
        return False

    return True

def main():

    logger = "win_check "                  #change to appropriate login name / Probably need to remove this entirely
    
    parser = argparse.ArgumentParser()
    
    #Add argument for csv file list

    parser.add_argument('--config', '-c', nargs=1)
    parser.add_argument('--lose', '-l', action='store_true')
    parser.add_argument('--ground', '-g', action='store_true')
    parser.add_argument('--low', '-p', action='store_true')
    
    args = parser.parse_args()
    
    if args.config is not None:
        global SERVICES
        SERVICES = app_api.Services(args.config[0])
    else:
        SERVICES = app_api.Services(CONFIG_PATH)

    if args.lose:
        if args.ground:
            lose_game(ground=True)
        elif args.low:
            lose_game(low_power=True)
        else:
            lose_game()
        
        close_all_services()
        sys.exit(0)
        return

    if not check_active_mode(logger): # checks if current mode is 'low_power' mode or not.
        lose_game()

    print("Low_power mode enabled.")    # Falling into a deep sleep
    print("Timetraveling.\n")
    sys.stdout.flush()
    
    print("Transmission mode enabled.\n")

    sunpoint_on, tsun_start = sun_check()

    if(not sunpoint_on):
        sys.stderr.write("DEBUG: (OKAY) Failed on intial sunpoint check. Did not let it charge.")
        close_game_scheduler_service()
        print("WARN: Battery critical.")
        sys.stdout.flush()
        time.sleep(0.5)
        print("INFO: Shutting down.")
        print("Goodbye")
        sys.stdout.flush()
        close_all_services()
        return

    if(check_mode(logger, tsun_start)):
        print("Pointing to ground.")
        print("Transmitting...\n")
        print("----- Downlinking -----")
        print("Recieved flag.")
        print(get_flag())
        print("\nDownlink disabled.")
        print("Adjusting to sunpoint...")
        print("Sunpoint: TRUE")
        print("Goodbye")
        sys.stdout.flush()
        
    time.sleep(2)
    close_all_services()
    

    print('')

if __name__ == "__main__":
    main()