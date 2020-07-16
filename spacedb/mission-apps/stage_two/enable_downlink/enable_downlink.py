#!/usr/bin/env python3

# What needs to be done:

# Prints flag to the log on reboot.

import argparse
import subprocess
import app_api
import sys
import time
import toml
import random
import pickle
import csv
from datetime import datetime, timedelta
from app_api import CH_CONF_PATH as CONFIG_PATH

def main():

    logger = "enable_downlink "                  #change to appropriate loggin name / Probably need to remove this entirely
    
    parser = argparse.ArgumentParser()
    
    #Add argument for csv file list

    parser.add_argument('--config', '-c', nargs=1)
    
    args = parser.parse_args()
    
    if args.config is not None:
        global SERVICES
        SERVICES = app_api.Services(args.config[0])
    else:
        SERVICES = app_api.Services(CONFIG_PATH)

    run_list = ['/challenge/mission-apps/stage_two/win_check/win_check.py', '--lose']
    subprocess.Popen(run_list)

    print('')

if __name__ == "__main__":
    main()