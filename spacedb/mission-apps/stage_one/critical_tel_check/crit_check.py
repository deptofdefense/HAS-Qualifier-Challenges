#!/usr/bin/env python3

# Checks if system is in critical state. If it is, start scheduler service,
# if not, close it.

import argparse
import json
import app_api
import sys
import time
import toml
import pickle
import subprocess
import os
import signal
import shutil
from app_api import CH_CONF_PATH as CONFIG_PATH

def get_crit_val():     # Checks current state of system.
    
    with open('/challenge/mission-apps/pkls/update_tel/crit_val.pkl', 'rb') as pkl_file:
        crit_val = pickle.load(pkl_file)

    return crit_val


def start_game_scheduler_service(logger):        # Changes NGINX config file to allow team access to scheduler service
    #Start by running mode that allows the service

    active_conf_path         = "/etc/nginx/conf.d/active.conf"
    allow_access_conf_path   = "/challenge/noncrit.conf"

    sch_no_access = subprocess.call(f"diff -q {active_conf_path} {allow_access_conf_path} > /dev/null", shell=True)
    # sch_access = subprocess.call(f"diff -q crit.conf noncrit.conf > /dev/null", shell=True)

    if(sch_no_access):
        shutil.copyfile(f'{allow_access_conf_path}', f'{active_conf_path}')
        cmd_list = ['service', 'nginx', 'restart']
        sch_sub = subprocess.Popen(cmd_list, stdout=subprocess.PIPE)
        sch_sub.communicate()

    print(f"{logger} info: Scheduler service comms started successfully at: %s:%s/sch/graphiql" % \
        (os.getenv('SERVICE_HOST', '127.0.0.1'), os.getenv('SERVICE_PORT', '8888')) )

    return

def find_sch_pid():     ### UNUSED ###

    # No longer needed 
    # In case the game scheduler service is running but
    # there is no stored pid for the service. In this case
    # the flag_access option could be False but the service is still
    # accessable meaning stage 2 would be unsolvable
    # Extremely slow way to find the process but ensures it will be found. Should NEVER be used.
    # Only here to make sure nothing compromises challenge.

    logger = app_api.logging_setup("CTF-Challenge")

    request = '{ps{pid,cmd}}'

    try:
        response = SERVICES.query(service="monitor-service", query=request)
    except Exception as e:
        print(f"{logger} err: Something went seriously wrong with challenge.")
        print(f"{logger} warn: Fixing but you should open a new challenge.")
        print(f"{logger} info: Fixing challenge...")

    for ps in response['ps']:
        if ('sch-service' in ps['cmd']):
            print(f"{logger} info: Challenged fixed.")
            return ps['pid']

    print(f"{logger} err: Challenge not fixed.")

    sys.exit(-1)

    return

def close_game_scheduler_service(logger):

    print(f"{logger} info: Closing scheduler service.")

    active_conf_path        = "/etc/nginx/conf.d/active.conf"
    no_access_conf_path     = "/challenge/crit.conf"

    sch_access = subprocess.call(f"diff -q {active_conf_path} {no_access_conf_path} > /dev/null", shell=True)
    # sch_access = subprocess.call(f"diff -q crit.conf noncrit.conf > /dev/null", shell=True)

    if(sch_access):
        shutil.copyfile(f'{no_access_conf_path}', f'{active_conf_path}')
        cmd_list = ['service', 'nginx', 'restart']
        sch_sub = subprocess.Popen(cmd_list, stdout=subprocess.PIPE)
        sch_sub.communicate()


