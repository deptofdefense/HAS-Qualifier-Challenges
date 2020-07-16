from skyfield.api import EarthSatellite, Topos, load, load_file
import os,sys,stat,time,random

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

##### Load TLE---------------------------------
tle_text = """
REDACT
1 13337U 98067A   20087.38052801 -.00000452  00000-0  00000+0 0  9995
2 13337  51.6460  33.2488 0005270  61.9928  83.3154 15.48919755219337
"""
lines = tle_text.strip().splitlines()

satellite = EarthSatellite(lines[1], lines[2], lines[0])

# The next dozen lines set random time within the window of March 26th 21:52:00 to 21:54:59
ts = load.timescale()

##### Actually put in a random time ------------------------------------

#Next line gives same challenge per team.  Comment next line to randomize each time
seeds=(os.environ.get('SEED',0x1234567812345678))
random.seed(seeds)

#Generate random time
sec=random.randint(00,59)
mins=random.randint(52,54)
t = ts.utc(2020, 3, 26, 21, mins, sec)

##### Set point on ground------------------------------------------------
washmon = Topos('38.8891 N', '77.0354 W')

##### Generate position at time 't'---------------------------------------
geocentric = satellite.at(t)
#print(geocentric.position.km)
subpoint = geocentric.subpoint()
#print('Latitude:', c_to_d(subpoint.latitude))
#print('Longitude:', c_to_d(subpoint.longitude))
#print('Elevation (m):', int(subpoint.elevation.m))

##### Define Difference?-------------------------------------------------
difference = satellite - washmon

##### Actually calculate azimuth----------------------------------------
topocentric = difference.at(t)

#Ask the topocentric position for its altitude and azimuth coordinates 

##### Need to subtract 180# from AZ and ALT from 90 to get back vector from satellite looking at WashMon
alt, az, distance = topocentric.altaz()
alt = (90-c_to_d(alt))
#Open success window by +or- 1 degree of declenation/elevation/tilt/altitude/whatever
alt1 = alt-1
alt2 = alt+1
az =(c_to_d(az)+180)% 360
#Open success window by +or- 1 degree of azimuth/heading/look-angle
az1 = az-2
az2 = az+2

#print(int(distance.km), 'km')


#Open Python server for writing and templates for reading
f = open("HSCKML.py","w")
f1 = open("1HSCKML.py")
f2 = open("2HSCKML.py")

#Begin to craft server using FLAG Environment Variable and templates, and calculated azimuth/altitude (heading/tilt)
f.write(f1.read())
realflag=os.environ.get('FLAG','FLAG{Placeholder}')

f.write('flag=\''+realflag+'\'\n')
f.write("if valid and  camlooklng > -77.0437 and camlooklng < -77.0271 and camlooklat > 38.8839 and camlooklat < 38.8943 and camlookhed > ")
f.write(str(az1))
f.write(" and camlookhed < ")
f.write(str(az2))
f.write(" and camlooktlt > ")
f.write(str(alt1))
f.write(" and camlooktlt < ")
f.write(str(alt2))
f.write(":\n")

f.write(f2.read())

f.close()
f1.close()
f2.close()

os.chmod("HSCKML.py", 0757)

#Display prompt for challenger
print "We've captured data from a satellite that shows a flag located at the base of the Washington Monument."
print "The image was taken on March 26th, 2020, at 21:%02d:%02d" %(mins,sec)
print "The satellite we used was: "
print tle_text
IPAddr = os.getenv("SERVICE_HOST","10.0.54.193")
port = os.getenv("SERVICE_PORT","4444")
print "Use a Google Earth Pro KML file to 'Link' to http://"+IPAddr+":"+port+"/cgi-bin/HSCKML.py"
print "and 'LookAt' that spot from where the satellite when it took the photo and get us that flag!"
sys.stdout.flush()

#GIVE CHALLENGER TIME TO CONNECT VIA GOOGLE EARTH WITH ALREADY CRAFTED (AND UPDATED JUST IN TIME) KML FILE
#10 seconds is only for testing purposes, should be more like 200 or more depending on how it works on infrastructure
time.sleep(int(os.getenv("TIMEOUT",300)))

print "Too slow, try again"
sys.stdout.flush()
quit()
