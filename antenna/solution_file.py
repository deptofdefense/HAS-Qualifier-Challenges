from typing import Tuple, List
from collections import namedtuple
from math import isnan
import sys

Observation = namedtuple("Observation", ["timestamp", "az_duty", "el_duty"])

class FormatError(RuntimeError):
    pass

class OutOfChalRange(RuntimeError):
    pass

class SolutionFile:

    def __init__(self, observations: List[Observation]):
        self.observations = observations

    @classmethod
    def from_file(cls, filename) -> 'SolutionFile':
        observations = []
        with open(filename) as f:
            line = f.readline()
            while line:
                terms = line.split(',')
                if len(terms) != 3:
                    raise FormatError("error reading observation format")
                timestamp = int(terms[0])
                az_duty = int(terms[1])
                el_duty = int(terms[2])
                obs = Observation(timestamp=timestamp, az_duty=az_duty, el_duty=el_duty)
                observations.append(obs)

                line = f.readline()
        return SolutionFile(observations)

    @classmethod
    def from_stdin(cls) -> 'SolutionFile':
        observations = []
        line = sys.stdin.readline()
        while len(line) and line != "\n":
            terms = line.split(',')
            if len(terms) != 3:
                raise FormatError("error reading observation format")
            timestamp = float(terms[0])
            az_duty = int(terms[1])
            el_duty = int(terms[2])
            if el_duty < 2457 or el_duty > 7372 or az_duty < 2457 or az_duty > 7372:
                raise OutOfChalRange("Incorrect. Duty cycle values must be between 2457 and 7372.")
            if isnan(timestamp) or timestamp > 2000000000 or timestamp < 1000000000:
                raise OutOfChalRange("Incorrect. Timestamp out of range %s" % str(terms[0]))
            obs = Observation(timestamp=timestamp, az_duty=az_duty, el_duty=el_duty)
            observations.append(obs)
            line = sys.stdin.readline()
        return SolutionFile(observations)

    def to_file(self, filename: str):
        with open(filename, 'w') as f:
            for obs in self.observations:
                f.write("{}, {}, {}\n".format(obs.timestamp, obs.az_duty, obs.el_duty))
            f.write('\n')

    def to_stdout(self):
        for obs in self.observations:
            sys.stdout.write("{}, {}, {}\n".format(obs.timestamp, obs.az_duty, obs.el_duty))
        sys.stdout.write('\n')
