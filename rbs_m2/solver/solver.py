import argparse
import csv
import re
import sys, os
import struct
from attr import dataclass
from abc import abstractmethod
from typing import Iterator, List, Tuple, Set

#from skyfield.sgp4lib import EarthSatellite
from skyfield.api import load, Topos, EarthSatellite

from randomize_challenge import RandomChallengeFactory, Groundstation
from orbit import SatelliteObserver
from antenna_control import AntennaController, AntennaDeterminator
import socket

NUM_CHALLENGE_SATS = 3
OBSERVATION_INTERVAL = 1.0
AZIMUTH_TOLERANCE = 1.0
ELEVATION_TOLERANCE = 1.0
MISMATCHES_ALLOWED = 5
THRESHOLD_DB = -60
VERY_LOW_DB = -120
#SAMPLE_HZ = 2048000
SAMPLE_HZ = 50 * 2048
TIMESTEP = 1.0/SAMPLE_HZ
PEAK_GROUP_THRESHOLD = 750   # max data points between start peak and end peak
                             # depends on sample rate and duty cycle range
MIN_DUTY_CYCLE = 0.05
MAX_DUTY_CYCLE = 0.35

ARGS = [
    {
        'args': ('--tle-file',),
        'kwargs': {
            'type': str,
            'help': "Local path to TLE file of satellite orbit parameters (e.g. http://celestrak.com/NORAD/elements/noaa.txt)",
            'required': True
        }
    },
    {
        'args': ('--motor-data',),
        'kwargs': {
            'type': str,
            'help': "Local path to CSV file containing data for a motor. Three should be supplied",
            'required': True,
            'action': 'append'
        }
    },
]

CHALLENGE_FORMAT = ("Track-a-sat RF side channel detector\n"
                    "Groundstation location: latitude (-?[0-9]{1,3}\.[0-9]{1,7}), longitude (-?[0-9]{1,3}\.[0-9]{1,7})\n"                    
                    "Observation start time GMT: ([0-9]{10}\.?[0-9]{0,8})\n"
                    "Observation length \(seconds\): ([0-9\.]+)\n"
                    "Challenge file 1: (.+)\n"
                    "Challenge file 2: (.+)\n"
                    "Challenge file 3: (.+)\n"
                    "Please submit 3 satellite names as listed in active.txt \(one per line, followed by a blank line\)\n")

@dataclass
class Challenge:
    latitude: float
    longitude: float
    start_time: float
    observation_seconds: float


class ChallengeData(object):
    @abstractmethod
    def iterate_db_data(self):
        # type: () -> Iterator[float]
        raise NotImplementedError


class FileChallengeData(ChallengeData):
    def __init__(self, csv_data_path: str):
        self.csv_data_path = csv_data_path

    #def iterate_db_data(self):
    #    # type: () -> Iterator[Tuple[float, float, float]]
    #    with open(self.csv_data_path) as csv_file:
    ##        csv_reader = csv.reader(csv_file, delimiter=',')
    #        for row in csv_reader:
    #            # filter the data so only the significant peaks are visible
    #            # the THRESHOLD DB is set arbitrarily
    #            time = float(row[0].encode('ascii', 'ignore')) # strip unicode no width space
    #            az_db = float(row[1].encode('ascii', 'ignore'))
    #            az_db = VERY_LOW_DB if az_db < THRESHOLD_DB else az_db
    #            el_db = float(row[2].encode('ascii', 'ignore'))
    #            el_db = VERY_LOW_DB if el_db < THRESHOLD_DB else el_db
    #            yield(time, az_db, el_db)  # assuming we will generate a CSV with 3 columns, (time, az_db, el_db)

    def iterate_db_data(self):
        twosamples = True
        if twosamples:
            sample_fmt = "<ff"
            size = 8
        else:
            sample_fmt = "<f"
            size = 4
        with open(self.csv_data_path, 'rb') as f:
            i = 0
            while True:
                try:
                    data = f.read(size)
                    if len(data) < size:
                        break
                    result = struct.unpack_from(sample_fmt, data)
                    az_db = VERY_LOW_DB if result[0] < THRESHOLD_DB else result[0]
                    el_db = VERY_LOW_DB if result[1] < THRESHOLD_DB else result[1]
                    yield (i*TIMESTEP, az_db, el_db)
                    i += 1

                except EOFError:
                    break