def set_critval_and_start(logger, crit_now):          #ADD LOGGER INFO SAYING FLAG IS ACTIVE
    old_val  = get_crit_val()

    crit_val = crit_now

    if crit_val == old_val and crit_val:
        print(f"{logger} warn: System CRITICAL.")
        sun_check(logger)
        print(f"{logger} warn: Debug telemetry database running at: %s:%s/tel/graphiql" % 
            (os.getenv('SERVICE_HOST'), os.getenv('SERVICE_PORT')))
        return
    elif crit_val == old_val and not crit_val:
        print(f"{logger} info: System: OK.")
        sun_check(logger)
        return
    elif crit_val != old_val and crit_val:
        print(f'{logger} warn: System CRITICAL.')       
        sun_check(logger)          
        print(f'{logger} warn: Stopping non-essential services.')
        print(f"{logger} warn: Debug telemetry database running at: %s:%s/tel/graphiql" % 
            (os.getenv('SERVICE_HOST'), os.getenv('SERVICE_PORT')))
        close_game_scheduler_service(logger)
    elif crit_val != old_val and not crit_val:
        sun_check(logger)
        print(f'{logger} warn: System: OK. Resuming normal operations.')               
        start_game_scheduler_service(logger)
    
    with open('/challenge/mission-apps/pkls/update_tel/crit_val.pkl', 'wb') as pkl_file:
        pickle.dump(crit_val, pkl_file)

    return

def check_gps_val(logger):
    subsystem = "gps"
    parameter = "ECEF_X"

    request   = 'query{telemetry(subsystem: "%s", parameter: "%s", limit: 1){value}}' % (subsystem, parameter)

    print(f"{logger} info: Checking %s subsystem" % subsystem)

    try:
        response = SERVICES.query(service="telemetry-service", query=request)       #do something with response if you need to
    except Exception as e:
        print(f"{logger} err: %s check went wrong: " % subsystem + str(e) + "")
    
    with open('/challenge/mission-apps/pkls/update_tel/gps_count.pkl', 'rb') as pkl_file:
        gps_count = pickle.load(pkl_file)

    with open('/challenge/mission-apps/pkls/update_tel/gps.pkl', 'rb') as pkl_file:
        gps_vals = pickle.load(pkl_file)
    
    if gps_count > len(gps_vals) - 2:
        gps_count = 1

    real_x = gps_vals[gps_count][1]

    try:
        x_value = float(response['telemetry'][0]['value'])
        if x_value != real_x:
            print(f"{logger} info: %s subsystem: OK" % subsystem)
            return
        else:
            print(f"{logger} warn: %s is off track." % parameter)
            print(f"{logger} info: Checking %s." % subsystem)            
            print(f"{logger} info: %s subsystem: OK." % subsystem)
    except ValueError:
        print(f"{logger} warn: %s telemetry not formatted as type: float." % subsystem)
        print(f"{logger} info: Checking %s hardware" % subsystem)
        print(f"{logger} info: %s hardware okay." % subsystem)
    except Exception as e:
        print(f"{logger} err: Something went wrong checking %s subsystem." % subsystem)
        print(f"{logger} info: Checking %s hardware" % subsystem)
        print(f"{logger} info: %s hardware okay." % subsystem)

    return

def check_eps_val(logger):

    subsystem = 'eps'
    parameter = 'VIDIODE'
    request   = 'query{telemetry(subsystem: "%s", parameter: "%s", limit: 1){value, timestamp}}' % (subsystem, parameter)

    print(f"{logger} info: %s telemetry check." % subsystem)

    try:
        response = SERVICES.query(service="telemetry-service", query=request)       #do something with response if you need to
    except Exception as e:
        print(f"{logger} err: %s check went wrong: " % subsystem + str(e) + "")

    current_time = time.time()

    try:
        if current_time < float(response['telemetry'][0]['timestamp']):
            print(current_time)
            print(float(response['telemetry'][0]['timestamp']))
            print(f"{logger} warn: %s subsystem timestamps do not match." % subsystem)
            return False
        volt_value = float(response['telemetry'][0]['value'])
        if volt_value >= 7.0 and volt_value <= 8.0:                                
            charging_check(logger)
            print(f"{logger} info: %s subsystem: OK" % subsystem)
            return True
        elif volt_value < 7.0:
            print(f"{logger} warn: %s battery voltage too low." % parameter)
            charging_check(logger)
            # print(f"{logger} info: Blank Statement")
        elif volt_value > 8.0:
            print(f"{logger} warn: %s battery voltage too high." % parameter)
            charging_check(logger)
            # print(f"{logger} info: Blank Statement")
    except ValueError:
        print(f"{logger} warn: %s telemetry not formatted as type: float." % subsystem)
        print(f"{logger} warn: %s battery voltage too low." % parameter)
        charging_check(logger)
    except Exception as e:
        print(f"{logger} err: Something went wrong checking %s. Missing data." % (subsystem))
        print(f"{logger} warn: %s battery voltage too low." % parameter)
        charging_check(logger)

    return False
    

