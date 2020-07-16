import os, sys
import numpy as np
import time
import math
from scipy.spatial.transform import Rotation as R
from skyfield.api import load,Topos
from skyfield.earthlib import terra, reverse_terra

from timeout import timeout, TimeoutError

timeout_time = int(os.getenv("TIMEOUT",60))

speed_of_light_km_ns = 0.000299792
au_to_km = 149598000
geo_orbit_km = 42164 
sealevel_km  = 6371
num_sats = int(os.getenv("NUM_SATS", 8))

minA = np.deg2rad(15)
maxA = np.deg2rad(35)
minDist = 5
maxDist = 15


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

    a = np.sin(dlat / 2.0)**2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon / 2.0)**2

    c = 2 * np.arcsin(np.sqrt(a))
    km = 6371 * c
    return km

def F(Vi, Vj):
    return  (Vi[0]**2 - Vj[0]**2) + (Vi[1]**2 - Vj[1]**2) + (Vi[2]**2 - Vj[2]**2)


def GroundStation(t):
    Gll = [
            50 * np.random.rand() - 25.,  
            300 * np.random.rand() - 150 
        ]
    Vg  = get_cart_xyz(Gll[0], Gll[1]) 
    return Gll, Vg

def Transmitter(Gll, Vg, t):
    t_lat = 0
    t_lon = 0
    while True: 
        t_lat = Gll[0] + 2 * np.random.rand() - 1
        t_lon = Gll[1] + 2 * np.random.rand() - 1

        dist = haversine_np(Gll[1], Gll[0], t_lon, t_lat)
        if dist > minDist and dist < maxDist:
            break


    Vt = get_cart_xyz(t_lat, t_lon) 
    #Vt = Vt * (np.linalg.norm(Vg)/np.linalg.norm(Vt))
    #t_lat, t_lon, elevation = reverse_terra(Vt, t.gast, iterations=1000)
    #t_lat, t_lon = map(np.rad2deg, [t_lat,t_lon])
    return (t_lat, t_lon), Vt

def Satellites(Gll, Vg):
    Slls = []
    Vs = []
    Vg_norm = Vg / np.linalg.norm(Vg)
    while len(Vs) < num_sats: 
        lat = Gll[0] + 60 * np.random.rand() - 10
        lon = Gll[1] + 60 * np.random.rand() - 10
        
        V = get_cart_xyz(lat, lon, alt=geo_orbit_km)
        V_norm = V / np.linalg.norm(V)
        diff = np.arccos( V_norm.dot(Vg_norm) ) 
        if diff < minA or diff > maxA:
            continue

        # Compare sats to ensure good HDOP
        #'''
        hdopGood = True
        for Vi in Vs:
            Vi = Vi/np.linalg.norm(Vi)
            diff = np.arccos( V_norm.dot( Vi ))
            if diff < np.deg2rad(1): 
                hdopGood = False
                break
                
        if not hdopGood: 
            continue 
        #'''

        Vs.append(V)
        Slls.append((lat,lon))
    return Slls, Vs



# Only rotate around the Z axis, changes Lon only
def randomRotation():
    angle = np.random.rand() * (2 * np.pi)
    return R.from_rotvec(angle * np.array([0,0,1]))

def rotateCoords(r, V):
    V = r.apply(V)
    LL = get_lat_lon(V)
    return LL

@timeout(timeout_time)
def doChallenge(Tll):
    print("Where am I? Lat, Lon in +/-degrees)?")
    flag = os.getenv("FLAG", "FLAG{Placeholder}")
    sys.stdout.flush()
    line = sys.stdin.readline().strip()
    try: 
        lat, lon = list(map(float, line.split(",")))
    except ValueError:
        print("Format must be two floats, +/-, Lat, Lon")
        sys.stdout.flush()
        sys.exit(-1)
    if math.isnan(lat) or math.isnan(lon) or math.isinf(lat) or math.isinf(lon):
        print("Those aren't real coordinates...")
        sys.stdout.flush()
        sys.exit(0)
    diff = 1000 * haversine_np(lon, lat, Tll[1], Tll[0])
    sys.stderr.write("Guess Error: %d\n" % diff)
    if 250 > diff:
        print("You found it!")
        print(flag)
        sys.stderr.write("Awarded Flag: " + flag)
    else :
        print("Nothing here...");
        print("Try looking harder?")
    sys.stdout.flush()
    sys.stderr.flush()


if __name__ == "__main__":
    
    ts = load.timescale(builtin=True)
    t = ts.utc(0)

    SEED = int(os.getenv("SEED", 0)) & 0xFFFFFFFF
    np.random.seed(SEED)
    sys.stderr.write("SEED: {}\n".format(SEED))

    Gll, Vg = GroundStation(t)
    _, Vt = Transmitter(Gll, Vg, t)
    _, Vs = Satellites(Gll, Vt)

    # Time to randomize!!
    np.random.seed( ( SEED + int(time.time()) ) & 0xFFFFFFFF )
    r = randomRotation()
    Gll = rotateCoords(r, Vg)
    Tll = rotateCoords(r, Vt)
    Slls = map(lambda V: rotateCoords(r, V), Vs)

    sys.stderr.write("Rogue @ {}\n".format(Tll))

    # Print out the details
    sys.stdout.write("Ground Antenna (lat,lon):\n")
    sys.stdout.write("\t{}, {}\n".format(Gll[0], Gll[1]))
    sys.stdout.write("Satellites (#,lat,lon):\n")
    ii = 1
    for (lat,lon) in Slls:
        sys.stdout.write("{},\t{},\t{}\n".format(ii,lat,lon))
        ii += 1
    sys.stdout.flush()

    try:
        doChallenge(Tll)
    except TimeoutError:
        sys.stdout.write("Timeout, Bye\n")
        sys.stdout.flush()
    
      
