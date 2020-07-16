import sys,os
import hashlib

m = hashlib.sha256()

m.update(os.getenv("SEED", "0").encode('utf-8'))
with open("hash.txt", 'wb') as f:
    f.write(m.digest())