def main(args):
    """
    Accepts a wav or csv file.
    1. Identify peak pairs
    2. Find distance between each peak pair
    3. Find distance between peak pairs
    4. Calculate PWM: duty cycle values over time
    5. Calculate antenna motion from PWM
    6. Identify satellite given antenna location, time, and motion
    :return:
    """
    #random_challenge_factory = RandomChallengeFactory(args.tle_file, args.groundstation_file)
    #challenge = random_challenge_factory.create_random_challenge(args.seed)
    
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31337))
    
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    fsock = sock.makefile('rw')
    
    Ticket = os.getenv("TICKET", "")
    if len(Ticket):
        fsock.readline()
        fsock.write(Ticket + "\n")
        fsock.flush()
        print("Sent Ticket: " + Ticket)

    challenge = read_challenge_from_fsock(fsock, True)

    _satellites = load.tle(args.tle_file)
    _sats_by_name = {sat.name: sat for sat in _satellites.values()}
    satellites = [sat for sat in _sats_by_name.values()]

    assert len(args.motor_data) == NUM_CHALLENGE_SATS, "Three paths to motor data files are required!"

    calculated_satellite_targets: List[EarthSatellite] = []

    DIR = os.getenv("DIR", "/mnt")
    for motor_data in args.motor_data:
        duty_cycle_over_time = get_duty_cycle_over_time(DIR + "/" + motor_data)
        sat_target = get_satellite_target(
            satellites,
            duty_cycle_over_time,
            Groundstation(challenge.latitude, challenge.longitude),
            challenge.start_time
        )

        calculated_satellite_targets.append(sat_target.name)

    if len(calculated_satellite_targets) != NUM_CHALLENGE_SATS:
        print("Did not calculate {} sats! {}".format(NUM_CHALLENGE_SATS, len(calculated_satellite_targets)), file=sys.stderr)
        exit(1)

    for sat_name in calculated_satellite_targets:
        print("Calculated sat: {}".format(sat_name), file=sys.stderr)
        fsock.write(sat_name + "\n")
        fsock.flush()
    fsock.write("\n")
    fsock.flush()
    result = fsock.readline()
    print("got back: {}".format(result), file=sys.stderr)

    #expected_sat_targets = set([sat.name for sat in challenge.satellites])
    #assert expected_sat_targets == calculated_satellite_targets


def read_challenge_from_fsock(fsock, verbose: bool) -> Challenge:
    lines = []
    for i in range(8):
        lines.append(fsock.readline())
    challenge = "".join(lines)
    if verbose:
        print("Received challenge description: ", file=sys.stderr)
        print(challenge, file=sys.stderr)
    match = re.match(CHALLENGE_FORMAT, challenge)

    latitude = float(match.group(1))
    longitude = float(match.group(2))

    start_time = float(match.group(3))
    observation_seconds = float(match.group(4))
    file_1 = match.group(5)
    file_2 = match.group(6)
    file_3 = match.group(7)
    return Challenge(latitude, longitude, start_time, observation_seconds)


