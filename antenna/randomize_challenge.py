import csv
import datetime
import random
import sys
from typing import List

from attr import dataclass
from skyfield.api import load, Topos, EarthSatellite, utc

@dataclass
class Groundstation(object):
    latitude: float
    longitude: float

@dataclass
class RandomChallenge(object):
    """
    A challenge has 3 components to randomize:
    - Which satellite you are tracking
    - Coordinates of the ground station tracking it
    - Timestamp of the beginning of the interval contestants have to track it
    ----------------------------------------------------------------------------------------
    Ground station coordinates and timestamp are constrained in that the satellite must be
    visible, i.e. above the horizon for the entire duration of the observation period. Depending
    on methods available in the skyfield API, it might be easier to generate one or the other first.
    """
    satellite: EarthSatellite
    groundstation_location: Groundstation
    observation_time: float
    observation_length: int


class RandomChallengeFactory(object):
    ONE_WEEK_TIME = datetime.timedelta(days=7)
    CHALLENGE_INTERVAL = datetime.timedelta(minutes=12)
    TWO_HOUR_ORBIT_RADIANS_PER_MIN = 0.05235987755983

    def __init__(
            self,
            tle_filepath: str,
            groundstations_filepath: str
    ):
        self.tle_filepath = tle_filepath
        self.groundstations_filepath = groundstations_filepath

    def create_random_challenge(self, seed) -> RandomChallenge:
        # create rng with the given seed
        random.seed(seed)

        # load LEO satellites
        satellites = load.tle_file(self.tle_filepath)
        leo_satellites = [sat for sat in satellites if sat.model.no_kozai >= self.TWO_HOUR_ORBIT_RADIANS_PER_MIN]

        # choose a time
        ts = load.timescale(builtin=True)

        time_mid = leo_satellites[0].epoch.astimezone(utc)
        time_min = time_mid - self.ONE_WEEK_TIME
        time_max = time_mid + self.ONE_WEEK_TIME

        time_range_s = (time_max - time_min).total_seconds()
        challenge_time_offset = datetime.timedelta(seconds=time_range_s * random.random())
        challenge_t_start = time_min + challenge_time_offset
        challenge_t_end = challenge_t_start + self.CHALLENGE_INTERVAL

        challenge_t_utc = (datetime.datetime.utcfromtimestamp(challenge_t_start.timestamp()),
                           datetime.datetime.utcfromtimestamp(challenge_t_end.timestamp()))

        challenge_t_ts = (
            ts.utc(challenge_t_utc[0].year,
                challenge_t_utc[0].month,
                challenge_t_utc[0].day,
                challenge_t_utc[0].hour,
                challenge_t_utc[0].minute,
                challenge_t_utc[0].second + challenge_t_utc[0].microsecond / 1000000.0
            ),
            ts.utc(challenge_t_utc[1].year,
               challenge_t_utc[1].month,
               challenge_t_utc[1].day,
               challenge_t_utc[1].hour,
               challenge_t_utc[1].minute,
               challenge_t_utc[1].second + challenge_t_utc[0].microsecond / 1000000.0
            )
        )

        # retry up to 10 times (very unlikely)
        for i in range(10):
            # choose a groundstation
            groundstations = self.load_groundstations(self.groundstations_filepath)
            challenge_groundstation: Groundstation = random.choice(groundstations)
            loc = Topos(challenge_groundstation.latitude, challenge_groundstation.longitude)

            # find visible satellites
            candidate_satellites = []
            for sat in leo_satellites:
                _d = sat - loc
                alt_at_t_start, _, distance_at_t_start = _d.at(challenge_t_ts[0]).altaz()
                alt_at_t_end, _, distance_at_t_end = _d.at(challenge_t_ts[1]).altaz()
                if alt_at_t_start.degrees > 0 and alt_at_t_end.degrees > 0:
                    candidate_satellites.append(sat)

            if len(candidate_satellites) == 0:
                print("Unable to find valid sats for this groundstation and this time! "
                      "Retrying...", file=sys.stderr)
                # otherwise, try again with next groundstation (in random sequence)
                # but this is not a problem in this version
                continue

            # choose random satellite from candidates
            challenge_satellite = random.choice(candidate_satellites)

            start = challenge_t_utc[0].replace(tzinfo=datetime.timezone.utc)
            end = challenge_t_utc[1].replace(tzinfo=datetime.timezone.utc)
            seconds = int(end.timestamp() - start.timestamp())
            print("{} from {}, {} at {}".format(challenge_satellite.name, challenge_groundstation.latitude, challenge_groundstation.longitude,  start), file=sys.stderr)
            return RandomChallenge(challenge_satellite, challenge_groundstation, start.timestamp(), seconds)

        raise RuntimeError()

    def load_groundstations(self, path) -> List[Groundstation]:
        groundstations = []
        with open(path, 'r') as f_in:
            reader = csv.reader(f_in)

            for row in reader:
                groundstations.append(
                    Groundstation(
                        float(row[1]),
                        float(row[2])
                    )
                )

        return groundstations


if __name__ == "__main__":
    TLE_FILEPATH = '/root/repos/ctf/hacksat/easy1/active.txt'
    GROUNDSTATIONS_FILEPATH = '/root/repos/ctf/hacksat/data/worldcities_agg.csv'

    rcf = RandomChallengeFactory(
        TLE_FILEPATH,
        GROUNDSTATIONS_FILEPATH
    )

    for i in range(10):
        rand_challenge = rcf.create_random_challenge(i)
        print(rand_challenge)

