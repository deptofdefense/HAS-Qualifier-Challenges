
from skyfield.api import load

planets = load('de421.bsp')
earth, moon = planets['earth'], planets['moon']

ts = load.timescale()
t = ts.now()
astrometric = earth.at(t).observe(moon)
ra, dec, distance = astrometric.radec()

print(ra)
print(dec)
print(distance)
