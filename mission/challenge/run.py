from satellite import Satellite, MissionFailure
import os
from datetime import datetime, timezone, timedelta
import argparse
import json
from timeout import timeout, TimeoutError
import sys
import time

def setUp():
    with open('instructions.txt', 'r') as f:
        instructions = f.read()

    with open('winMessage.txt', 'r') as f:
        win_message = f.read()

    print(instructions)
    sys.stdout.flush()

    return win_message

# USA 224 (NRO sat that took the trump photo)
TLE_1 = "1 37348U 11002A   20053.50800700  .00010600  00000-0  95354-4 0    09"
TLE_2 = "2 37348  97.9000 166.7120 0540467 271.5258 235.8003 14.76330431    04"

# Fairbanks NOAA Station
GS_LAT = "64.977488 N"
GS_LONG = "147.510697 W"

# Imaging Target Location - Iranian Space Port
TARGET_LAT = "35.234722 N"
TARGET_LONG = "53.920833 E"

# Time Window
T0 = [2020, 4, 22]
DURATION = 48  # HOURS

SATELLITE = Satellite(
    TLE_1, TLE_2,
    GS_LAT, GS_LONG,
    TARGET_LAT, TARGET_LONG,
    T0, DURATION)

# Challenge start


@timeout(int(os.getenv("TIMEOUT", 300)))
def main():
    #print("Please input mission plan in order by time.")
    #print("Each line must be a timestamp followed by the mode with the format: \n")
    #print("YYYY-MM-DDThh:mm:ssZ new_mode")
    #print('\nEntering "run" will start the simulation, "plan" will list the current plan entries, and "exit" will cause it to exit.')
    #print('Once plan is executed, it will not be saved, so make note of your plan elsewhere.\n')
    #sys.stdout.flush()

    win_message = setUp()       # Prints the instruction text. Returns win ascii art
    
    mission_plan = []
    previous_time = SATELLITE.start_time - timedelta(minutes=1)
    previous_mode = None
    success = False
    while True:
        line = sys.stdin.readline()
        if len(line) == 0:
            break

        if 'run' == line.rstrip().lower():
            if mission_plan == []:
                print("Mission plan must have at least 1 entry. Exiting.")
            else:
                print("Executing the following mission plan:")
                for entry in mission_plan:
                    print(f"    {entry[0].strftime('%Y-%m-%dT%H:%M:%SZ')} {entry[1]}")
                try:
                    success = SATELLITE.execute_mission_plan(mission_plan=mission_plan)
                    if success:
                        print(win_message)
                        print(os.getenv('FLAG','flag{placeholder}'))
                    else:
                        print("Mission Failed.")
                except MissionFailure as e:
                    print(f"Mission Failed. {e}")
                sys.stdout.flush()
            break
        elif 'plan' == line.rstrip():
            if mission_plan == []:
                print("No mission plan entries.\n")
                sys.stdout.flush()
            else:
                print("Current mission plan: ")
                for entry in mission_plan:
                    print(f"{entry[0].strftime('%Y-%m-%dT%H:%M:%SZ')} {entry[1]}")
                sys.stdout.flush()
        elif 'exit' == line.rstrip():
            print("Goodbye.\n")
            break

        else:
            try:
                entry = line.split(" ")
                if len(entry) < 2:
                    raise Exception
                mode = entry[1].rstrip()
                time = datetime.strptime(entry[0], "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=timezone.utc)
                if mode not in SATELLITE.possible_modes:
                    print(f"invalid mode: {mode}. Possible modes: {SATELLITE.possible_modes}")
                elif mission_plan == [] and time != SATELLITE.start_time:
                    print(
                        f"First entry must be at the start time: {SATELLITE.start_time.strftime('%Y-%m-%dT%H:%M:%SZ')}")
                elif time.second != 0:
                    print("Simluation runs per minute. Seconds must be be 00 for timestamps.")
                elif time < SATELLITE.start_time:
                    print("time is before mission start time.")
                elif time >= SATELLITE.end_time:
                    print("time is after mission end time")
                elif time - previous_time < timedelta(minutes=1):
                    print("time must increase by at least 1 minute for each entry.")
                elif mode == previous_mode:
                    print(
                        f"mode ({mode}) is the same as the previous mode ({previous_mode}). Each entry must correspond to a change in mode.")
                else:
                    mission_plan.append([time, mode])
                    previous_time = time
                    previous_mode = mode
                sys.stdout.flush()
            except Exception as e:
                print("Entry is invalid. Please ensure it is the proper format: YYYY-MM-DDThh:mm:00Z new_mode\n")
                sys.stdout.flush()

if __name__ == "__main__":
    try: 
        main()
    except TimeoutError: 
        print("Timeout, Goodbye\n")
        sys.stdout.flush()
