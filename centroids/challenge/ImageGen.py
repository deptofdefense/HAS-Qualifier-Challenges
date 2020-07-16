from scipy import signal
from scipy import misc
from scipy import stats as st
import numpy as np

W = 128
L = 128
Body_Width = 3
Border = Body_Width+1
Points = 10
Noise_Max = 10
Body_Separation = 15
Body_Scale = 30
OvScale = 3


def gkern(kernlen=21, nsig=3):
    ''' 2D Gaussian Kernel. '''
    x = np.linspace(-nsig, nsig, kernlen+1)
    kern1d = np.diff(st.norm.cdf(x))
    kern2d = np.outer(kern1d, kern1d)
    return kern2d/kern2d.sum()

def genBackground():
    return np.random.rand(W,L)*(Noise_Max)

def genStarCoords():
    while True:
        star_cords = np.random.rand(Points,3) # N x [x,y,m]
        star_cords = star_cords * np.array([[ W-2*Border , L-2*Border , Body_Scale ]]) 
        star_cords = star_cords + np.ones((Points,3)) * np.array([[ Border, Border, Body_Separation ]])
        bad = False
        for ii in range(0, Points-1):
            x0, y0, m0 = star_cords[ii,:]
            for jj in range(ii+1, Points):
                x1, y1, m1 = star_cords[jj,:]
                if np.abs(x0 - x1) < 4*Border and np.abs(y0 - y1) < 4*Border:
                    '''
                    x = np.random.random() * (W-2*Border) + Border
                    y = np.random.random() * (W-2*Border) + Border
                    star_cords[jj,0] = x
                    star_cords[jj,1] = y
                    '''
                    
                    bad = True
                    break
                    
                if np.abs(m0 - m1) < 5:
                    star_cords[jj,2] = m1 + 5
        if not bad:
            break
    return star_cords

def starGauss(OvScale):
    gausKern = gkern(Body_Width*OvScale, Body_Width/(OvScale/3))
    gausKern = gausKern * (Body_Scale/np.max(np.max(gausKern)))
    return gausKern

def genImage(star_cords):
    # Overscale it 
    spots_O = np.zeros((W*OvScale, L*OvScale))
        
    for (x,y,m) in star_cords:
        x = OvScale * (x+0.5)
        y = OvScale * (y+0.5) 
        x_0, y_0 = map(int, np.floor([x,y]))
        x_1, y_1 = map(int, np.ceil([x,y]))
        spots_O[x_0:x_1, y_0:y_1] = m

    gausKern = starGauss(OvScale)
    spots_B = signal.convolve2d(spots_O, gausKern, boundary='symm', mode='same')

    spots = np.zeros((W,L))
    for (x,y,m) in star_cords:
        x = int(x)
        y = int(y)
        x0 = max(0, x-Body_Width-1)
        x1 = min(W, x+Body_Width+1)
        y0 = max(0, y-Body_Width-1)
        y1 = min(L, y+Body_Width+1)
        for ii in range(x0,x1+1):
            for jj in range(y0, y1+1):
                spots[ii,jj] = np.mean(spots_B[ii*OvScale:(ii+1)*OvScale, jj*OvScale:(jj+1)*OvScale])
    
    final = np.trunc( np.clip(genBackground() + spots, 0, 255) )
    return final
