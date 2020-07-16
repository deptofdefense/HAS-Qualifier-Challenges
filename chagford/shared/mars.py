from skyfield.api import load

planets = load('de421.bsp')
earth, mars = planets['earth'], planets['mars']

ts = load.timescale()
t = ts.now()
astrometric = earth.at(t).observe(mars)
ra, dec, distance = astrometric.radec()

print(ra)
print(dec)
print(distance)


