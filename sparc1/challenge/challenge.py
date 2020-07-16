import os, sys, time, traceback
import select, socket
import subprocess
import hashlib

from timeout import timeout, TimeoutError

timeout_time = int(os.getenv("TIMEOUT",30))

def shutdown(proc):
    sys.stdout.write("Connection Closed\r\n")
    sys.stdout.flush()
    try:
        proc.kill()
        proc.wait()
    except:
        pass
    sys.exit(0)

def confirmHexMsg(data):
    try:
        dataBin = data.decode('hex')
    except TypeError:
        if len(data) % 2:
            sys.stdout.write("Odd Number of Hex Digits, skipping\r\n")
        else:
            sys.stdout.write("Invalid Hex Digits, skipping\r\n")
        sys.stdout.flush()
        return None
    return dataBin.encode('hex')


@timeout(timeout_time)
def run_test():
    while True:
        p = subprocess.Popen([
            "qemu-system-sparc","-no-reboot","-nographic","-M","leon3_generic","-m","64M",
            "-kernel","./challenge.elf"
            ],stdin=subprocess.PIPE, stdout=subprocess.PIPE) 
        rlist, _, _ = select.select([p.stdout], [], [], 5)
        if len(rlist) > 0:
            break
        p.kill()
        p.wait()

    sys.stdout.write(p.stdout.readline())
    sys.stdout.flush()

    rdescriptors = [sys.stdin, p.stdout]
    msg = ""
    try:
        while True:
            time.sleep(0.1)
            rlist, wlist, _ = select.select(rdescriptors, [], [], 0.1)
            if p.poll():
                # Die, proc is already dead
                shutdown(None) 

            for r in rlist:
                if r == p.stdout:
                    line = p.stdout.readline()
                    if len(line) == 0:
                        # We got EOF
                        shutdown(p)
                    sys.stdout.write(line.strip() + "\r\n")
                    sys.stdout.flush()
                    continue

                else: 
                    # We expect line buffering
                    data = sys.stdin.readline().strip()
                    msg = confirmHexMsg(data)
                    if msg is None:
                        # We can't use it, move on
                        continue

                    resp = ""
                    for b in msg:
                        breakOut = False
                        _,w,_ = select.select([],[p.stdin],[],0.1)
                        if len(w) == 0:
                            break
                        p.stdin.write(b)
                        p.stdin.flush()
                        resp = b''
                        while True:
                            r,_,_ = select.select([p.stdout],[],[],0.2)
                            if len(r) == 0:
                                break
                            r = p.stdout.read(1)
                            if r == b:
                                break
                            resp += r
                            if b"Error" in resp:
                                breakOut = True
                                break
                        sys.stdout.write(resp)
                        sys.stdout.flush()
                        
                        if breakOut:
                            break
                    #sys.stdout.write("\r\n")
                    sys.stdout.flush()


    except TimeoutError:
        sys.stdout.write("Timeout: Connection Closed\r\n")
        sys.stdout.flush()
        p.kill()
        sys.exit(1)
    except IOError:
        sys.stdout.write("Connection Closed\r\n")
        sys.stdout.flush()
        p.kill()
        sys.exit(0)

DEBUG = True
if __name__ == "__main__":

    with open("/challenge/challenge.elf", 'rb') as f:
        data = f.read()

    FLAG = os.getenv("FLAG","FLAG{PLACEHOLDER}")
    
    SEED = os.getenv("SEED", "DEADBEEF")
    m = hashlib.sha256()
    m.update(SEED.encode('utf-8'))
    d = m.digest()
    COOKIE = d[:4]
    data = data.replace(b"\xDE\xAD\xBE\xEF", COOKIE)

    flagStart = data.find("FLAG{")
    flagEnd   = flagStart + data[flagStart:].find("}")
    

    with open("/challenge/challenge.elf", 'wb') as f:
        f.write(data[:flagStart])
        f.write(FLAG)
        f.write("\x00"*(flagEnd-flagStart- len(FLAG)))
        f.write(data[flagEnd:])

    run_test()
