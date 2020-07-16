import argparse
import sys
from abc import abstractmethod
from typing import Tuple, List
from timeout import timeout, TimeoutError
import os

from randomize_challenge import RandomChallenge, RandomChallengeFactory


WAIT_SEC = 1.0
AZIMUTH_TOLERANCE = 1.0
ELEVATION_TOLERANCE = 1.0
NUM_CHALLENGE_SATS = 3
TIMESTEP = 1/2048000

ARGS = [
    {
        'args': ('--groundstation-file',),
        'kwargs': {
            'type': str,
            'help': "Local path to file of groundstation locations",
            'required': True
        }
    },
    {
        'args': ('--tle-file',),
        'kwargs': {
            'type': str,
            'help': "Local path to TLE file of satellite orbit parameters (e.g. http://celestrak.com/NORAD/elements/noaa.txt)",
            'required': True
        }
    },
    {
        'args': ('--seed',),
        'kwargs': {
            'type': int,
            'help': "Participant's unique seed for this challenge",\
        }
    }
]


class ChallengeSolution(object):
    @abstractmethod
    def get_solution_satellites(self):
        # type: () -> List[str, str, str]
        raise NotImplementedError


timeout_time = int(os.getenv("TIMEOUT", 300))
@timeout(timeout_time)
class StdinChallengeSolution(ChallengeSolution):
    def __init__(self):
        self.satellites = None
        submitted_sats: List[str] = []
        print("Please submit {} satellite names as listed in active.txt (one per line, followed by a blank line)".format(NUM_CHALLENGE_SATS), file=sys.stdout, flush=True)

        line = sys.stdin.readline()
        while len(line) and line != "\n" and len(submitted_sats) < 3:
            submitted_sats.append(line.strip())
            line = sys.stdin.readline()
        try:
            if len(submitted_sats) < NUM_CHALLENGE_SATS:
                raise ValueError("Too few satellites submitted! Please submit exactly {}".format(NUM_CHALLENGE_SATS))
            elif len(submitted_sats) > NUM_CHALLENGE_SATS:
                raise ValueError("Too many satellites submitted! Please submit exactly {}".format(NUM_CHALLENGE_SATS))
            else:
                self.satellites = submitted_sats
        except ValueError as e:
            print(e, file=sys.stderr)
            exit(1)

        #print("Thank you. System processing...", file=sys.stdout, flush=True)

    def get_solution_satellites(self):
        # type: () -> List[str, str, str]
        return self.satellites


def print_challenges_to_stdout(challenge: RandomChallenge):
    print("Track-a-sat RF side channel detector", file=sys.stdout, flush=True)
    print("Groundstation location: latitude {}, longitude {}".format(
        challenge.groundstation_location.latitude, challenge.groundstation_location.longitude),
        file=sys.stdout, flush=True)
    print("Observation start time GMT: {}".format(challenge.observation_time), file=sys.stdout, flush=True)
    print("Observation length (seconds): {}".format(challenge.observation_length), file=sys.stdout,
          flush=True)

    for i in range(len(challenge.satellites)):
        print("Challenge file {}: signal_{}.bin".format(i+1, i))


def main(args):
    """
    User is provided with the challenge CSV file separately. All we have to do is ask the user
    for the satellites
    :return:
    """
    flag = os.getenv("FLAG")
    seed = int(os.getenv("SEED", args.seed))
    azimuth_tolerance = float(os.getenv("AZIMUTH_TOLERANCE", AZIMUTH_TOLERANCE))
    elevation_tolerance = float(os.getenv("ELEVATION_TOLERANCE", ELEVATION_TOLERANCE))
    time_interval = float(os.getenv("WAIT_SEC", WAIT_SEC))
    if flag is None:
        print("Error: no FLAG environment variable provided", file=sys.stderr)
        exit(1)
    if seed is None:
        print("Error: no SEED environment variable provided", file=sys.stderr)
        exit(1)
    seed = seed >> 2

    random_challenge_factory = RandomChallengeFactory(args.tle_file, args.groundstation_file)

    challenge = random_challenge_factory.create_random_challenge(seed, num_sats=NUM_CHALLENGE_SATS)

    print_challenges_to_stdout(challenge)

    submitted_solution = StdinChallengeSolution()

    check_solution(submitted_solution, challenge)

    print_flag(flag)


def check_solution(solution: ChallengeSolution, challenge: RandomChallenge):
    correct_satellites = [sat.name for sat in challenge.satellites]
    submitted_satellites = solution.get_solution_satellites()
    if correct_satellites != submitted_satellites:
        print("Correct sats: {}".format(correct_satellites), file=sys.stderr)
        print("Submitted sats: {}".format(submitted_satellites), file=sys.stderr)
        print("Incorrect.", file=sys.stdout)
        exit(1)


def print_flag(flag: str):
    # We may or may not use the challenge to generate the flag
    print("Success! Flag: {}".format(flag))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="~~~ Hacksat medium 2 ~~~")
    for arg in ARGS:
        parser.add_argument(*arg['args'], **arg['kwargs'])
    args = parser.parse_args()
    try:
        main(args)
    except TimeoutError:
        print("Timeout, Whoops...")
    sys.stdout.flush()
