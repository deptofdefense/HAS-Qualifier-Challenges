import numpy as np
from pyquaternion import Quaternion as quat
import os,sys,re
import subprocess
from pwnlib import *
from pwnlib.tubes.remote import remote

def step(line, t):
    floats = list(map(  float, 
                    re.findall(b"[-+]?\d*\.\d+e[+-]\d+|[-+?]?\d*\.\d+|[-+]\d+", line)
                    ))
    if len(floats) < 4:
        print(line)
        return ""
    q_att = quat(*floats[:4])
    
    a  = min(np.pi,1.0*np.pi/180 * t )
    qr = quat(0, 0, -a, 0)
    q  = quat.exp(qr/2) * q_att
    #q  = q_att
    return ",".join(map(str, list(q))).encode('utf-8')

if __name__ == "__main__":
    t  = 0
    Ts = 0.05

    context.log_level = 'DEBUG'

    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31355))
    ticket = os.getenv("TICKET", "")

    targ = remote(Host, Port)

    if len(ticket):
        print(targ.recvline().strip())
        targ.send(ticket + "\n")
        print("Sent " + ticket)

    for i in range(0,20*120):
        line = targ.recvline().strip()
        if b"Error" in line:
            print(line)
            break
        flag = re.match(b"(flag{.*?})", line, re.IGNORECASE)
        if i % 50 == 0: 
            print(line)
        if flag is not None:
            print(flag.groups(1)[0])
            break
        out  = step(line, t)
        if len(out) > 0:
            sys.stdout.flush()
            targ.send(out + b"\n")
        sys.stdout.flush()
    
        t += Ts
    print("Done")
    targ.close()

