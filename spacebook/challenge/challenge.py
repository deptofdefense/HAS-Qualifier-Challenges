from starGen import *
import numpy as np
import sys, os, traceback
from timeout import timeout, TimeoutError

from scipy.optimize import linear_sum_assignment

time = int(os.getenv("TIMEOUT",30))
error = os.getenv("ERROR", 1)
required = int(os.getenv("REQUIRED",5))

def grade(guess, actual):
    correct = 0
    wrong   = 0
    guess = set(guess)
    for g in guess:
        if g in actual:
            correct += 1
        else :
            wrong += 1
    return (correct, wrong)

@timeout(time)
def makeTest(stars_xyzm):
    try:
        viewable, view_indices, targetV = genQuestion(stars_xyzm)
        for v in viewable:
            sys.stdout.write("%f,\t%f,\t%f,\t%f\n" % (v[0], v[1], v[2], v[3]))
        sys.stdout.write("\n")

        while True:
            sys.stdout.write("Index Guesses (Comma Delimited):\n")
            sys.stdout.flush()
            guess = sys.stdin.readline().strip()
            if len(guess) == 0: 
                continue
            guesses = guess.split(",")
            if len(guesses) < required:
                print("More stars please, try again! (%d required)" % required)
                continue 
            try:
                guess_indices = set(map(int, guesses))
            except ValueError:
                print("Non Integer Detected, try again")
                continue
            if len(guess_indices) < len(guesses):
                print("Tried to use duplicates huh....")
                continue 

            (correct, wrong) = grade(guess_indices, view_indices)
            if (wrong > error):
                print("Too many were incorrect, try again")
            elif (correct < required):
                print("Not enough were correct, try again")
            else:
                break
    except TimeoutError as e:
        raise e
    except Exception:
        #traceback.print_exc()
        return False
    return True

if __name__ == "__main__":
    seed = int(os.getenv("SEED", 0))
    flag = os.getenv("FLAG", "FooBar")
    TrialCount = os.getenv("TRAILS", 5)

    np.random.seed(seed % 0xFFFFFFFF)
    
    stars_xyzm = genStars()
    
    for ii in range(0,TrialCount):
        try:
            win = makeTest(stars_xyzm)
        except TimeoutError:
            sys.stdout.write("Timeout, Bye\n")
            sys.exit(1)

        if not win:
            sys.stdout.write("Failed...\n")
            sys.exit(2)
        sys.stdout.write("%d Left...\n" % (TrialCount - ii -1))
        sys.stdout.flush()

    sys.stdout.write(flag)
    sys.stdout.write("\n")
    sys.stdout.flush()
    sys.exit(0)
