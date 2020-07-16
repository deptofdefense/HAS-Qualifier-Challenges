import numpy as np
from scipy import signal
from scipy import misc
from scipy.spatial.transform import Rotation as R
from common import *


import sys, os, socket

def makeB(X,Y):
    weight = 1./len(X)
    B = (Y.T @ X ) * weight
    return B

def makeA(B):
    u,_,vh = np.linalg.svd(B)
    sign = np.linalg.det(u) * np.linalg.det(vh)
    s = np.diag([1,1,sign])

    A = (u@s) @ vh
    return A

def solve(X,Y):
    B = makeB(X,Y)
    A = makeA(B)
    guess = R.from_matrix(A).as_quat()
    return guess


if __name__ == "__main__":
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31337))
    File = os.getenv("DIR") + os.sep + "test.txt"

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    fsock = sock.makefile('rw')
    
    ticket = os.getenv("TICKET","")
    if len(ticket):
        print(fsock.readline().strip())
        fsock.write(ticket +'\n')
        fsock.flush()
        print("Sent Ticket: ", ticket)
    stars = []
    with open(File, 'r') as f:
        for line in f.readlines():
            line = line.strip()
            if len(line):
                stars.append(list(map(float, line.split(','))))

    while True:
        sys.stdout.write("Doing Challenge... ")
        sys.stdout.flush()
        viewable = []
        refstars = []
        # Read in table header
        line = fsock.readline().strip()
        line = fsock.readline().strip()

        while True:
            line = fsock.readline().strip()
            if len(line):
                parts = line.split(":")
                refstars.append(stars[int(parts[0])])
                viewable.append(list(map(float, parts[1].split(",\t") )))
            else:
                break
        X = np.array(refstars,dtype='float64')[:,:3]
        Y = np.array(viewable,dtype='float64')[:,:3]

        guess = solve(Y,X)
        fsock.write(",".join(list(map(str, guess))))
        fsock.write("\n")
        fsock.flush()
        result = fsock.readline()
        sys.stdout.flush()
        if result[:6] == "Failed":
            sys.stdout.write("Failed!\n")
            sys.stdout.flush()
        else:
            sys.stdout.write("Success!\n")
            count = int(result.split(" ")[0])
            sys.stdout.write("%d Left...\n" % count)
            sys.stdout.flush()
            if count == 0:
                break
    flag = fsock.readline()
    print(flag)
