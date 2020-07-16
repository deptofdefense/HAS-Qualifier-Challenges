import os, sys, stat, re 
from skyfield.api import Topos, load
from pwnlib.tubes.remote import remote
from pwnlib.tubes.process import process
from math import isclose


if __name__ == "__main__":
    #Grab data from local text file for speed and consistency
    #-------------------------------------------#
    satellites = load.tle('stations.txt')
    #-------------------------------------------#

    #Kick off and connect to challenge.py
    #-------------------------------------------#
    Ticket = os.getenv("TICKET", "")

    #Host = os.getenv("HOST","")
    #Port = int(os.getenv("PORT","0"))
    Host = os.getenv("HOST","172.17.0.1")
    Port = int(os.getenv("PORT","31338"))

    conn = remote(Host, Port)
    
    if len(Ticket) > 0:
        conn.recvline()
        conn.send(Ticket + "\n")
    #-------------------------------------------#
    
    #Grab time and coordinates to find the satellite
    #-------------------------------------------#
    #print(f"Satellite time {satellite_time}")

    satellite_time = re.search(b'.*:\((2020), (3), (18), (\d+), (\d+), (\d+\.\d*)\)', conn.recvline(timeout=20))
    year = int(satellite_time.group(1))
    month = int(satellite_time.group(2))
    day = int(satellite_time.group(3))
    hour = int(satellite_time.group(4))
    minute = int(satellite_time.group(5))
    second = float(satellite_time.group(6))
    float_regex = b'([+-]?\d+\.\d+)'
    challenge_coor =  re.search(b'.*:\[' + float_regex + b", " + float_regex + b", " + float_regex + b'\]', conn.recvline(timeout=15))
    coord_x = challenge_coor.group(1)
    coord_y = challenge_coor.group(2)
    coord_z = challenge_coor.group(3)
    #-------------------------------------------#

    #Satellite list from website has both integers and strings and we need only objects utilizing the strings
    #-------------------------------------------#
    # def isclose(a, b, rel_tol=1e-3, abs_tol=0.0):
    #     return abs(a-b) <= max(rel_tol * max(abs(a), abs(b)), abs_tol)
    ts = load.timescale()
    t = ts.utc(year, month, day, hour, minute, second)
    challenge_satellite = ''
    for satellite in satellites:
        if isinstance(satellite, str):
            satellite = satellites[satellite]
            geocentric = satellite.at(t)
            coordinates = geocentric.position.km.tolist()
            #print(coordinates)
            #print(type(coordinates))
            print(f'Coordinates: {str(coordinates)}')
            x,y,z = coordinates
            #print("%s %f %f" % (satellite, float(coordinate), float(challenge_coordinate)))
            if isclose(float(coord_x), float(x), rel_tol=1e-3) and isclose(float(coord_y), float(y), rel_tol=1e-3) and isclose(float(coord_z), float(z), rel_tol=1e-3):
                challenge_satellite = satellite
                print('Satellite: %s' % satellite)
                print('Coordinates: %s' % coordinates)
                break
                    

    #-------------------------------------------#
    
    #Solve
    #-------------------------------------------#
    while_loop_iterations = 0
    while True:
        if while_loop_iterations < 3:
            times_allowed_prompt = re.search(b'.*:(.*)', conn.recvline(timeout=15)).group(1) 
            line = conn.recvline(timeout=20)
            print(line)
            sys.stdout.flush()
            what_is_x_prompt = re.search(b'.*:\((2020), (3), (18), (\d+), (\d+), (\d+\.\d*)\)', line)
            year = int(what_is_x_prompt.group(1))
            month = int(what_is_x_prompt.group(2))
            day = int(what_is_x_prompt.group(3))
            hour = int(what_is_x_prompt.group(4))
            minute = int(what_is_x_prompt.group(5))
            second = float(what_is_x_prompt.group(6))
                                    
            ts = load.timescale()
            t = ts.utc(year, month, day, hour, minute, second)
            geocentric = challenge_satellite.at(t)
            coordinates = geocentric.position.km.tolist()
            x_coordinate = coordinates[0]
            y_coordinate = coordinates[1]
            z_coordinate = coordinates[2]
            
            print('Sending X coordinate: %s' % x_coordinate)
            conn.sendline(b"%f" % float(x_coordinate))
            correct_prompt = re.search(b'(.*)', conn.recvline(timeout=5)).group(1)
            print(correct_prompt)
            what_is_y_prompt = re.search(b'(.*)', conn.recvline(timeout=5)).group(1)
            print('Sending Y coordinate: %s' % y_coordinate) 
            conn.sendline(b"%f" % float(y_coordinate))
            correct_prompt = re.search(b'(.*)', conn.recvline(timeout=5)).group(1)
            print(correct_prompt)
            what_is_z_prompt = re.search(b'(.*)', conn.recvline(timeout=5)).group(1)
            print('Sending Z coordinate: %s' % y_coordinate)
            conn.sendline(b"%f" % float(z_coordinate))
            correct_prompt = re.search(b'(.*)', conn.recvline(timeout=5)).group(1)
            print(correct_prompt)
            while_loop_iterations = while_loop_iterations + 1
            continue
        break
    flag_prompt = re.search(b'(.*)', conn.recvline(timeout=5)).group(1)
    print('Flag is: %s' % flag_prompt)
    #-------------------------------------------#
