import subset, solve, sun
import sys, pprint
import numpy as np

if __name__ == "__main__":
    path = sys.argv[1]
    files = [("images/capture5_8.jpg", "images/receipt5_8.txt", "")] # subset.makeList(path)
    results = []
    for a,b,c in files:
        with open(b, 'r') as f:
            lines = f.readlines()
            minutes,hour,day,month,year = map(int,lines[0].split(":")[1].split("-"))
            lat,lon = map(float, lines[1].split(":")[1].split(","))
            ca,ce = map(float, lines[2].split(":")[1].split(","))
            la,le = map(float, lines[3].split(":")[1].split(","))
        tla, tle, tca, tce, m, h = solve.solve(a, lat, lon, day, month, year)
        results.append(( tla-la, tle-le, tca-ca, tce-ce ))
        
    pprint.pprint(results)
        
