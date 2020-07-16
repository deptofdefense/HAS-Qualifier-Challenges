import os, random, struct, re, sys, shutil
from  hashlib import sha256
def makeList(path):
    options = []
    files = os.listdir(path)
    for imageFileName in filter(lambda x : "capture" in x, files):
        m = re.match(r"^capture(\d+)_(\d+)", imageFileName)
        if m.group is None:
            continue
        cseed = m.group(1)
        sseed = m.group(2)
        receiptFileName = "receipt" + cseed + "_" + sseed + ".txt"
        hashName = hash(imageFileName) + ".jpg"
        if receiptFileName in files:
            options.append((
                path + "/" + imageFileName, 
                path + "/" + receiptFileName, 
                hashName))

    options.sort(key=lambda x : x[0])
    return options

def genSet(path, seed, count=3):
    random.seed(int(seed))
    seeds = []
    files = makeList(path)
    res = []
    while len(res) < count:
        ii = random.randint(0,len(files)-1)
        m = re.match(r".*capture(\d+)_(\d+)", files[ii][0])
        cseed = m.group(1)
        if (cseed) in seeds:
            continue
        seeds.append(cseed)
        res.append( files.pop( ii ) )
    return res
    
def hash(data, salt=0):
    h = sha256()
    h.update(struct.pack("<I", salt))
    h.update(data.encode('utf-8'))
    return h.digest().hex()[:32]

if __name__ == "__main__":
    seed = int(os.getenv("SEED", "0"))
    count = int(os.getenv("COUNT", 3))
    files = makeList(sys.argv[1])
    for a,b,c in files:
        shutil.copy(a, sys.argv[2] + "/" + c)

