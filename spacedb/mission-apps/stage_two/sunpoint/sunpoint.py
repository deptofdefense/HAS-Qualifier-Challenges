#!/usr/bin/env python3

# What needs to be done:

# Prints flag to the log on reboot.

import argparse
import app_api
import sys
import time
import toml
import random
import pickle
import csv
from datetime import datetime, timedelta, timezone
from app_api import CH_CONF_PATH as CONFIG_PATH

def set_sunpoint_value():

    sunpoint_on = True
    tsun_start = datetime.utcnow()

    with open('/challenge/mission-apps/pkls/sunpoint_on.pkl', 'wb') as pkl_file:
        pickle.dump(sunpoint_on, pkl_file)
        pickle.dump(tsun_start, pkl_file)

    return True, tsun_start

def main():

    logger = "sunpoint "                  #change to appropriate loggin name / Probably need to remove this entirely
    
    parser = argparse.ArgumentParser()
    
    #Add argument for csv file list

    parser.add_argument('--config', '-c', nargs=1)
    
    args = parser.parse_args()
    
    if args.config is not None:
        global SERVICES
        SERVICES = app_api.Services(args.config[0])
    else:
        SERVICES = app_api.Services(CONFIG_PATH)

    sys.stdout.flush()
    print(f"{logger} info: Adjusting to sunpoint...")
    _, time_set = set_sunpoint_value()
    time.sleep(1)
    sys.stdout.flush()
    print(f'{logger} info: [{time_set.strftime("%Y-%m-%d %H:%M:%S")}] Sunpoint panels: SUCCESS')
    sys.stdout.flush()
    print('')

if __name__ == "__main__":
    main()