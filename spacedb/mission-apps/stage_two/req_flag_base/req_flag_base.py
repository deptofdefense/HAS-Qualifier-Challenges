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
import subprocess
from datetime import datetime, timedelta
from app_api import CH_CONF_PATH as CONFIG_PATH

def check_sys_critical(logger):
    sys_crit = True
    with open('/challenge/mission-apps/pkls/update_tel/crit_val.pkl', 'rb') as pkl_file:
        sys_crit = pickle.load(pkl_file)
    
    with open('/challenge/mission-apps/pkls/update_tel/iflag.pkl', 'wb') as pkl_file:
        iflag = True
        pickle.dump(iflag, pkl_file)

    return sys_crit

def check_run():
    with open('/challenge/mission-apps/pkls/update_tel/iflag.pkl', 'rb') as pkl_file:
        iflag = pickle.load(pkl_file)
    
    return iflag


def main():

    logger = "req_flag_base "                  
    
    parser = argparse.ArgumentParser()
    
    #Add argument for csv file list

    parser.add_argument('--config', '-c', nargs=1)
    parser.add_argument('--win', '-w', action='store_true')
    
    args = parser.parse_args()
    
    if args.config is not None:
        global SERVICES
        SERVICES = app_api.Services(args.config[0])
    else:
        SERVICES = app_api.Services(CONFIG_PATH)

    # FIX: Possibly add function so that flag is only retrievable if system is reboot.

    if not check_run():
        if check_sys_critical(logger):
            print("")
            print(f"{logger} warn: System is critical. Flag not printed.")
    else:
        if check_sys_critical(logger):
            print("")
            print(f"{logger} warn: System is critical. Flag not printed.")
        else:
            run_list = ['/challenge/mission-apps/stage_two/win_check/win_check.py', '--lose']
            subprocess.Popen(run_list)
    print("")


if __name__ == "__main__":
    main()