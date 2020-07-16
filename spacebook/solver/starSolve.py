from scipy import signal
from scipy import misc
from scipy.spatial.transform import Rotation as R
from scipy.optimize import linear_sum_assignment as munkres
from collections import defaultdict
from common import *
import numpy as np

refV = np.array([0,0,1])
minAngle = 1 * (np.pi/180.)
maxAngle = 10 * (np.pi/180.)

##
# Calculates Perimeter, Area, Inertial Moment and Ratio of longest and shortest
# Majority of these parameters are unused
def makeTriangle(a, b, c):
    a_n = np.linalg.norm(a)
    b_n = np.linalg.norm(b)
    c_n = np.linalg.norm(c)
    P = a_n + b_n + c_n
    #s = P/2
    #A = np.sqrt(s*(s-a_n)*(s-b_n)*(s-c_n))
    #I = A * (a_n**2 + b_n**2 + c_n**2)/36
    tmp = [a_n, b_n,c_n]
    tmp.sort()
    s,m,l = tmp
    R = s/l
    return [P,R]

##
#
def genCatalog(stars_xyzm):
    
    triangles,indexes = findTriangles(stars_xyzm)

    together = list(zip(triangles, indexes))
    together.sort(key=lambda x: x[0][0])
    triangles, indexes = zip(*together)
    triangles = np.array(triangles)
    indexes = list(indexes)

    return (triangles, indexes)

def findTriangles(stars_xyzm):
    stars_xyzm = np.array(stars_xyzm)
    star_count = len(stars_xyzm)
    mag_thresh = np.mean(stars_xyzm[:,3])

    triangles  = []
    indexes    = []

    for idx_ii in range(0,star_count-2):
        if stars_xyzm[idx_ii,3] < mag_thresh:
            continue 
        v_ii = stars_xyzm[idx_ii,:3]

        pairs = []
        for jj in range(idx_ii+1,star_count):
            angle = cosVecDiff(v_ii[:3], stars_xyzm[jj,:3])
            if angle < maxAngle:
                pairs.append(jj)

        numPairs = len(pairs)
        for jj in range(0,numPairs-1):
            idx_jj = pairs[jj]
            v_jj = stars_xyzm[idx_jj,:3]
            for kk in range(jj+1,numPairs):
                idx_kk = pairs[kk]
                v_kk = stars_xyzm[idx_kk,:3]
                
                # Filter Oblique Triangles
                angles = list(map(lambda x: cosVecDiff(x[0],x[1]), [(v_ii, v_jj), (v_ii,v_kk), (v_jj,v_kk)] ))
                if min(angles) < minAngle or max(angles) > maxAngle:
                    continue

                a = v_jj - v_ii
                b = v_kk - v_ii
                c = a - b
                            
                triangles.append(makeTriangle(a,b,c))
                idxs = [idx_ii, idx_jj, idx_kk]
                idxs.sort(key=lambda idx : -stars_xyzm[idx,3])
                indexes.append(idxs)

    triangles = np.array(triangles)
    return triangles, indexes

def findPotentials(triangles, indexes, vtriangles, vindexes):
    stride = 50
    matches = defaultdict(list)
    potentials = set()
    for vidx in range(len(vtriangles)):
        vt = vtriangles[vidx]
        idx = binarySearch(triangles[:,0], vt[0])[0]
        idx = idx - stride + findBest(
                    triangles[max(0,idx-stride):min(len(triangles),idx+stride)],
                    vt, lambda a,b: -np.linalg.norm(np.subtract(a,b))
            )

        for ii in range(3):
            matches[vindexes[vidx][ii]].append(indexes[idx][ii])
            potentials.add(indexes[idx][ii])
    potentials = list(potentials)
    potentials.sort()

    return potentials, matches

def hungarian(matches, potentials):
    matchLen = len(matches.keys())
    costDim = max(matchLen,len(potentials))
    costA   = np.zeros((costDim, costDim))
    
    for vidx in range(matchLen):
        for pidx in range(len(potentials)):
            count = matches[vidx].count(potentials[pidx])
            if count > 0:
                costA[vidx,pidx] = (-1.0*count)/len(matches[vidx])

    row_idx, col_idx = munkres(costA)
    pairs = list(zip(row_idx, col_idx))[:matchLen]
    return pairs, costA


def makeGuess(triangles, indexes, viewable):
    vtriangles,vindexes = findTriangles(viewable)

    potentials, matches = findPotentials(triangles, indexes, vtriangles, vindexes)
    
    pairs, costA = hungarian(matches, potentials)

    pairs.sort(key=lambda x:costA[x])
    
    return list(map(lambda x: potentials[x[1]], pairs))
    #return pairs, matches, costA
