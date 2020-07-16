import numpy as np
import sys, os, traceback
from timeout import timeout, TimeoutError
import subset
import time
import math

timeout_time = int(os.getenv("TIMEOUT",60))

@timeout(timeout_time)
def makeTest(trial):
    with open(trial[1], 'r') as f:
        lines = f.readlines()
        minutes,hour,day,month,year = map(int,lines[0].split(":")[1].split("-"))
        lat,lon = map(float, lines[1].split(":")[1].split(","))
        ca,ce = map(float, lines[2].split(":")[1].split(","))
        la,le = map(float, lines[3].split(":")[1].split(","))
        targetV = np.array([ca,ce,la,le])
    try:
        print("%s (%f,%f) %d-%d-%d" % (trial[2], lat, lon, day, month, year))
        print("(camera_az,camera_el,light_az,light_el):")
        sys.stdout.flush()
        line = sys.stdin.readline()
        parts = list(map(float, line.split(',')))
        if len(parts) != 4:
            return 100000
        for part in parts:
            if math.isnan(part) or math.isinf(part):
                return 100000
        guess = np.array(parts,dtype='float64')
        res = np.sum(np.abs(guess - targetV))
    except TimeoutError as e:
        raise e
    except ValueError: 
        print("Answers must be formatted %f,%f,%f,%f")
        sys.stdout.flush()
        return 10000
    except Exception:
        traceback.print_exc()
        return 100000
    return res

if __name__ == "__main__":
    seed = int(os.getenv("SEED", "0"))
    flag = os.getenv("FLAG", "FooBar")
    TrialCount = os.getenv("COUNT", 3)

    res = 0.0
    trials = subset.genSet("images", seed=seed, count=TrialCount)
    for ii in range(0,TrialCount):
        try:
            res += makeTest(trials[ii])
            if res > 1000:
                break
        except TimeoutError:
            sys.stdout.write("Timeout, Bye\n")
            sys.exit(1)

    if res/TrialCount > 8.0:
        sys.stdout.write("Failed...\n")
        sys.exit(2)

    sys.stdout.write("Flag: {%s}\n" % flag)
    sys.stdout.write("\n")
