from scipy import signal
from scipy import misc
import numpy as np
from starSolve import *
import sys, os, socket

if __name__ == "__main__":
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31337))
    File = os.getenv("DIR") + os.sep + "test.txt"

    Ticket = os.getenv("TICKET", "")

    stars = []
    with open(File, 'r') as f:
        for line in f.readlines():
            line = line.strip()
            if len(line):
                stars.append(list(map(float, line.split(','))))
     
    sys.stdout.write("Making Catalog... ")
    sys.stdout.flush()
    stars = np.array(stars, dtype='float64')
    triangles, indexes = genCatalog(stars)
    sys.stdout.write("Done\n")
    sys.stdout.flush()

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    fsock = sock.makefile('rw')
    
    if len(Ticket):
        fsock.readline()
        fsock.write(Ticket + "\n")
        fsock.flush()
        print("Sent", Ticket)

    while True:
        sys.stdout.write("Doing Challenge... ")
        sys.stdout.flush()
        viewable = []
        while True:
            line = fsock.readline()
            line = line.strip()
            if len(line):
                viewable.append(list(map(float, line.split(",\t")) ))
            else:
                break
        prompt = fsock.readline()
        viewable = np.array(viewable,dtype='float64')
        guesses = makeGuess(triangles,indexes,viewable)
        print(",".join(list(map(str, guesses))))
        sys.stdout.flush()
        fsock.write(",".join(list(map(str, guesses))))
        fsock.write("\n")
        fsock.flush()
        result = fsock.readline()
        if result[:6] == "Failed":
            sys.stdout.write("Failed!\n")
            sys.stdout.flush()
            break
        else:
            sys.stdout.write("Success!\n")
            count = int(result.split(" ")[0])
            sys.stdout.write("%d Left...\n" % count)
            sys.stdout.flush()
            if count == 0:
                break
    flag = fsock.readline()
    print(flag)
