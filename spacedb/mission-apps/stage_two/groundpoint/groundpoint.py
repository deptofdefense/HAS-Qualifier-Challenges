#!/usr/bin/env python3

# What needs to be done:

# Prints flag to the log on reboot.

import subprocess
import argparse
import app_api
import sys
import time
import toml
import random
import pickle
import csv
from datetime import datetime, timedelta
from app_api import CH_CONF_PATH as CONFIG_PATH

def noSun():

    sunpoint_on = False
    tsun_start = None

    with open('/challenge/mission-apps/pkls/sunpoint_on.pkl', 'wb') as pkl_file:
        pickle.dump(sunpoint_on, pkl_file)
        pickle.dump(tsun_start, pkl_file)

    return datetime.utcnow()

def main():

    logger = "groundpoint "                  #change to appropriate loggin name / Probably need to remove this entirely
    
    parser = argparse.ArgumentParser()
    
    #Add argument for csv file list

    parser.add_argument('--config', '-c', nargs=1)
    
    args = parser.parse_args()
    
    if args.config is not None:
        global SERVICES
        SERVICES = app_api.Services(args.config[0])
    else:
        SERVICES = app_api.Services(CONFIG_PATH)

    print(f"{logger} info: Adjusting to groundpoint...")
    sys.stdout.flush()

    time_set = noSun()
    time.sleep(1)
    print(f'{logger} info: [{time_set.strftime("%Y-%m-%d %H:%M:%S")}] Groundpoint panels: SUCCESS')
    sys.stdout.flush()
    
    run_list = ['/challenge/mission-apps/stage_two/win_check/win_check.py', '--lose', '--ground']
    p = subprocess.Popen(run_list)
    p.communicate()
    print('')

if __name__ == "__main__":
    main()