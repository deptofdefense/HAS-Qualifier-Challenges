from skyfield.api import load

planets = load('de421.bsp')
earth, sun = planets['earth'], planets['sun']

ts = load.timescale()
t = ts.now()
astrometric = earth.at(t).observe(sun)
ra, dec, distance = astrometric.radec()

print(ra)
print(dec)
print(distance)