def get_duty_cycle_over_time(motor_data_path):
    # type: (str) -> List[Tuple[float, float, float]]
    """
    Can be adapted from Brenda's script
    :param motor_data_path:
    :return: List of (timestamp, az duty, el duty) pairs
    """

    challenge_data = FileChallengeData(motor_data_path)

    timestamps = []
    azimuth_data = []
    elevation_data = []
    print("Reading data...", file=sys.stderr)
    for data_point in challenge_data.iterate_db_data():
        timestamps.append(data_point[0])
        azimuth_data.append(data_point[1])
        elevation_data.append(data_point[2])

    print("Calculating azimuth...", file=sys.stderr)
    azimuth_duty_cycle_values = get_duty_cycles(azimuth_data)
    print("Calculating elevation...", file=sys.stderr)
    elevation_duty_cycle_values = get_duty_cycles(elevation_data)
    result = []

    assert len(azimuth_duty_cycle_values) == len(elevation_duty_cycle_values)

    result.append((timestamps[azimuth_duty_cycle_values[0][0]], azimuth_duty_cycle_values[0][1],
                   elevation_duty_cycle_values[0][1]))
    # detect changes in the duty cycle at a timestamp
    for i in range(1, len(azimuth_duty_cycle_values)):
        # make sure our azimuth and elevation observations are around the same time ... we have messed around with these lists a lot
        assert int(round(azimuth_duty_cycle_values[i][0], -5)) == int(round(elevation_duty_cycle_values[i][0], -5))
        # detect changes
        if azimuth_duty_cycle_values[i][1] != azimuth_duty_cycle_values[i - 1][1] or \
                elevation_duty_cycle_values[i][1] != elevation_duty_cycle_values[i - 1][1]:
            result.append( (timestamps[azimuth_duty_cycle_values[i][0]], azimuth_duty_cycle_values[i][1], elevation_duty_cycle_values[i][1]) )
    return result

def get_duty_cycles(db_data: List[float]) -> List[Tuple[int, int]]:
    """
    :param db_data:
    :return: list of observation indexes and the duty cycle for it: Tuple(index, duty_cycle)
    """
    peaks = detect_peaks(db_data)
    duty_cycle_fractions = calculate_duty_cycle_fractions(peaks)
    antenna = AntennaController(motion_restrict=False, simulate=True)
    min_duty = antenna.azimuth_servo._min_duty
    duty_range = antenna.azimuth_servo._duty_range
    duty_cycle_indexes_values = []
    for i, fraction in enumerate(duty_cycle_fractions):
        duty_cycle_int = int(min_duty + fraction*duty_range)
        duty_cycle_indexes_values.append((peaks[i][0], duty_cycle_int))
    #duty_cycle_values = [ (, int(min_duty + fraction*duty_range)) for fraction in duty_cycle_fractions]
    return duty_cycle_indexes_values

def detect_peaks(db_data: List[float]) -> List[List[int]]:
    # peak detection: collect the timestamps of the peaks
    peak_timestamps = []
    for i in range(1, len(db_data) - 1):
        if db_data[i] > db_data[i + 1] and db_data[i] > db_data[i - 1]:
            peak_timestamps.append(i)

    # grouping peaks together: looking at the graph, it seems like the peaks come in pairs
    # group those peaks together
    temp_group = []
    final_peak_groups = []
    for t in peak_timestamps:
        if len(temp_group) == 0:
            temp_group.append(t)
        else:
            if (t - temp_group[-1]) < PEAK_GROUP_THRESHOLD:
                temp_group.append(t)
            else:
                # make sure we are dealing with a pair of peaks
                assert (len(temp_group) <= 2), "bad group: {}".format(temp_group)
                if len(temp_group) == 2:
                    final_peak_groups.append(temp_group)
                temp_group = [t]
    return final_peak_groups

def calculate_duty_cycle_fractions(peak_pairs: List[List[float]]) -> List[float]:
    # stat 1: time difference within a group
    time_diff = [peak[1] - peak[0] for peak in peak_pairs]
    # stat 2: time difference between groups
    inter_time_diff = [peak_pairs[i][0] - peak_pairs[i - 1][0] for i in
                       range(1, len(peak_pairs))]
    # stat 4: duty cycle
    duty_cycle_range = MAX_DUTY_CYCLE - MIN_DUTY_CYCLE
    duty_cycle = [time_diff[i]/float(inter_time_diff[i]) for i in range(len(inter_time_diff))]
    scaled_duty_cycle = [(value - MIN_DUTY_CYCLE) / duty_cycle_range for value in duty_cycle]
    return scaled_duty_cycle


class WrongSatellite(ValueError):
    pass


