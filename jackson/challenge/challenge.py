from skyfield.api import Topos, load
import math
import random
import logging
import sys
import os
from datetime import datetime, timedelta, timezone

logging.disable(logging.INFO)

#Challenge
#Grab data from local text file for speed and consistency
#-------------------------------------------#
satellites = load.tle('stations.txt')
#-------------------------------------------#

SEED = int(os.getenv("SEED", 0))
random.seed(SEED)

#Calculate random time for player
#-------------------------------------------#
ts = load.timescale()
random_hour = random.randint(1, 23)
random_minute = random.randint(0, 59)
random_second = random.randint(0, 59)
t = ts.utc(2020, 3, 18, random_hour, random_minute, random_second)
#Return dynamically generated time to player
#print(f'DEBUG: {t.utc}') # OLD. Bad, very bad.
print(f'Please use the following time to find the correct satellite:(2020, 3, 18, {random_hour}, {random_minute}, {random_second}.0)')
sys.stdout.flush()
#-------------------------------------------#

#Satellite list from website has both integers and strings and we need only objects utilizing the strings
#-------------------------------------------#
string_only_satellites = []
for satellite in satellites:
    if isinstance(satellite, str):
        string_only_satellites.append(satellites[satellite])
#-------------------------------------------#

sys.stderr.write("Number of Satellites: %d\n" % len(string_only_satellites))
#Generate random satellite coordinates for player
#-------------------------------------------#
while True:
    random_satellite_number = random.randint(0, len(string_only_satellites) - 1)
    player_satellite_for_input_solver = string_only_satellites[random_satellite_number]
    string_only_satellites.pop(random_satellite_number)
    
    #Create first topocentric for comparison, testing to ensure satellites are not in a collision path
    bluffton = Topos('36.17237297 N','-115.13431754 W')
    difference = player_satellite_for_input_solver - bluffton

    #The result will be the position of the satellite relative to you as an observer (bluffton vairable). 
    topocentric = difference.at(t)

    restart = False
    for satellite in string_only_satellites:
        bluffton = Topos('36.17237297 N','-115.13431754 W')
        difference = satellite - bluffton
        
        #The result will be the position of the satellite relative to you as an observer (bluffton vairable). 
        topocentric2 = difference.at(t)
        difference_km = (topocentric2 - topocentric).distance().km
        if difference_km < 10.0:
            #Another satellite is within 10km
            restart = True
            sys.stderr.write("Satellite too close: %d\n" % difference_km)
            break
    if restart:
        continue
    sys.stderr.write("Using Satellite: %s\n" % player_satellite_for_input_solver)
    sys.stderr.flush()

    geocentric = player_satellite_for_input_solver.at(t)
    coordinates = geocentric.position.km.tolist()
    #Return dynamically generated geocentric coordinates to player
    print(f'Please use the following Earth Centered Inertial reference frame coordinates to find the satellite:{coordinates}')
    sys.stdout.flush()
    break
#-------------------------------------------#

#Player Input Solver
#-------------------------------------------#
random_times = []
r_times_pretty = []    
amount_of_times = 0
random.seed(datetime.now())
while True:
    if amount_of_times < 3:
        amount_of_times = amount_of_times + 1
        ts = load.timescale()
        random_hour = random.randint(1, 23)
        random_minute = random.randint(0, 59)
        random_second = random.randint(0, 59)
        random_times.append(ts.utc(2020, 3, 18, random_hour, random_minute, random_second))
        r_times_pretty.append(f'(2020, 3, 18, {random_hour}, {random_minute}, {random_second}.0)')
    else:
        break
        
#Upped it to 5 to give the users a couple of attempts if they accidently fat fingered their input or something
times_allowed = 0
while True:
    try:
        if times_allowed < 5:
            print(f'Current attempt:{times_allowed + 1}')
            sys.stdout.flush()
            times_allowed = times_allowed + 1
            geocentric = player_satellite_for_input_solver.at(random_times[0])
            coordinates = geocentric.position.km.tolist()
            print(f"What is the X coordinate at the time of:{r_times_pretty[0]}?")
            sys.stdout.flush()
            line = sys.stdin.readline().strip()
            user_input_coordinate = float(line)
            if isinstance(user_input_coordinate, float):
                if math.isclose(user_input_coordinate, coordinates[0], rel_tol=1e-2):
                    sys.stderr.write(f'The X coordinate for {r_times_pretty[0]} is correct!')
                    sys.stdout.flush()
                else:
                    print(f"DEBUG: {coordinates[0]}")
                    print(f'{user_input_coordinate} is incorrect, please try again and enter the the X  coordinate for the satellite at {r_times_pretty[0]}.')
                    sys.stdout.flush()
                    continue            
            else:
                print('Your input must be a floating point coordinate (J2000) in KM')
                sys.stdout.flush()
                continue
            print(f"What is the Y coordinate at the time of:{r_times_pretty[0]}?")
            sys.stdout.flush()
            line = sys.stdin.readline().strip()
            user_input_coordinate = float(line)
            if isinstance(user_input_coordinate, float):
                if math.isclose(user_input_coordinate, coordinates[1], rel_tol=1e-2):
                    print(f'The Y coordinate for {r_times_pretty[0]} is correct!')
                    sys.stdout.flush()
                else:
                    print(f'{user_input_coordinate} is incorrect, please try again and enter the the Y  coordinate for the satellite at {r_times_pretty[0].utc}.')
                    sys.stdout.flush()
                    continue
            else:
                print('Your input must be a floating point coordinate (J2000) in KM')
                sys.stdout.flush()
                continue
            print(f"What is the Z coordinate at the time of:{r_times_pretty[0]}?")
            sys.stdout.flush()
            line = sys.stdin.readline().strip()
            user_input_coordinate = float(line)
            if isinstance(user_input_coordinate, float):
                if math.isclose(user_input_coordinate, coordinates[2], rel_tol=1e-1):
                    print(f'The Z axis coordinate for {r_times_pretty[0]} is correct!')
                    sys.stdout.flush()
                    random_times.pop(0)
                    r_times_pretty.pop(0)
                    #Check to see if there are any more times in the list to be solved.
                    if random_times:
                        continue
                    else:
                        flag = os.getenv("FLAG", "FLAG{Placeholder}")
                        if flag:
                            print(flag)
                            sys.stdout.flush()
                        else:
                            print("This is to be removed but for final testing - !!!!FLAG_PLACEHOLDER!!!!")
                            sys.stdout.flush()
                        break
                else:
                    print(f'{user_input_coordinate} is incorrect, please try again and enter the the Z  coordinate for the satellite at {r_times_pretty[0].utc}.')
                    sys.stdout.flush()
                    continue
            else:
                print('Your input must be a floating point coordinate (J2000) in KM')
                sys.stdout.flush()
                continue
        else:
            break
    except:
        import sys
        sys.exc_info()
        if times_allowed == 5:
            print('Please try again!')
            sys.stdout.flush()
        else:
            print(f'Please enter the proper coordinate for the satellite at {r_times_pretty[0]}.')
            sys.stdout.flush()
#-------------------------------------------#
