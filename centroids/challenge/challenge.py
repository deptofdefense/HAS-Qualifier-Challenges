from ImageGen import *
import numpy as np
import sys, os, traceback
from timeout import timeout, TimeoutError
import math
from scipy.optimize import linear_sum_assignment

time = int(os.getenv("TIMEOUT",10))

def write(s):
    sys.stdout.write(s)
    sys.stdout.flush()

@timeout(time)
def makeTest():
    # Make Image
    coords = genStarCoords()
    image = genImage(coords)
    
    for row in image:
        write(",".join(map(lambda x: str(int(x)), row)))
        write("\n")
    write("\n")

    write("Enter your answers, one 'x,y' pair per line.\n")
    write("(Finish your list of answers with an empty line)\n")
    
    try:
        cents = []
        while True:
            sys.stdout.flush()

            line = sys.stdin.readline().strip()

            if len(line) == 0:
                break
            a,b = map(float, line.split(',')[:2])
            if math.isinf(a) or math.isnan(a) or math.isinf(b) or math.isnan(b):
                write("Invalid Float values, skipping...\n")
                continue
            cents.append((a,b))
        cents = np.array(cents)

        if len(cents) < Points:
            write("Short Count...\n")
            return 1000000

        if len(cents) > Points + 2:
            write("Too many Guesses\n")
            return 100000

        delts = np.zeros((Points, Points))
        for ii in range(Points):
            for jj in range(Points):
                delts[ii,jj] = np.sum(np.square(np.subtract(cents[ii,:2], coords[jj,:2])))
        rindex, cindex = linear_sum_assignment(delts)
        error = np.mean(delts[rindex,cindex])

    except TimeoutError as e:
        raise e
    except Exception:
        #traceback.print_exc()
        return 1000000
    return error 

if __name__ == "__main__":
    seed = int(os.getenv("SEED", 0))
    flag = os.getenv("FLAG", "FooBar")
    TrialCount = os.getenv("TRAILS", 5)
    error = os.getenv("ERROR", 2)
    np.random.seed(seed % 0xFFFFFFFF)
    
    for ii in range(0,TrialCount):
        try:
            err = makeTest()
        except TimeoutError:
            write("Timeout, Bye\n")
            sys.exit(1)

        if err > error:
            write("Failed...\n")
            sys.exit(2)
        write("%d Left...\n" % (TrialCount - ii -1))

    write(flag)
    write("\n")
