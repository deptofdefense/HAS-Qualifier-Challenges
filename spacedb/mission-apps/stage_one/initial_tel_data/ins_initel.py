#!/usr/bin/env python3

# What needs to be done:
# Set initial critical state
# Comment code.
# Set folder paths as constants
# - Possibly add check to ensure that  services are running so it doesnt
# crash and burn when this is not the case. Have it start up services on its own.
# - Default path to config file?
# Application works as intended. (Besides QOL)

# Puts initial gps, eps, and reaction_wheel values in telemetry
# The telemetry after running this represents one orbit around the earth.
# Telemetry is taken from .csv files found in tel-data directory.
# GPS data is pickled for use in the eps-tel-update application.
# ARGUMENTS:
# -c argument is the config file for kubos services. Tells the application
# the location and ports of kubos services.
# -d argument will delete all the telemetry data for resets.
# -f argument should point to each file whose data should be parsed and
# inserted into the telemetry db.

import app_api
import argparse
import os.path
import sys
import csv
import time
import pickle
import random
from datetime import datetime, timedelta
from app_api import CH_CONF_PATH as CONFIG_PATH

GPS_TIME_DELTA = 315964782	            #Delta to calculate GPS time from UTC
ENTRY_DELTA = 60			            #Entry timestamp delta
INIT_TIME = (time.time() - (113 * 60))  #Time all first data entries will start at
    

def del_all_telemetry(logger):

    request = "mutation{delete{success,errors,entriesDeleted}}"

    try:
        response = SERVICES.query(service="telemetry-service", query=request)       #do something with response if you need to
        #print(f'{logger} info: Delete successful %s: %s entries deleted.' % (response['delete']['success'], response['delete']['entriesDeleted']))
    except Exception as e: 
        #print(response)
        #print(f"{logger} err: Deletion went wrong: " + str(e) + "")
        return False


def tel_insertBulk(timestamp, entries, logger):

    request = '''
mutation {
    insertBulk(
        timestamp: %f,
        entries: [
            %s
        ]){
        success,
        errors
    }
}
    ''' % (timestamp, entries)

    try:
        response = SERVICES.query(service="telemetry-service", query=request)       #do something with response if you need to
    except Exception as e: 
        #print(f"{logger} err: Insert went wrong: " + str(e) + "")
        return False

    return True
    ##print(request)

def parse_csv(file_path, gps_subsystem, logger):
    with open(file_path, encoding='utf-8-sig') as tlmfile:
        
        tlmreader = csv.reader(tlmfile)
        headings = next(tlmreader)                                  #Save the csv header (first row in file)
        subsystem = ''

        if(len(headings) < 1):
            error_msg = "Tlm file: %s is empty or misformatted" % file_path
            #print(error_msg)
            sys.stderr.write(error_msg)
            sys.exit(-21)

        timestamp = INIT_TIME
        if gps_subsystem:
            
            gps_lst = [headings]

            gps_weeks = get_GPS_weeks()                                          #fix GPS_weeks
            gps_seconds = timestamp - GPS_TIME_DELTA

            for bulk_entry_line in tlmreader:
                bulk_entry_line[1] = gps_weeks
                bulk_entry_line[2] = gps_seconds
                subsystem = bulk_entry_line[0]

                gps_lst.append(bulk_entry_line[3:])

                entry_list = [None] * (len(bulk_entry_line) - 1)    #faster than appending
                
                for column_num in range(1, len(bulk_entry_line)):
                    #faster than string cat
                    entry_list[column_num-1] = f'{{subsystem: "{subsystem}", parameter: "{headings[column_num]}", value: "{bulk_entry_line[column_num]}" }}'

                if not (tel_insertBulk(timestamp, ",\n\t\t\t".join(entry_list), logger)):
                    sys.stderr.write("Insert failed. Quitting...")
                    sys.exit(-22)

                timestamp += 60
                gps_seconds += (60 + (random.random() * random.randrange(-1,1)))

            store_gps_pickle(gps_lst)

        else:
            for bulk_entry_line in tlmreader:
                subsystem = bulk_entry_line[0]
                entry_list = [None] * (len(bulk_entry_line) - 1)    #faster than appending
                    
                for column_num in range(1, len(bulk_entry_line)):
                    #faster than string cat
                    entry_list[column_num-1] = f'{{subsystem: "{subsystem}", parameter: "{headings[column_num]}", value: "{bulk_entry_line[column_num]}" }}'

                if not (tel_insertBulk(timestamp, ",\n\t\t\t".join(entry_list), logger)):
                    sys.stderr.write("Insert failed. Quitting...")
                    sys.exit(-22)

                timestamp += 60

        #print(f"{logger} info: %s initial tlm inserted successfully." % subsystem)

