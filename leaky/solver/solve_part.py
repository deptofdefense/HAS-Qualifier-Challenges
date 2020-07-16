import sys, os
import numpy as np
from binascii import unhexlify
from array import array

from pool import ThreadPool

from Crypto.Cipher import AES

import re

step = 4
mask = ~(step - 1)

found = False
def bruteForce(cipherText, key):
    global found
    if found:
        return
    maskV = np.array([mask, mask, mask, mask, mask], dtype=np.uint8)
    maskPatch = np.array([3, 3, 3, 3, 3], dtype=np.uint8)
    expand    = np.array([8, 6, 4, 2, 0], dtype=np.uint32)
    
    for s in range(0,0x400):
        patch = np.array((s >> expand) & maskPatch, dtype=np.uint8)
        key[6:11] &= maskV
        key[6:11] |= patch
        cipher = AES.new(array("B", key).tostring(), AES.MODE_ECB)
        plain = cipher.decrypt(cipherText)
        if b"flag" in plain:
            try: 
                sys.stdout.write("%s" % plain.decode('utf-8')) 
            except:
                sys.stdout.write("False Match Ignored")
            sys.stdout.flush()
            found = True
        if found:
            return
 
if __name__ == "__main__":
    keyBase = np.array(bytearray(unhexlify(sys.argv[1])))
    ctext   = unhexlify(sys.argv[2])
    workerPool = ThreadPool(4)
    for s in range(0,0x100): 
        maskPatch = np.array([3, 3, 3, 3], dtype=np.uint8)
        expand    = np.array([0, 2, 4, 6], dtype=np.uint8)
        key = np.array(keyBase, copy=True)
        key[12:] ^= (s >> expand) & maskPatch
        workerPool.add_task(bruteForce, *(ctext, key))
