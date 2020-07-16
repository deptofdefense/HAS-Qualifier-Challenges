from starGen import *
import numpy as np
import math
import sys, os, traceback
from timeout import timeout, TimeoutError
from scipy.spatial.transform import Rotation as R


from scipy.optimize import linear_sum_assignment

time = int(os.getenv("TIMEOUT",5))


@timeout(time)
def makeTest(stars_xyzm):
    try:
        viewable, view_indexes, quat = genQuestion(stars_xyzm)
        targetV = R.from_quat(quat).inv().as_quat()
        sys.stdout.write("  ID : X,\t\tY,\t\tZ\n")
        sys.stdout.write("-"*50 + "\n")
        for ii in range(len(viewable)):
            v = viewable[ii]
            sys.stdout.write("%4d : %f,\t%f,\t%f\n" % (view_indexes[ii], v[0], v[1], v[2]))
        sys.stdout.write("\n")
        sys.stdout.flush()

        line = sys.stdin.readline().strip()
        parts = list(map(float, line.split(',')))
        if len(parts) != 4:
            return -1
        guess = np.array(parts,dtype='float64')
        N = np.linalg.norm(guess)
        if not math.isclose(N, 1.0, rel_tol=0.5e-1):
            print("Invalid vector, Make sure to normalize")
            return -1
        guess = guess / np.linalg.norm(guess)
        res = np.abs(np.dot(guess, targetV))
    except TimeoutError as e:
        raise e
    except ValueError:
        print("Format error: Give your answer as '%f,%f,%f,%f") 
        return -1
    except Exception:
        #traceback.print_exc()
        print("Unexpected Error") 
        return -1
    return res

if __name__ == "__main__":
    seed = int(os.getenv("SEED", 0))
    flag = os.getenv("FLAG", "FooBar")
    TrialCount = os.getenv("TRAILS", 20)
    np.random.seed(seed % 0xFFFFFFFF)
    
    stars_xyzm = genStars()
    
    for ii in range(0,TrialCount):
        try:
            res = makeTest(stars_xyzm)
        except TimeoutError:
            sys.stdout.write("Timeout, Bye\n")
            sys.exit(1)
        if math.isnan(res) or math.isinf(res):
            sys.stdout.write("Invalid float values\n")
            sys.exit(1)
        if res < 0.95:
            sys.stdout.write("Failed...\n")
            sys.exit(2)
        sys.stdout.write("%d Left...\n" % (TrialCount - ii -1))

    sys.stdout.write(flag)
    sys.stdout.write("\n")