def store_gps_pickle(gps_data):
    with open('/challenge/mission-apps/pkls/update_tel/gps.pkl', 'wb') as pkl_file:
        pickle.dump(gps_data, pkl_file)
    
    cur_pos = 1
    
    with open('/challenge/mission-apps/pkls/update_tel/gps_count.pkl', 'wb') as pkl_file:       #since modifying this value we save in new pickle file so we dont have to re-write entire gps data
        pickle.dump(cur_pos, pkl_file)

    crit_val = True

    with open('/challenge/mission-apps/pkls/update_tel/crit_val.pkl', 'wb') as pkl_file:
        pickle.dump(crit_val, pkl_file)

    sch_pid = -1

    with open('/challenge/mission-apps/pkls/critical_tel_check/sch-running.pkl', 'wb') as pkl_file:
        pickle.dump(sch_pid, pkl_file)

    iflag = False

    with open('/challenge/mission-apps/pkls/update_tel/iflag.pkl', 'wb') as pkl_file:
        pickle.dump(iflag, pkl_file)

    cur_eps = 1

    with open('/challenge/mission-apps/pkls/update_tel/curEPS.pkl', 'wb') as pkl_file:
        pickle.dump(cur_eps, pkl_file)

    sunpoint_on = False
    tsun_on = None

    with open('/challenge/mission-apps/pkls/sunpoint_on.pkl', 'wb') as pkl_file:
        pickle.dump(sunpoint_on, pkl_file)
        pickle.dump(tsun_on, pkl_file)

def get_GPS_weeks(time_stamp=INIT_TIME):
    gps_epoch = datetime(1980, 1, 6)
    today = datetime.fromtimestamp(time_stamp)

    epochMonday = gps_epoch - timedelta(gps_epoch.weekday())
    todayMonday = today - timedelta(today.weekday())

    noWeeks = (todayMonday - epochMonday).days / 7 - 1
    return(noWeeks % 1024)

def main():

    logger = "initalize_telemetry "                   #change to appropriate loggin name / Probably need to remove this entirely
    
    parser = argparse.ArgumentParser()
    
    #Add argument for csv file list

    parser.add_argument('--config', '-c', nargs=1)
    parser.add_argument('--files', '-f', help='Telemetry files to parse', nargs='*')
    parser.add_argument('--delete', '-d', help='Deletes all telemetry entries', action='store_true')
    
    args = parser.parse_args()
    
    if args.config is not None:
        global SERVICES
        SERVICES = app_api.Services(args.config[0])
    else:
        SERVICES = app_api.Services(CONFIG_PATH)

    if args.files is not None:
        for f in args.files:
            if os.path.exists(f):
                if 'gps' in f.lower():
                    parse_csv(f, True, logger)
                    continue
                parse_csv(f, False, logger)
            else:
                error_msg = "Could not find initial tlm files."

                #print(error_msg)
                sys.stderr.write(error_msg + " Quitting...")
                sys.exit(-20)
        #print(f"{logger} info: Inserted initial telemetry.")
    
    if args.delete:
        del_all_telemetry(logger)

if __name__ == "__main__":
    main()