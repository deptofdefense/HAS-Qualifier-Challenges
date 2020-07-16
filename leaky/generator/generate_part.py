import os,sys,stat
import subprocess, threading
import struct 
from pprint import pprint
from hashlib import sha256
from binascii import unhexlify

def run(fileOut, seed, count):
    for ii in range(0,count):
        h = sha256()
        h.update(seed)
        h.update(struct.pack("Q", ii))
        plain = h.digest()[:16]

        cmd = [ fileOut ] 

        p = subprocess.Popen(cmd, shell=False, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        t1 = p.communicate(plain)[0].strip()
        print("%s,%d" % (plain.hex(), int(t1)))

if __name__ == "__main__":

    count = int(sys.argv[1])
    seed = sys.argv[2].encode('utf-8')

    fileOut = "/src/patched.exe"
    run(fileOut, seed, count)

