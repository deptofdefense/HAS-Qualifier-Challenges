import os,sys
import subprocess
import select
from timeout import timeout, TimeoutError
import math
timeout_time = int(os.getenv("TIMEOUT", 600))

@timeout(timeout_time)
def main():
    p = subprocess.Popen([ "octave" , "-q", "challenge.m" ], stdout=subprocess.PIPE,  stdin=subprocess.PIPE)
    
    read_line = ""
    while True:
        rlist, wlist, _ = select.select([p.stdout, sys.stdin], [], [])
        if p.stdout in rlist:
            line = p.stdout.readline()
            sys.stdout.write(line.decode('utf-8'))
            sys.stdout.flush()
            if b"Error" in line:
                break
        if sys.stdin in rlist:
            line = sys.stdin.readline()
            if len(line) == 0:
                break
            try:
                floats = list(map(float, line.split(",")))
                if len(floats) != 4:
                    raise ValueError("Non-real Float")
                for f in floats:
                    if math.isnan(f) or math.isinf(f):
                        raise ValueError("Non-real Float")
                p.stdin.write(b"%1.8f %1.8f %1.8f %1.8f\n" % tuple(floats))
                p.stdin.flush()
            except ValueError:
                import traceback
                traceback.print_exc()
                sys.stdout.write("Bad floats, send %f,%f,%f,%f\n")
                sys.stdout.flush()
    p.kill()

if __name__ == "__main__":
    try:
        main()
    except TimeoutError:
        print("Timeout Goodbye")