def azimuth_tolerance(current_azimuth: float, previous_azimuth: float) -> float:
    difference = abs(current_azimuth - previous_azimuth)
    if difference < AZIMUTH_TOLERANCE:
        if difference > 0.75*AZIMUTH_TOLERANCE:
            return 1.5 * AZIMUTH_TOLERANCE
        return AZIMUTH_TOLERANCE
    return 1.5 * difference

def elevation_tolerance(current_elevation: float, previous_elevation: float) -> float:
    difference = abs(current_elevation - previous_elevation)
    if difference < ELEVATION_TOLERANCE:
        if difference > 0.75*ELEVATION_TOLERANCE:
            return 1.5 * ELEVATION_TOLERANCE
        return ELEVATION_TOLERANCE
    return 1.5 * difference

def get_satellite_target(
        satellites: List[EarthSatellite],
        duty_cycle_over_time: List[Tuple[float, float, float]],
        groundstation_location: Groundstation,
        observation_time: float,
    ) -> EarthSatellite:
    #start = time.time()
    #antenna = AntennaController(motion_restrict=False, simulate=True)
    correct_antenna = AntennaDeterminator()
    groundstation_loc = Topos(groundstation_location.latitude, groundstation_location.longitude)
    targets = []

    #min_duty = antenna.azimuth_servo._min_duty
    #max_duty = antenna.azimuth_servo._min_duty + antenna.azimuth_servo._duty_range


    for candidate in satellites:
        print("\rTrying {}     \t\t".format(candidate.name), file=sys.stderr, end ="", flush=True)
        observer = SatelliteObserver(groundstation_loc, candidate)
        mismatches = 0
        try:
            for t in range(len(duty_cycle_over_time)):
                correct_position = duty_cycle_over_time[t]
                obs_time = observation_time + correct_position[0]
                if not observer.above_horizon(obs_time):
                    raise WrongSatellite()
                altitude, azimuth, distance = observer.altAzDist_at(obs_time)
                #antenna.set_elevation(altitude)
                #antenna.set_azimuth(azimuth)
                correct_antenna.set_duty_cycle(int(correct_position[1]), int(correct_position[2]))
                correct_azimuth, correct_elevation = correct_antenna.get_angles()

                #(az_duty, el_duty) = antenna.get_duty_cycles()
                previous_elevation, previous_azimuth, _ = observer.altAzDist_at(obs_time - 1)
                current_azimuth_tolerance = azimuth_tolerance(azimuth, previous_azimuth)
                current_elevation_tolerance = elevation_tolerance(altitude, previous_elevation)
                if abs(azimuth - correct_azimuth) > current_azimuth_tolerance:
                    # make sure that if we get a mismatch, then both measurements are not near 0/360 degrees
                    if azimuth > current_azimuth_tolerance and azimuth < 360 - current_azimuth_tolerance:
                        mismatches += 1
                        if mismatches > MISMATCHES_ALLOWED:
                            raise WrongSatellite()
                        continue
                    if correct_azimuth > current_azimuth_tolerance and correct_azimuth < 360 - current_azimuth_tolerance:
                        mismatches += 1
                        if mismatches > MISMATCHES_ALLOWED:
                            raise WrongSatellite()
                        continue
                if abs(altitude - correct_elevation) > current_elevation_tolerance:
                    mismatches += 1
                    if mismatches > MISMATCHES_ALLOWED:
                        raise WrongSatellite()
                    continue
            targets.append(candidate)
        except WrongSatellite:
            continue

    assert len(targets) == 1, "Did not find exactly 1 satellite candidate! Found: {}".format(targets)
    #now = time.time()
    #duration = now - start
    #print("took {} seconds".format(duration))
    print("\nFound {}".format(targets[0]), file=sys.stderr)
    return targets[0]

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="~~~ Hacksat medium 2 (Solver) ~~~")
    for arg in ARGS:
        parser.add_argument(*arg['args'], **arg['kwargs'])
    args = parser.parse_args()
    main(args)
