import os, sys
import subprocess
import random, datetime
import math
from timeout import timeout, TimeoutError

time = int(os.getenv("TIMEOUT",300))
@timeout(time)
def doChallenge():
    line = sys.stdin.readline()
    if len(line) == 0:
        return 

    try: 
        guess = float(line)
    except ValueError: 
        print("Enter answer as float!")
        sys.stdout.flush()
        return

    if math.isclose(guess, badPi, rel_tol=0.000001):
        print("You Got it!")
        print(flag)
    else:
        print("Wrong!")
        print("Goodbye!")



if __name__ == "__main__":
    flag = os.getenv("FLAG", "FLAG{Placeholder}")
    seed = int(os.getenv("SEED", 1))
    service_host = os.getenv("SERVICE_HOST", "172.17.0.1")
    service_port = os.getenv("SERVICE_PORT", "19697")
    filename = "./Resources/source/Comanche055/TIME_OF_FREE_FALL.agc"
    
    # The float changes randomly, the steps stay the same every time
    random.seed(datetime.datetime.now())
    badPi = random.random() + 3
    random.seed(seed)
    padSteps = 1 + random.randint(0,10)
    goal = "{:1.09f}".format(badPi)

    #print("Pad Steps {}".format(padSteps))
    #print("Goal: " + goal)

    with open(filename, "r") as f:
        lines = f.readlines()

    index = next(i for i,v in enumerate(lines) if "RTMUM" in v)
    
    
    with open(filename, "w") as f:
        for ii in range(0, index+1):
            f.write(lines[ii])
    
        #for ii in range(0,padSteps, 2):
        #    f.write("RTMUM{}\t2DEC\t{:1.09f} B-4\n".format(ii, 
        #                    random.random() + random.randint(0,2)))
        
        for ii in range(0,padSteps, 1):
            f.write("RTMUM/{}\tDEC\t{:1.05f} B-4\n".format(ii, random.random()))

        f.write("PI/16\t2DEC\t{} B-4\n".format(goal))

        for ii in range(index+2,len(lines)):
            f.write(lines[ii])
        
    subprocess.call("/challenge/patch.sh")

    FNULL = open(os.devnull, 'w')
    p = subprocess.Popen(["./bin/yaAGC", 
        "--core=Resources/source/Comanche055/Comanche055.bin", 
        "--cfg=Resources/LM.ini",
        "--cfg=Resources/CM.ini",
        "--port=19697"], stdout=FNULL, stderr=FNULL)

    print("""
    The rope memory in the Apollo Guidance Computer experienced an unintended 'tangle' just 
prior to launch. While Buzz Aldrin was messing around with the docking radar and making Neil
nervous; he noticed the value of PI was slightly off but wasn’t exactly sure by how much. It
seems that it was changed to something slightly off 3.14 although still 3 point something. 
The Commanche055 software on the AGC stored the value of PI under the name "PI/16", and 
although it has always been stored in a list of constants, the exact number of constants in 
that memory region has changed with time.

    Help Buzz tell ground control the floating point value PI by connecting your DSKY to the
AGC Commanche055 instance that is listening at {}:{}

What is the floating point value of PI?:
""".format(service_host, service_port))
    sys.stdout.flush()

    try:
        doChallenge()
    except TimeoutError as e:
        print("Timeout, goodbye!")
    
    try:
        p.kill()
        p.wait()
    except:
        pass

    sys.stdout.flush()
