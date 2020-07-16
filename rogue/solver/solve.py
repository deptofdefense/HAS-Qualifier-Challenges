import os,sys
import socket
import re
import subprocess
import numpy as np
from skyfield.api import load,Topos

speed_of_light_km_ns = 0.000299792
au_to_km = 149598000
geo_orbit_km = 42164 
sealevel_km  = 6371
minDist = 5
maxDist = 20


def get_cart_xyz(lat, lon, alt = sealevel_km):
    lat,lon = list(map(np.deg2rad, [lat,lon]))
    return np.array([ alt * np.cos(lat) * np.cos(lon),
                      alt * np.cos(lat) * np.sin(lon),
                      alt * np.sin(lat) ])

def get_lat_lon(V):
    R = np.linalg.norm(V)
    lat = np.arcsin(V[2]/R)
    lon = np.arctan2(V[1], V[0])
    return np.rad2deg(lat),np.rad2deg(lon)

def haversine_np(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance between two points
    on the earth (specified in decimal degrees)
    Reference:
        https://stackoverflow.com/a/29546836/7657658
    
    https://gist.github.com/mazzma12/6dbcc71ab3b579c08d66a968ff509901
    """
    lon1, lat1, lon2, lat2 = map(np.radians, [lon1, lat1, lon2, lat2])

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = np.sin(
        dlat / 2.0)**2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon / 2.0)**2

    c = 2 * np.arcsin(np.sqrt(a))
    km = 6371 * c
    return km

def F(Vi, Vj):
    return  (Vi[0]**2 - Vj[0]**2) + (Vi[1]**2 - Vj[1]**2) + (Vi[2]**2 - Vj[2]**2)

def findD(startD, endD, stepD, Vg, Vs, Rg, Rs):
    d = startD
    bestDiff = 10000000000
    bestD = d
    while d < endD:
        rows = int( (len(Rs) + 1) * len(Rs) / 2)
        A = np.zeros((rows, 3))
        C = np.zeros(rows)

        kk = 0
        for ii in range(0,len(Rs)-1):
            A[kk,:] = [ 2*(Vs[ii][0] - Vg[0]), 
                        2*(Vs[ii][1] - Vg[1]), 
                        2*(Vs[ii][2] - Vg[2]) ]
            C[kk] = F(Vs[ii],Vg) - ( (d+Rs[ii])**2 - (d+Rg)**2)
            kk += 1
        
            for jj in range(ii+1,len(Rs)):
                A[kk,:] = [ 2*(Vs[ii][0] - Vs[jj][0]), 
                            2*(Vs[ii][1] - Vs[jj][1]), 
                            2*(Vs[ii][2] - Vs[jj][2]) ]
                C[kk] = F(Vs[ii],Vs[jj]) - ( (d+Rs[ii])**2 - (d+Rs[jj])**2)
                kk += 1

        guess = np.linalg.pinv(A) @ C.T
        diff = np.abs(np.linalg.norm(guess) - np.linalg.norm(Vg))
        if diff < bestDiff:
            bestGuess = guess
            bestDiff  = diff
            bestD     = d
        d += stepD
    return bestGuess,bestD

def solve_wav(basedir, name, minT, maxT):
    cmd = [ 
        "/solver/rx_wav",
        str(minT),
        str(maxT),
        basedir + os.sep + "ref.wav",
        name ] 
    p = subprocess.Popen(cmd, shell=False, 
        stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)

    pout,_ = p.communicate()
    print(int(pout))
    sys.stdout.flush()
    return int(pout)


if __name__ == "__main__":

    basedir = os.getenv("DIR", "")
    numSats = int(os.getenv("NUM_SATS", 8))
    Ts = []
    for ii in range(0,numSats):
        minT = int(( (geo_orbit_km - sealevel_km)  * 0.98) / speed_of_light_km_ns )
        maxT = int(( (geo_orbit_km - sealevel_km) * 1.06) / speed_of_light_km_ns )
        Ts.append(solve_wav(basedir, basedir + os.sep + "sat_{}.wav".format(ii+1), minT, maxT))

    #with open(basedir + os.sep + "info.txt", "r") as f:
    #    lines = f.readlines()
    for _ in range(0,1):
        Host = os.getenv("HOST", "localhost")
        Port = int(os.getenv("PORT", 31337))

        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((Host, Port))
        fsock = sock.makefile('rw')

        ticket = os.getenv("TICKET", "")
        if len(ticket):
            fsock.readline()
            fsock.write("{}\n".format(ticket))
            fsock.flush()
        
        print(fsock.readline().strip()) # Ignore the prompt
        line = fsock.readline().strip()
        print(line)
        Gll = list(map(float, line.split(",")))

        print(fsock.readline().strip()) # Ignore the prompt
        angles = []
        for ii in range(0,numSats):
            line = fsock.readline().strip()
            print(line)
            angles.append( list(map( float, line.split(",") )) ) 
        print(fsock.readline().strip()) # Ignore the prompt
        
        print("Looking for Coords...")
        sys.stdout.flush()
        Vg = get_cart_xyz(Gll[0], Gll[1], alt=sealevel_km)
        Vs = list(map(lambda a:  get_cart_xyz(a[1], a[2], alt=geo_orbit_km), angles))


        Rg = 0
        Rs = list(map(lambda T: T * speed_of_light_km_ns, Ts))
        guess,nextD = findD(-5000, 5000, 1, Vg,Vs, Rg,Rs)
        print(nextD / speed_of_light_km_ns, np.linalg.norm(guess))
        guess,nextD = findD(nextD - 5, nextD + 5, 0.01, Vg,Vs, Rg,Rs)
        print(nextD / speed_of_light_km_ns, np.linalg.norm(guess))
        guess,nextD = findD(nextD - 0.1, nextD + 0.1, 0.0001, Vg,Vs, Rg,Rs)
        print(nextD / speed_of_light_km_ns, np.linalg.norm(guess))
        guess,nextD = findD(nextD - 0.0001, nextD + 0.0001, 0.000001, Vg,Vs, Rg,Rs)
        print(nextD / speed_of_light_km_ns, np.linalg.norm(guess))
        guess,nextD = findD(nextD - 0.000001, nextD + 0.000001, 0.000000001, Vg,Vs, Rg,Rs)
        print(nextD / speed_of_light_km_ns, np.linalg.norm(guess))
        guess,nextD = findD(nextD - 0.000000001, nextD + 0.000000001, 0.000000000001, Vg,Vs, Rg,Rs)
        print(nextD / speed_of_light_km_ns, np.linalg.norm(guess))

        lat,lon = get_lat_lon(guess)
        print(lat,lon)
        
        
        #print(fsock.readline().strip())
        fsock.write("{},{}\n".format(lat,lon))
        fsock.flush()
        print(fsock.readline().strip())
        sys.stdout.flush()
        print(fsock.readline().strip())
        sys.stdout.flush()
        print(fsock.readline().strip())
        sys.stdout.flush()
