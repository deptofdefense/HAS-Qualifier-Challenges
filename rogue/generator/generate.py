import os, sys
import numpy as np
import subprocess
from skyfield.api import load,Topos


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

    a = np.sin(
        dlat / 2.0)**2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon / 2.0)**2

    c = 2 * np.arcsin(np.sqrt(a))
    km = 6371 * c
    return km

def F(Vi, Vj):
    return  (Vi[0]**2 - Vj[0]**2) + (Vi[1]**2 - Vj[1]**2) + (Vi[2]**2 - Vj[2]**2)


def GroundStation():
    Gll = [
            50 * np.random.rand() - 25.,  
            300 * np.random.rand() - 150 
        ]
    Vg  = get_cart_xyz(Gll[0], Gll[1]) 
    return Gll, Vg

def Transmitter(Gll, Vg):
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

def make_wave(name, seed, time=0, packet_spacing=0, num_packets=1, s_power=4000, n_power=400):
    p = subprocess.Popen([
        "/generator/create_wav",  
        name,                   # Output File
        "SPACE FORCE!",         # String to Send
        str(time),              # Packet Start offset
        str(packet_spacing),    # Delay Between Packets
        str(num_packets),       # Num Packets
        str(s_power),           # Signal Power
        str(n_power),           # Noise Power
        seed
        ], shell=False, stdout=subprocess.PIPE, stdin=subprocess.PIPE)

    p.wait()

def make_rs(Vg, Vs, Vt):
    Rg = np.linalg.norm(Vg-Vt)
    Rs = list(map(lambda V : np.linalg.norm(V-Vt), Vs))
    return Rg, Rs

def make_ts(Rg, Rs):    
    Tg = int(np.floor(Rg/speed_of_light_km_ns))
    Ts = list(map( lambda R: int(np.ceil(R/speed_of_light_km_ns)), Rs ))
    return Tg, Ts

if __name__ == "__main__":
    
    seed = os.getenv("SEED", "0")
    np.random.seed(int(seed) & 0xFFFFFFFF)

    Gll, Vg = GroundStation()
    _, Vt = Transmitter(Gll, Vg)
    _, Vs = Satellites(Gll, Vt)

    Rg, Rs = make_rs(Vg, Vs, Vt)
    Tg, Ts = make_ts(Rg, Rs)
    
    '''

    with open("/tmp/info.txt", 'w') as f:
        f.write("Ground Antenna (lat,lon):\n")
        f.write("\t{}, {}\n".format(Gll[0], Gll[1]))
        f.write("Satellites (#,lat,lon):\n")
        ii = 1
        for (lat,lon) in Slls:
            f.write("{},\t{},\t{}\n".format(ii,lat,lon))
            ii += 1
    print("/tmp/info.txt")
    '''
    sys.stderr.write("Generated With Seed: %s\n" % seed)
    sys.stderr.write("Tg: {}\n".format(Tg))
    for i,T in enumerate(Ts):
        sys.stderr.write("T{}: {}\n".format(i,T))
    #sys.stderr.write("Rogue GPS: {} {}\n".format(Tll[0], Tll[1]))

    make_wave("/tmp/ref.wav", "{}_{}".format(seed, 99), s_power=20000)
    print("/tmp/ref.wav")
    for ii in range(len(Ts)):
        name = "/tmp/sat_{}.wav".format(ii+1)
        make_wave(name, "{}_{}".format(seed, ii), time=Ts[ii]-Tg, s_power=400)
        print(name)
   
    print("/generator/info.txt")

