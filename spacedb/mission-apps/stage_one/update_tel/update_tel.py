#!/usr/bin/env python3

# What needs to be done:
# Change tel-data directory to one that anyone can access
# - eps_insert needs to be completely finished. Only quick code for testing
# is in there now. Code will be easy to update since its malleable based on
# incoming data from csv.
# Comment code.
# - Possibly add check to ensure that  services are running so it doesnt
# crash and burn when this is not the case. Have it start up services on its own.
# - Default path to config file?

# Updates the gps, eps, and reaction_wheel telemetry values every minute
# GPS values are not random and are pulled from a pickle file that is
# initialized in the initial_tel_data application.
# eps and reaction_wheel telemetry is generated from the default values
# +/- an offset.

import argparse
import app_api
import sys
import time
import toml
import random
import pickle
import csv
import os
from itertools import islice
from datetime import datetime, timedelta
from app_api import CH_CONF_PATH as CONFIG_PATH

TIMESTAMP = time.time()
GPS_TIME_DELTA = 315964782	#Delta to calculate GPS time from UTC

def tel_insert(logger, hardware, request, outservice):
    
    try:
        response = SERVICES.query(service=outservice, query=request)
    except Exception as e:
        error_msg =  "Updating %s telemetry failed: " % hardware + str(e) + ""
        print(error_msg)

        sys.stderr.write(error_msg)
        sys.exit(-30)
        return False
    
    return True

def ins_gps_tel(logger):
    subsystem = "gps"
    gps_weeks = get_GPS_weeks(TIMESTAMP)                                          #fix GPS_weeks
    gps_seconds = TIMESTAMP - GPS_TIME_DELTA

    with open('/challenge/mission-apps/pkls/update_tel/gps.pkl', 'rb') as pkl_file:
        gps_lst = pickle.load(pkl_file)
        
    with open('/challenge/mission-apps/pkls/update_tel/gps_count.pkl', 'rb') as pkl_file:    
        cur_pos = pickle.load(pkl_file)
    
    if cur_pos > len(gps_lst) - 2:
        cur_pos = 1

    headings = gps_lst[0]
    value = [gps_weeks, gps_seconds] + gps_lst[cur_pos]
    
    print(f"{logger} info: Updating %s telemetry." % subsystem)
    for par in range(1, len(headings)):
        request   = 'mutation{insert(timestamp: %f, subsystem: "%s", parameter: "%s", value: "%s"){success, errors}}' % (TIMESTAMP, subsystem, headings[par] , value[par-1])
        #print(request)
        tel_insert(logger, subsystem, request, "telemetry-service")

    cur_pos += 1

    with open('/challenge/mission-apps/pkls/update_tel/gps_count.pkl', 'wb') as pkl_file:    
        cur_pos = pickle.dump(cur_pos, pkl_file)

    return


def ins_wheel_tel(logger):
    subsystem = "reaction_wheel"
    parameter = "MOMENTUM_NMS"
    value     = str((random.randrange(156000) / 10000000) * (random.randrange(-1,1)))

    request   = 'mutation{insert(timestamp: %f, subsystem: "%s", parameter: "%s", value: "%s"){success, errors}}' % \
        (TIMESTAMP, subsystem, parameter, value)
    
    print(f"{logger} info: Updating %s telemetry." % subsystem)
    tel_insert(logger, subsystem, request, "telemetry-service")

    return

def ins_eps_tel(logger):
    subsystem = "eps"
    cur_eps = 1

    with open('/challenge/mission-apps/pkls/update_tel/curEPS.pkl', 'rb') as pkl_file:
        cur_eps = pickle.load(pkl_file)

    with open('/challenge/mission-apps/tel-data/CLYDE_EPS.csv', 'r' , encoding='utf-8-sig') as csv_file:
         eps_reader   = csv.reader(csv_file)
         parameters   = next(eps_reader)[1:]
         eps_reader   = csv.reader(islice(csv_file, cur_eps, None))
         default_vals = next(eps_reader)[1:]
    
    print(f"{logger} info: Updating %s telemetry." % subsystem)
    for val in range(0, len(default_vals)):                 #Not complete in any way.
        default_vals[val] = str( float(default_vals[val]) )
        request   = 'mutation{insert(timestamp: %f, subsystem: "%s", parameter: "%s", value: "%s"){success, errors}}' % \
            (TIMESTAMP, subsystem, parameters[val], default_vals[val])
        tel_insert(logger, subsystem, request, "telemetry-service")

    cur_eps += 1
    with open('/challenge/mission-apps/pkls/update_tel/curEPS.pkl', 'wb') as pkl_file:
        cur_eps = pickle.dump(cur_eps, pkl_file)

    return

def get_GPS_weeks(time_stamp):
    gps_epoch = datetime(1980, 1, 6)
    today = datetime.fromtimestamp(time_stamp)

    epochMonday = gps_epoch - timedelta(gps_epoch.weekday())
    todayMonday = today - timedelta(today.weekday())

    noWeeks = (todayMonday - epochMonday).days / 7 - 1
    return(noWeeks % 1024)

def main():

    logger = "update_tel "     #change to appropriate loggin name / Probably need to remove this entirely
    
    parser = argparse.ArgumentParser()
    
    #Add argument for csv file list

    parser.add_argument('--config', '-c', nargs=1)
    
    args = parser.parse_args()
    
    if args.config is not None:
        global SERVICES
        SERVICES = app_api.Services(args.config[0])
    else:
        SERVICES = app_api.Services(CONFIG_PATH)

    ins_wheel_tel(logger)
    ins_gps_tel(logger)
    ins_eps_tel(logger)

    print("")

if __name__ == "__main__":
    main()