import os, sys, time
import hashlib


DEBUG = True
if __name__ == "__main__":

    with open("/generator/challenge.elf", 'rb') as f:
        data = f.read()

    SEED = os.getenv("SEED", "DEADBEEF")
    m = hashlib.sha256()
    m.update(SEED.encode('utf-8'))
    d = m.digest()
    COOKIE = d[:4]
    data = data.replace(b"\xDE\xAD\xBE\xEF", COOKIE)

    fileName = "/tmp/test.elf"
    
    with open(fileName, 'wb') as f:
        f.write(data)

    print(fileName)

