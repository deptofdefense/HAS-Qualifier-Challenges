import os,stat,sys
import subprocess
import struct 
import tarfile
from pprint import pprint
from hashlib import sha256
from binascii import unhexlify
from pool import ThreadPool
from Crypto.Cipher import AES

def run(count, seed):
    cmd = [ "python", "generate_part.py", "%d" % count, "%d" % seed ]
    p = subprocess.Popen(cmd, shell=False, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    p.wait()
    return b"".join(p.stdout.readlines())


if __name__ == "__main__":
    seed  = os.getenv("SEED", "0")
    salt  = os.getenv("SALT", "Salting isn't really needed, just doing it on the off-chance seeds are leaked by accident")
    workerCount = int(os.getenv("WORKERS", "4"))
    count = int(os.getenv("COUNT", "100000"))

    h = sha256()
    h.update(salt.encode('utf-8'))
    h.update(seed.encode('utf-8'))
    key = h.digest()[:16]
    sys.stderr.write("Key Is: %s\n" %key.hex())
    sys.stderr.flush()
      
    with open("./chal.exe", "rb") as f:
        data = f.read()
    data = data.replace(b"\xde\xad\xbe\xef"*4, key)
    fileOut = "/src/patched.exe"
    with open(fileOut, "wb") as f:
        f.write(data)
    st = os.stat(fileOut)
    os.chmod(fileOut, st.st_mode | stat.S_IEXEC)

    workers = ThreadPool(workerCount)
    
    tasks = 1024
    roundingerror = count - int(count/tasks)*tasks
    workers.add_task(run, int(count/tasks) + roundingerror, 0)
    for ii in range(1,tasks):
        workers.add_task(run, int(count/tasks), ii)
   
    textName = "/tmp/test.txt"

    results = workers.get_results()
    with open(textName, "wb") as f:
        for r in results:
            f.write(r)
    
    print(textName)
    
    readmeFile = "/tmp/Readme.txt"
    flag = os.getenv("FLAG", "flag{place:holder}")
    
    length = 16 - (len(flag) % 16)
    plain = flag + chr(length)*length

    cipher = AES.new(key, AES.MODE_ECB)
    ctext = cipher.encrypt(plain)
    
    sys.stderr.write("Key is: %s\n" % key.hex())
    sys.stderr.flush()

    with open(readmeFile, "w") as f:    
        f.write("""
Hello, fellow space enthusiasts!

I have been tracking a specific satellite and managed to intercept an interesting 
piece of data. Unfortunately, the data is encrypted using an AES-128 key with ECB-Mode.

Encrypted Data: %s

Using proprietary documentation, I have learned that the process of generating the 
AES key always produces the same first 6 bytes, while the remaining bytes are random:

Key Bytes 0..5: %s

The communication protocol hashes every message into a 128bit digest, which is encrypted
with the satellite key, and sent back as an authenticated ACK. This process fortunately 
happens BEFORE the satellite attempts to decrypt and process my message, which it will
immediately drop my message as I cannot encrypt it properly without the key.

I have read about "side channel attacks" on crypto but don't really understand them, 
so I'm reaching out to you for help. I know timing data could be important so I've 
already used this vulnerability to collect a large data set of encryption times for 
various hash values. Please take a look!
\r\n""" % (ctext.hex(), key[0:6].hex()))


    print(readmeFile)
