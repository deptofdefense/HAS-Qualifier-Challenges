from starGen import *
import numpy as np
import sys, os
from hashlib import sha1
from struct import pack
import random

# def randFileName(seed=0):
#    random.seed(seed)
#    h = sha1()
#    h.update(pack("QQ", random.randint(0,2**32), 0x31337))
#    return h.digest().hex()

def dumpStars(stars_xyzm, f):
    for row in stars_xyzm:
        f.write(",\t".join(map(lambda x: str(x), row)))
        f.write("\n")
    f.write("\n")

if __name__ == "__main__":
    seed = int(os.getenv("SEED", "0"))
    TrialCount = int(os.getenv("TRIALS", "20"))

    np.random.seed(seed % 0xFFFFFFFF)
    stars_xyzm = genStars()

    filename = "/mnt/test.txt"
    with open(filename, "w+") as f:
        dumpStars(stars_xyzm, f)

    print(filename)
