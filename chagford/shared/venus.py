from skyfield.api import load

planets = load('de421.bsp')
earth, venus = planets['earth'], planets['venus']

ts = load.timescale()
t = ts.now()
astrometric = earth.at(t).observe(venus)
ra, dec, distance = astrometric.radec()

print(ra)
print(dec)
print(distance)
