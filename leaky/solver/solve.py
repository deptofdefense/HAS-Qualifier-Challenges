import sys, os
import numpy as np
from binascii import unhexlify, hexlify
from array import array

from Crypto.Cipher import AES

from pool import ThreadPool
import subprocess

from collections import namedtuple
import socket
import re

Guess = namedtuple("Guess", ["i1", "i2", "relate", "cost"])

# Config for cache
step = 4
mask = ~(step - 1)
data = {}

found = False

def run(ctext, key):
    global found
    if found:
        return
    #print("Starting Search : %s" % hexlify(key))
    sys.stdout.flush()
    cmd = [ "python3", "solve_part.py", hexlify(key), hexlify(ctext)]
    p = subprocess.Popen(cmd, shell=False, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    p.wait()
    results = p.stdout.read()
    if len(results):
        match = re.match(b"flag{.+}", results)
        if match is not None:
            try: 
                print(match.group(0).decode('utf-8'))
                found = True
            except:
                print("Non UTF-8 String found...")
        else:
            try:
                print(results.decode('utf-8'))
            except:
                print("Skipping non-utf-8 string")
        sys.stdout.flush()

def makeGuesses(idx1, idx2):    
    guesses = []
    costs = {}
    plains = list(data.keys())
    for ii in range(0x00,0x100,step):
        selected   = list(filter(
                lambda x : ((x[idx1] ^ x[idx2]) & mask) == ii, plains
            ))

        ts = list(map(lambda x : data[x], selected))
        costs[ii] = np.mean(ts)
    keys = list(costs.keys())
    keys.sort(key=lambda x: costs[x], reverse=False)
    for k in keys:
        guesses.append(Guess(idx1, idx2, k, costs[k]))
    return guesses

def statisticalFilter(guesses):
    costs = list(map(lambda x : x.cost, guesses))
    c_mean = np.mean(costs)
    c_std  = np.std(costs)
    c_lower = c_mean - 3 * c_std

    related = list(filter(lambda x : x.cost < c_lower, guesses))
    return related


def solve(data, leak, ctext):
   
    guesses = []

    # Based on the access order of Pi ^ Ki pairs in the first round, see aes.c
    pairs = [   (0,4), (4,8), (8,12), (12,5),
                (5,9), (9,13), (13,1), (1,10), 
                (10,14), (14,2), (2,6), (6,15), 
                (15,3), (3,7), (7,11) ]
             
    workerPool = ThreadPool(8)
    workerPool.map(makeGuesses, pairs)
    for result in workerPool.get_results():
        guesses.extend(result)
    
    guesses = statisticalFilter(guesses)
    guesses.sort(key=lambda x : x.cost, reverse=False)

    pairs = np.zeros((16,16), dtype=np.uint8)
    for guess in guesses:
        pairs[guess.i1,guess.i2] = guess.relate
        pairs[guess.i2,guess.i1] = guess.relate

    
    # 00112233445566778899aabbccddeeff
    # 4355a46b19d348dc2f57c046f8ef63d4 (sha256sum(echo "1")[:16])
    keyBase = np.zeros((16), dtype=np.uint8)
    keyBase[0:6] = leak

    keyBase[14] = (keyBase[2]  ^ pairs[2,14]) & mask
    keyBase[10] = (keyBase[14] ^ pairs[10,14]) & mask
    #keyBase[1]  = (keyBase[10] ^ pairs[1,10]) & mask

    keyBase[7]  = (keyBase[3]  ^ pairs[3,7]) & mask
    keyBase[15] = (keyBase[3]  ^ pairs[3,15]) & mask
    keyBase[6]  = (keyBase[15] ^ pairs[6,15]) & mask

    #keyBase[0]  = (keyBase[4]  ^ pairs[4,0]) & mask
    keyBase[8]  = (keyBase[4]  ^ pairs[4,8]) & mask

    keyBase[9]  = (keyBase[5]  ^ pairs[9,5]) & mask
    keyBase[12] = (keyBase[5]  ^ pairs[5,12]) & mask
    keyBase[13] = (keyBase[9]  ^ pairs[9,13]) & mask

    print("Base Pair: %s" % "".join(list(map(lambda x : "%02x" % x, keyBase))))
    sys.stdout.flush()
    
    # 4355a46b19d348dc2f57c046f8ef63d4 (sha256sum(echo "1")[:16])
    for k11 in range(0x0,0x100):
        key = np.array(keyBase, copy=True)
        key[11] = k11
        workerPool.add_task(run, ctext, key)
        
    workerPool.get_results()

if __name__ == "__main__":
    File = os.getenv("DIR", "/mnt") + os.sep + "test.txt"
    Readme = os.getenv("DIR", "/mnt") + os.sep + "Readme.txt"
    
    print("Starting up...")
    sys.stdout.flush()

    with open(Readme, 'r') as f:
        msg = f.read()

    for line in msg.split("\n"):
        print(line.strip())
    sys.stdout.flush()
    leak  = bytearray(unhexlify( re.findall("Key Bytes 0..5:\s*([a-f0-9A-F]+)", msg)[0] ))
    ctext = unhexlify( re.findall("Encrypted Data:\s*([a-f0-9A-F]+)", msg)[0] )

    with open(File, 'r') as f:
        for line in f.readlines():
            p,t = line.strip().split(',')
            p = unhexlify(p)
            t = int(t)
            data[p] = t

    solve(data,leak,ctext)
