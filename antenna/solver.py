#!/usr/bin/python3
import socket
import argparse
import time
import datetime
import sys, os
import re
from attr import dataclass
from orbit import SatelliteObserver
from antenna_control import AntennaController, AntennaDeterminator
from solution_file import SolutionFile, Observation

WAIT_SEC = 1

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
        'args': ('--verbose',),
        'kwargs': {
            'action': 'store_true',
            'default': False,
            'help': "Local path to file to write (stdout if omitted)"
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
            'help': "Local path to file to write (stdout if omitted)"
        }
    },

]

@dataclass
class Challenge:
    latitude: float
    longitude: float
    sat_name: str
    start_time: float
    observations: int
    wait_seconds: float

CHALLENGE_FORMAT = ("Track-a-sat control system\n"
                    "Latitude: (-?[0-9]{1,3}\.[0-9]{1,7})\n"
                    "Longitude: (-?[0-9]{1,3}\.[0-9]{1,7})\n"
                    "Satellite: (.+)\n"
                    "Start time GMT: ([0-9]{10}\.?[0-9]{0,8})\n"
                    "([0-9]+) observations, one every ([0-9]+\.?[0-9]{0,8}) seconds?\n"
                    "Waiting for your solution followed by a blank line...\n")

def read_challenge_from_stdin(verbose: bool) -> Challenge:
    lines = []
    for i in range(8):
        lines.append(sys.stdin.readline())
    challenge = "".join(lines)
    if verbose:
        print(challenge, file=sys.stderr)
    match = re.match(CHALLENGE_FORMAT, challenge)
    #match1 = re.match("Latitude: (-?[0-9]{1,3}\.[0-9]{1,7})\n", lines[1])
    #match2 = re.match("Longitude: (-?[0-9]{1,3}\.[0-9]{1,7})\n", lines[2])
    #match3 = re.match("Satellite: (.+)\n", lines[3])
    #match4 = re.match("Start time GMT: ([0-9]{10}\.?[0-9]{0,8})\n", lines[4])
    #match5 = re.match("([0-9]+) observations, one every ([0-9]+\.?[0-9]{0,8}) seconds?\n", lines[5])
    #print("well?")
    latitude = float(match.group(1))
    longitude = float(match.group(2))
    sat_name = match.group(3)
    start_time = float(match.group(4))
    observations = int(match.group(5))
    wait_sec = float(match.group(6))
    return Challenge(latitude, longitude, sat_name, start_time, observations, wait_sec)


def read_challenge_from_socket(fsock):
    lines = []
    for i in range(8):
        lines.append(fsock.readline())
    challenge = "".join(lines)
    match = re.match(CHALLENGE_FORMAT, challenge)
    #match1 = re.match("Latitude: (-?[0-9]{1,3}\.[0-9]{1,7})\n", lines[1])
    #match2 = re.match("Longitude: (-?[0-9]{1,3}\.[0-9]{1,7})\n", lines[2])
    #match3 = re.match("Satellite: (.+)\n", lines[3])
    #match4 = re.match("Start time GMT: ([0-9]{10}\.?[0-9]{0,8})\n", lines[4])
    #match5 = re.match("([0-9]+) observations, one every ([0-9]+\.?[0-9]{0,8}) seconds?\n", lines[5])
    #print("well?")
    latitude = float(match.group(1))
    longitude = float(match.group(2))
    sat_name = match.group(3)
    start_time = float(match.group(4))
    observations = int(match.group(5))
    wait_sec = float(match.group(6))
    return Challenge(latitude, longitude, sat_name, start_time, observations, wait_sec)


def main_socket():
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31337))
    
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    fsock = sock.makefile('rw')
    
    ticket = os.getenv("TICKET","")
    if len(ticket):
        print(fsock.readline().strip())
        fsock.write(ticket +'\n')
        fsock.flush()
        print("Sent Ticket: ", ticket)
 
    challenge = read_challenge_from_socket(fsock)

    observer = SatelliteObserver.from_strings(challenge.longitude, challenge.latitude, challenge.sat_name,
                                              tle_file=args.tle_file)
    antenna = AntennaController(motion_restrict=False, simulate=True)

    observations = []
    start = int(time.time())
    now = start

    for i in range(1, challenge.observations + 1):
        difference = now - start
        current_time = challenge.start_time + difference
        altitude, azimuth, distance = observer.altAzDist_at(current_time)
        visible = observer.above_horizon(current_time)
        if visible:
            antenna.set_azimuth(azimuth)
            antenna.set_elevation(altitude)
        else:
            antenna.set_azimuth(0)
            antenna.set_elevation(0)
        (az_duty, el_duty) = antenna.get_duty_cycles()
       
        obs = Observation(timestamp=current_time, az_duty=az_duty, el_duty=el_duty)
        observations.append(obs)
        now += WAIT_SEC
    
    print("Sending Solution...")
    sys.stdout.flush()

    finish = time.time()
    output = SolutionFile(observations)
    for obs in output.observations:
        fsock.write("{}, {}, {}\n".format(obs.timestamp, obs.az_duty, obs.el_duty))
    fsock.write('\n')
    fsock.flush()
    result = fsock.readline()
    print("got back: {}".format(result), file=sys.stderr)

def main(args):

    if args.latitude and args.longitude and args.start_time and args.sat_name and args.observation_length:
        challenge = Challenge(args.latitude, args.longitude, args.sat_name, args.start_time, args.observation_length, WAIT_SEC)
    else:
        challenge = read_challenge_from_stdin(args.verbose)

    observer = SatelliteObserver.from_strings(challenge.longitude, challenge.latitude, challenge.sat_name,
                                              tle_file=args.tle_file)
    antenna = AntennaController(motion_restrict=False, simulate=True)

    observations = []
    start = int(time.time())
    now = start

    for i in range(1, challenge.observations + 1):
        difference = now - start
        current_time = challenge.start_time + difference
        altitude, azimuth, distance = observer.altAzDist_at(current_time)
        visible = observer.above_horizon(current_time)
        if visible:
            antenna.set_azimuth(azimuth)
            antenna.set_elevation(altitude)
        else:
            antenna.set_azimuth(0)
            antenna.set_elevation(0)
        (az_duty, el_duty) = antenna.get_duty_cycles()
        if args.verbose:
            print("{}: {} at ({}, {}) from {} ({}) duty cycle: ({}, {})".format(
                datetime.datetime.utcfromtimestamp(current_time),
                observer.sat_name, azimuth, altitude, observer.where,
                "visible" if visible else "not visible",
                az_duty, el_duty), file=sys.stderr)

        obs = Observation(timestamp=current_time, az_duty=az_duty, el_duty=el_duty)
        observations.append(obs)
        now += WAIT_SEC

    finish = time.time()
    output = SolutionFile(observations)
    if args.solution_file:
        output.to_file(args.solution_file)
        print("Wrote solution {} in {} sec".format(args.solution_file, finish - start), file=sys.stderr)
    else:
        output.to_stdout()
        print("wrote {} lines to stdout".format(len(observations) + 1), file=sys.stderr)
    result = sys.stdin.readline()
    print("got back: {}".format(result), file=sys.stderr)
    #print("Wrote solution {} in {} sec".format(args.solution_file, finish - start))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="~~~ Hacksat easy 1 ~~~")
    for arg in ARGS:
        parser.add_argument(*arg['args'], **arg['kwargs'])
    args = parser.parse_args()
    main_socket()
