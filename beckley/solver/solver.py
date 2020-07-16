from skyfield.api import EarthSatellite, Topos, load, load_file

import os,sys,stat,time
from pwnlib.tubes.remote import remote
from pwnlib.tubes.process import process
import re

##convert from Skyfield to Decimal
def c_to_d(coordinate):
        coord_str = str(coordinate)
        coord_split = coord_str.split()
        degree_split = coord_split[0]
        degree = degree_split.split("deg",2)
        minute_split = coord_split[1]
        minute = minute_split.split("'",2)
        second_split = coord_split[2]
        second = second_split.split("\"",2)
        sign = -1 if int(degree[0]) < 0 else 1
        decimal = sign * (abs(int(degree[0])) + float(minute[0])/60 + float(second[0])/3600)
        return decimal

#Establish Connection to challenge
if __name__ == "__main__":
    Ticket = os.getenv("TICKET", "")
    Host = os.getenv("HOST","172.17.0.1")
    Port = int(os.getenv("PORT","3133"))
    sock = remote(Host, Port)

    if len(Ticket) >0:
        sock.recv(128)
        sock.send(Ticket + "\n")

    ##### Load TLE---------------------------------
    text = """
REDACT
1 13337U 98067A   20087.38052801 -.00000452  00000-0  00000+0 0  9995
2 13337  51.6460  33.2488 0005270  61.9928  83.3154 15.48919755219337
    """
    lines = text.strip().splitlines()

    satellite = EarthSatellite(lines[1], lines[2], lines[0])

    ##### Set Time to match what is given in problem----------------------------
    ts = load.timescale()

    #Wait for process to start
    time.sleep(4)

    prompt = sock.recv(2000)
    #Clear initial part of buffer
    print prompt

    #Store minutes and seconds

    #Display for verification
    timestr=re.search('at 21:(\d{2}):(\d{2})',prompt)
    mins = timestr.group(1)
    sec  = timestr.group(2)
    print "Time is 21:"+mins+":"+sec

    #Find the URL for the cgi-bin server
    ipsearch=re.search(b'http:\/\/([^\:]+):(\d+)\/.*',prompt)
    
    ipaddr=ipsearch.group(1)
    ipport=ipsearch.group(2)
    
    #Load Time here
    t = ts.utc(2020, 3, 26, 21, int(mins), int(sec))

    ##### Set point on ground------------------------------------------------
    washmon = Topos('38.8891 N', '77.0354 W')

    ##### Generate position at time 't'---------------------------------------
    geocentric = satellite.at(t)
    subpoint = geocentric.subpoint()

    ##### Define Difference-------------------------------------------------
    difference = satellite - washmon

    ##### Actually calculate azimuth----------------------------------------
    topocentric = difference.at(t)

    #Ask the topocentric position for its altitude and azimuth coordinates 

    ##### Need to subtract 180# from AZ and
    alt, az, distance = topocentric.altaz()
    alt = (90-c_to_d(alt))
    az =(c_to_d(az)+180)% 360

    #In case need to verify actual distance from Washington Monument
    #print(int(distance.km), 'km')

    looklat=38.890
    looklng=-77.03
    lookrng=430000 #not exact just needs to be larger than ~250000 meters
    lookhed=str(az)
    looktlt=str(alt)
    
    #FIX Docker HOSTS FILE FOR TESTING
    os.system('echo \'172.17.0.1    test.com\' >> /etc/hosts')
    
    #Setup Curl Request
    url = ipaddr + ":" + ipport
    cmd='curl http://'+url+'/cgi-bin/HSCKML.py?CAMERA='+str(looklng)+','+str(looklat)+','+str(lookrng)+','+str(looktlt)+','+str(lookhed)+' -H \'User-Agent: GoogleEarth/7.3.2.5815(X11;Linux (5.2.0.0);en;kml:2.2;client:Pro;type:default)\' -H \'Accept: application/vnd.google-earth.kml+xml, application/vnd.google-earth.kmz, image/*, */*\' -H \'Accept-Language: en-US, *\' -H \'Connection: keep-alive\''
    print(cmd)

    result = os.popen(cmd).readlines()

    #Grep for flag{} in Curl output
    for line in result: 
        m = re.search("flag{.*}", line)
        if m:
            print line.strip()
            print m.group(0)
    sys.stdout.flush()

