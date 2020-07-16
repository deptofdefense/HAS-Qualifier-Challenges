import numpy as np
from scipy.spatial.transform import Rotation as R


def normalizeV(v):
    return v/np.linalg.norm(v)

def quatBetweenVecs(vec1,vec2):
    qv = np.cross(vec1, vec2)
    qw = 1 + np.dot(vec1, vec2)
    quat = np.array([qv[0], qv[1], qv[2], qw])

    return normalizeV(quat)

def rotateByQuat(quat, A):
    return R.from_quat(quat).apply(A)

def rotateByRotVec(vec, A):
    return R.from_rotvec(vec).apply(A)

def cosVecDiff(vec1, vec2):
    diff = np.dot(vec1, vec2)
    diff = np.clip(-1,1,diff)
    return np.arccos( diff )

def star_anglesToCart(star_angles):
    vecs = []
    for p, t, m in star_angles:
        xyzm_v = np.array([  np.cos(t) * np.cos(p), # x 
                             np.sin(t) * np.cos(p), # y 
                             np.sin(p),             # z 
                             m ])                   # mag

        # Normalize the cartesian part
        xyzm_v[:3] = normalizeV(xyzm_v[:3])
        
        vecs.append(xyzm_v)

    return vecs

def binarySearch(data, val):
    highIndex = len(data)-1
    lowIndex = 0
    while highIndex > lowIndex:
        index = int((highIndex + lowIndex) / 2)
        sub = data[index]
        if data[lowIndex] == val:
            return [lowIndex, lowIndex]
        elif sub == val:
            return [index, index]
        elif data[highIndex] == val:
            return [highIndex, highIndex]
        elif sub > val:
            if highIndex == index:
                return sorted([highIndex, lowIndex])
            highIndex = index
        else:
            if lowIndex == index:
                return sorted([highIndex, lowIndex])
            lowIndex = index
    return sorted([highIndex, lowIndex])

def findBest(data, val, key):
    bestIdx = 0
    best = key(val, data[0])
    for ii in range(1,len(data)):
        sub = key(val, data[ii])
        if best < sub:
            best = sub
            bestIdx = ii
    return bestIdx