def check_wheel_val(logger):
    
    subsystem = "reaction_wheel"
    parameter = "MOMENTUM_NMS"

    request   = 'query{telemetry(subsystem: "%s", parameter: "%s", limit: 1){value}}' % (subsystem, parameter)

    print(f"{logger} info: %s telemetry check." % subsystem)

    try:
        response = SERVICES.query(service="telemetry-service", query=request)       #do something with response if you need to
    except Exception as e:
        print(f"{logger} err: %s check went wrong: " % subsystem + str(e) + "")
            
    try:
        mom_value = float(response['telemetry'][0]['value'])
        if mom_value >= -0.0156 and mom_value <= 0.0156:
            print(f"{logger} info: %s subsystem: OK." % subsystem)
            return
        else:
            print(f"{logger} warn: %s is outside of range [-0.0156, 0.0156]." % parameter)
            print(f"{logger} info: Checking %s hardware" % subsystem)
            print(f"{logger} info: %s hardware okay." % subsystem)
    except ValueError:
        print(f"{logger} warn: %s telemetry not formatted as type: float." % subsystem)
        print(f"{logger} info: Checking %s hardware" % subsystem)
        print(f"{logger} info: %s hardware okay." % subsystem)
    except Exception as e:
        print(f"{logger} err: Something went wrong checking %s. Missing data." % (subsystem))
        print(f"{logger} info: Checking %s hardware" % subsystem)
        print(f"{logger} info: %s hardware okay." % subsystem)

    return
        
def check_tel_change(logger):       # JSON -- dump/read.
    with open('/challenge/mission-apps/pkls/current_tel.json', 'r') as js_file:
        current_tel = json.load(js_file)
    
    # print("Debug: %s" % current_tel)

    request = '{telemetry(limit: 10){subsystem, parameter, value}}'

    try:
        response = str(SERVICES.query(service="telemetry-service", query=request))       #do something with response if you need to
        if response == current_tel:
            return False
        time.sleep(1)
        response = str(SERVICES.query(service="telemetry-service", query=request))
    except Exception as e:
        print(f"{logger} err: Current tel check went wrong: " + str(e) + "")

    with open('/challenge/mission-apps/pkls/current_tel.json', 'w') as js_file:
        json.dump(response, js_file)
    
    time.sleep(1)
    return True

def charging_check(logger):
    with open('/challenge/mission-apps/pkls/sunpoint_on.pkl', 'rb') as pkl_file:
        sunpoint_on = pickle.load(pkl_file)
    
    if not sunpoint_on:
        print(f"{logger} warn: Solar panel voltage low")

    return

def sun_check(logger):

    with open('/challenge/mission-apps/pkls/sunpoint_on.pkl', 'rb') as pkl_file:
        sunpoint_on = pickle.load(pkl_file)

    if sunpoint_on:
        print(f"{logger} info: Position: SUNPOINT")
    else:
        print(f"{logger} info: Position: GROUNDPOINT")

    return sunpoint_on

def main():

    logger = "critical-tel-check "
    
    parser = argparse.ArgumentParser()

    # The -c argument should be present if you would like to be able to specify a non-default
    # configuration file
    parser.add_argument(
        '-c',
        '--config',
        nargs=1,
        help='Specifies the location of a non-default configuration file')

    args = parser.parse_args()
    
    if args.config is not None:
        global SERVICES
        SERVICES = app_api.Services(args.config[0])
    else:
        # SERVICES = app_api.Services()
        SERVICES = app_api.Services(CONFIG_PATH)

    if not check_tel_change(logger):
        return

    print(f"{logger} info: Detected new telemetry values.")
    print(f"{logger} info: Checking recently inserted telemetry values.")
    sys.stdout.flush()

    check_gps_val(logger)
    sys.stdout.flush()

    check_wheel_val(logger)
    sys.stdout.flush()

    if (check_eps_val(logger)):
        set_critval_and_start(logger, False)
        sys.stdout.flush()
    else:
        set_critval_and_start(logger, True)
        sys.stdout.flush()

    print("")

if __name__ == "__main__":
    main()
