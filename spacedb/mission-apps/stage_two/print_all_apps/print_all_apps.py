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
from datetime import datetime, timedelta
from app_api import CH_CONF_PATH as CONFIG_PATH

def check_sys_critical(logger):
    sys_crit = True
    with open('/challenge/mission-apps/pkls/update_tel/crit_val.pkl', 'rb') as pkl_file:
        sys_crit = pickle.load(pkl_file)
    
    return sys_crit

def get_apps(logger):
    print(f'{logger} info: Getting all registered mission apps.')
    request = "{registeredApps{app{name, version, executable, author, config},active}}"

    try:
        response = SERVICES.query(service='app-service', query=request)
        print(f'{logger} info: Registered Apps: ')
        organize_apps(logger, response)
    except Exception as e:
        print(f"{logger} err: Getting registered mission apps failed: %s" % str(e) + "")

def organize_apps(logger, appString):
    for app in appString['registeredApps']:
        print("  Name: \t" + app['app']['name'])
        print("  Version: \t" + app['app']['version'])
        print("  Executable: \t" + app['app']['executable'].split('/')[-1])
        print("  Author: \t" + app['app']['author'])
        print("  Config: \t" + app['app']['config'])

    return

def main():

    logger = "print_all_apps "                  #change to appropriate loggin name / Probably need to remove this entirely
    
    parser = argparse.ArgumentParser()
    
    #Add argument for csv file list

    parser.add_argument('--config', '-c', nargs=1)
    
    args = parser.parse_args()
    
    if args.config is not None:
        global SERVICES
        SERVICES = app_api.Services(args.config[0])
    else:
        SERVICES = app_api.Services(CONFIG_PATH)

    if(not check_sys_critical(logger)):
        get_apps(logger)
    else:
        print(f"{logger} warn: System critical.")

    print('')

if __name__ == "__main__":
    main()