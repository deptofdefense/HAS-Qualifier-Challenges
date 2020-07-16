from scipy import signal
from scipy import misc
from scipy import stats as st
import numpy as np

import sys, os, socket

def gkern(kernlen=21, nsig=3):
    ''' 2D Gaussian Kernel. '''
    x = np.linspace(-nsig, nsig, kernlen+1)
    kern1d = np.diff(st.norm.cdf(x))
    kern2d = np.outer(kern1d, kern1d)
    return kern2d/kern2d.sum()

def filterImage1(fIn):
    filtered = fIn
    
    gausKern = gkern(2,1)

    avgP = np.average(filtered)
    maxP = np.max(filtered)
    filtered = np.clip(filtered - avgP*2, 0, maxP)

    filtered = signal.convolve2d(filtered, gausKern, boundary='symm', mode='same') 
    
    return filtered 

def filterImage2(fIn):
    filtered = fIn
    
    gausKern = gkern(2,1)

    filtered = signal.convolve2d(filtered, gausKern, boundary='symm', mode='same') 

    avgP = np.average(filtered)
    maxP = np.max(filtered)
    filtered = np.clip(filtered - avgP*2, 0, maxP)
    
    return filtered 

def calcBlocks(F):
    W,L = F.shape
    last = []
    thresh = 10*np.mean(F)
    blocks = []
    for ii in range(0,L):
        up = False
        x_0 = 0
        curr = []
        for jj in range(0, W):
            if up and F[ii,jj] <= thresh: 
                up = False
                curr.append((x_0, jj))
            elif not up and F[ii,jj] > thresh:
                up = True
                x_0 = jj
        
        # Cases x0 -- x1 -- y0 -- y1  FAIL
        #       x0 -- y0 -- x1 -- y1  PASS 
        #       x0 -- y0 -- y1 -- x1  PASS 
        #       y0 -- x0 -- y1 -- x1  PASS
        #       y0 -- x0 -- x1 -- y1  PASS
        #       y0 -- y1 -- x0 -- x1  FAIL
        for (xa0,xa1) in curr:
            for (xb0, xb1) in last:
                if xa0 > xb1 or xa1 < xb0: # Check for non overlap 
                    continue  
                        
                found = False
                for kk in range(len(blocks)):
                    xc0,y0,xc1,y1 = blocks[kk]
                    if y1 != ii-1:
                        continue
                    if xa0 > xc1 or xa1 < xc0:
                        continue
                    x0 = xa0 if xa0 < xc0 else xc0
                    x1 = xa1 if xa1 > xc1 else xc1
                    blocks[kk] = (x0, y0, x1, ii)
                    found = True
                if not found:
                    x0 = xa0 if xa0 < xb0 else xb0
                    x1 = xa1 if xa1 > xb1 else xb1
                    blocks.append((x0, ii-1, x1, ii))
        last = curr
    return blocks

def calcCents(F, blocks):
    cents = []
    for x0, y0, x1, y1 in blocks:
        xS = 0.
        yS = 0.
        M  = 0.
        for ii in range(y0, y1+1):
            for jj in range(x0, x1+1):
                xS += ii*F[ii,jj]
                yS += jj*F[ii,jj]
                M += F[ii,jj]
        cents.append(( xS/M, yS/M, M))
    return np.array(cents)

if __name__ == "__main__":
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31337))
    Ticket = os.getenv("TICKET", "")

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    fsock = sock.makefile('rw')

    if len(Ticket):
        print(fsock.readline().strip())
        fsock.write(Ticket + "\n")
        fsock.flush()
        print("Sent", Ticket)
        sys.stdout.flush()

    while True:
        image = []
        while True:
            line = fsock.readline()
            line = line.strip()
            if len(line):
                image.append(line.split(','))
            else:
                break
        #print("Got Image")
        image = np.array(image, dtype='float64')
        print(fsock.readline().strip())
        print(fsock.readline().strip())

        F = filterImage2(image)
        blocks = calcBlocks(F)
        cents = calcCents(F, blocks)
        for cent in cents:
            fsock.write("%d, %d\n" % (round(cent[0]), round(cent[1])))
            fsock.flush()
            print("%d, %d" % (round(cent[0]), round(cent[1])))
        fsock.write("\n")
        fsock.flush()

        result = fsock.readline()
        count = int(result.split(" ")[0])
        sys.stdout.write("Count Left: %d\n" % count)
        sys.stdout.flush()
        if count == 0:
            break
    
    sys.stdout.write("Done\n")
    sys.stdout.flush()
    result = fsock.read()
    sys.stdout.write(result)
    sys.stdout.flush()
        
