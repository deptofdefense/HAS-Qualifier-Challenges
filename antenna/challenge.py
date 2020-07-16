#!/usr/bin/python3

import argparse
import time
import sys
import os
from orbit import SatelliteObserver
from antenna_control import AntennaController, AntennaDeterminator
from randomize_challenge import RandomChallengeFactory, RandomChallenge
from solution_file import SolutionFile, Observation, OutOfChalRange

WAIT_SEC = 1
AZIMUTH_TOLERANCE = 1
ELEVATION_TOLERANCE = 1

ARGS = [
    {
        'args': ('--longitude',),
        'kwargs': {
            'type': str,
            'help': "Longitude of observation point, in form '###.####W"
        }
    },
    {
        'args': ('--latitude',),
        'kwargs': {
            'type': str,
            'help': "Latitude of observation point, in form '###.####N"
        }
    },
    {
        'args': ('--start-time',),
        'kwargs': {
            'type': int,
            'help': 'Unix time GMT in seconds to start the observation'
        }
    },
    {
        'args': ('--observation-length',),
        'kwargs': {
            'type': int,
            'default': 10000,
            'help': 'Number of seconds to check'
        }
    },
    {
        'args': ('--sat-name',),
        'kwargs': {
            'type': str,
            'help': "Name of the satellite exactly as found in the TLE file"
        }
    },
    {
        'args': ('--groundstation-file',),
        'kwargs': {
            'type': str,
            'default': "/home/pi/orbit/data/worldcities_agg.csv",
            'help': "Local path to file of groundstation locations"
        }
    },
    {
        'args': ('--tle-file',),
        'kwargs': {
            'type': str,
            'default': "/home/pi/orbit/noaa-20200409.txt",
            'help': "Local path to TLE file of satellite orbit parameters (e.g. http://celestrak.com/NORAD/elements/noaa.txt)"
        }
    },
    {
        'args': ('--solution-file',),
        'kwargs': {
            'type': str,
            'help': "Local path to file to check (stdin if omitted)"
        }
    },

]


class Challenge:
    def __init__(self, seed: int, tle_path: str, groundstation_path: str, observations: int=0,
                 latitude: float=None, longitude: float=None, start_time: float=None, sat_name: str=None):
        if latitude and longitude and start_time and sat_name and observations:
            self.latitude = latitude
            self.longitude = longitude
            self.start_time = start_time
            self.sat_name = sat_name
            self.observations = observations
        else:
            generator = RandomChallengeFactory(tle_path, groundstation_path)
            random_challenge = generator.create_random_challenge(seed)
            self.latitude = random_challenge.groundstation_location.latitude
            self.longitude = random_challenge.groundstation_location.longitude
            self.start_time = random_challenge.observation_time
            self.sat_name = random_challenge.satellite.name
            self.observations = random_challenge.observation_length


def main(args):

    flag = os.getenv("FLAG")
    seed = int(os.getenv("SEED"))
    azimuth_tolerance = float(os.getenv("AZIMUTH_TOLERANCE", AZIMUTH_TOLERANCE))
    elevation_tolerance = float(os.getenv("ELEVATION_TOLERANCE", ELEVATION_TOLERANCE))
    time_interval = float(os.getenv("WAIT_SEC", WAIT_SEC))
    if flag is None:
        print("Error: no FLAG environment variable provided", file=sys.stderr)
        exit(1)
    if seed is None:
        print("Error: no SEED environment variable provided", file=sys.stderr)
        exit(1)

    challenge = Challenge(seed, args.tle_file, args.groundstation_file,
                          latitude=args.latitude, longitude=args.longitude, start_time=args.start_time,
                          sat_name=args.sat_name, observations=args.observation_length)

    observer = SatelliteObserver.from_strings(challenge.longitude, challenge.latitude, challenge.sat_name, tle_file=args.tle_file)
    antenna = AntennaController(motion_restrict=False, simulate=True)
    antenna_checker = AntennaDeterminator()

    print("Track-a-sat control system", file=sys.stdout)
    print("Latitude: {}".format(challenge.latitude), file=sys.stdout)
    print("Longitude: {}".format(challenge.longitude), file=sys.stdout)
    print("Satellite: {}".format(challenge.sat_name), file=sys.stdout)
    print("Start time GMT: {}".format(challenge.start_time), file=sys.stdout)
    print("{} observations, one every {} second{}".format(challenge.observations, WAIT_SEC, "" if WAIT_SEC == 1 else "s"), file=sys.stdout)
    print("Waiting for your solution followed by a blank line...\n")

    try:
        if args.solution_file:
            solution = SolutionFile.from_file(args.solution_file)
        else:
            solution = SolutionFile.from_stdin()
    except OutOfChalRange as e:
        print(str(e))
        exit()
    except:
        print("Bad solution format", file=sys.stdout)
        exit()

    if len(solution.observations) != challenge.observations:
        print("Incorrect number of observations. Expected {}, got {}".format(challenge.observations, len(solution.observations)), file=sys.stderr)
        print("Incorrect", file=sys.stdout)
        exit()

    start = time.time()
    now = start
    for i in range(1, challenge.observations + 1):
        difference = now - start
        current_time = challenge.start_time + difference
        altitude, azimuth, distance = observer.altAzDist_at(current_time)
        visible = observer.above_horizon(current_time)
        if visible:
            antenna.set_azimuth(azimuth)
            antenna.set_elevation(altitude)
            correct_azimuth = azimuth
            correct_elevation = altitude
        else:
            antenna.set_azimuth(0)
            antenna.set_elevation(0)
            correct_azimuth = 0
            correct_elevation = 0
        (az_duty, el_duty) = antenna.get_duty_cycles()
        #print("{}: {} at ({}, {}) from {} ({}) duty cycle: ({}, {}) [{}]".format(datetime.datetime.utcfromtimestamp(current_time),
        #                                                                    observer.sat_name, azimuth, altitude, observer.where,
        #                                                                    "visible" if visible else "not visible",
        #                                                                    az_duty, el_duty, i))
        soln_obs = solution.observations[i - 1]
        antenna_checker.set_duty_cycle(soln_obs.az_duty, soln_obs.el_duty)
        (checker_az, checker_el) = antenna_checker.get_angles()
        if abs(correct_azimuth - checker_az) > azimuth_tolerance:
            print("Azimuth mismatch at time {}: expected {}, got {}".format(current_time, azimuth, checker_az), file=sys.stderr)
            print("Incorrect", file=sys.stdout)
            exit()
        if abs(correct_elevation - checker_el) > elevation_tolerance:
            print("Elevation mismatch at time {}: expected {}, got {}".format(current_time, altitude, checker_el), file=sys.stderr)
            print("Incorrect", file=sys.stdout)
            exit()
        if abs(current_time - soln_obs.timestamp) > 1.5:
            print("Timestamp mismatch at time {}: expected {}, got {}".format(current_time, current_time, soln_obs.timestamp), file=sys.stderr)
            print("Incorrect", file=sys.stdout)
            exit()
        now += time_interval

    #print("Completed {} comparisons in {}, looks good".format(args.observation_length, args.solution_file))
    print("Congratulations: {}".format(flag), file=sys.stdout)
    print("success, exiting", file=sys.stderr)
    exit()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="~~~ Hacksat easy 1 ~~~")
    for arg in ARGS:
        parser.add_argument(*arg['args'], **arg['kwargs'])
    args = parser.parse_args()
    main(args)