import math

def calcTimeJulianCent(jd):
    T = (jd - 2451545.0)/36525.0
    return T

def calcJDFromJulianCent(t):
    JD = t * 36525.0 + 2451545.0
    return JD

def isLeapYear(yr):
    return ((yr % 4 == 0 and yr % 100 != 0) or yr % 400 == 0)

def calcDoyFromJD(jd):
    z = math.floor(jd + 0.5)
    f = (jd + 0.5) - z
    if (z < 2299161):
        A = z
    else :
        alpha = math.floor((z - 1867216.25)/36524.25)
    A = z + 1 + alpha - math.floor(alpha/4)
    B = A + 1524
    C = math.floor((B - 122.1)/365.25)
    D = math.floor(365.25 * C)
    E = math.floor((B - D)/30.6001)
    day = B - D - math.floor(30.6001 * E) + f
    month = E - 1 if (E < 14) else E - 13
    year = C - 4716 if (month > 2) else C - 4715

    k = 1 if isLeapYear(year) else 2
    doy = math.floor((275 * month)/9) - k * math.floor((month + 9)/12) + day -30
    return doy


def radToDeg(angleRad):
  return (180.0 * angleRad / math.pi)

def degToRad(angleDeg):
  return (math.pi * angleDeg / 180.0)

def calcGeomMeanLongSun(t):
    L0 = 280.46646 + t * (36000.76983 + t*(0.0003032))

    while(L0 > 360.0):
        L0 -= 360.0

    while(L0 < 0.0):
        L0 += 360.0
  
    return L0

def calcGeomMeanAnomalySun(t):
    M = 357.52911 + t * (35999.05029 - 0.0001537 * t)
    return M

def calcEccentricityEarthOrbit(t):
    e = 0.016708634 - t * (0.000042037 + 0.0000001267 * t)
    return e

def calcSunEqOfCenter(t):
    m = calcGeomMeanAnomalySun(t)
    mrad = degToRad(m)
    sinm = math.sin(mrad)
    sin2m = math.sin(mrad+mrad)
    sin3m = math.sin(mrad+mrad+mrad)
    C = sinm * (1.914602 - t * (0.004817 + 0.000014 * t)) + sin2m * (0.019993 - 0.000101 * t) + sin3m * 0.000289
    return C

def calcSunTrueLong(t):
    l0 = calcGeomMeanLongSun(t)
    c = calcSunEqOfCenter(t)
    O = l0 + c
    return O

def calcSunTrueAnomaly(t):
    m = calcGeomMeanAnomalySun(t)
    c = calcSunEqOfCenter(t)
    v = m + c
    return v    

def calcSunRadVector(t):
    v = calcSunTrueAnomaly(t)
    e = calcEccentricityEarthOrbit(t)
    R = (1.000001018 * (1 - e * e)) / (1 + e * math.cos(degToRad(v)))
    return R

def calcSunApparentLong(t):
    o = calcSunTrueLong(t)
    omega = 125.04 - 1934.136 * t
    l = o - 0.00569 - 0.00478 * math.sin(degToRad(omega))
    return l

def calcMeanObliquityOfEcliptic(t):
    seconds = 21.448 - t*(46.8150 + t*(0.00059 - t*(0.001813)))
    e0 = 23.0 + (26.0 + (seconds/60.0))/60.0
    return e0

def calcObliquityCorrection(t):
    e0 = calcMeanObliquityOfEcliptic(t)
    omega = 125.04 - 1934.136 * t
    e = e0 + 0.00256 * math.cos(degToRad(omega))
    return e

def calcSunRtAscension(t):
    e = calcObliquityCorrection(t)
    l = calcSunApparentLong(t)
    tananum = (math.cos(degToRad(e)) * math.sin(degToRad(l)))
    tanadenom = (math.cos(degToRad(l)))
    alpha = radToDeg(math.atan2(tananum, tanadenom))
    return alpha

def calcSunDeclination(t):
    e = calcObliquityCorrection(t)
    l = calcSunApparentLong(t)

    sint = math.sin(degToRad(e)) * math.sin(degToRad(l))
    theta = radToDeg(math.asin(sint))
    return theta

def calcEquationOfTime(t):
    epsilon = calcObliquityCorrection(t)
    l0 = calcGeomMeanLongSun(t)
    e = calcEccentricityEarthOrbit(t)
    m = calcGeomMeanAnomalySun(t)

    y = math.tan(degToRad(epsilon)/2.0)
    y *= y

    sin2l0 = math.sin(2.0 * degToRad(l0))
    sinm   = math.sin(degToRad(m))
    cos2l0 = math.cos(2.0 * degToRad(l0))
    sin4l0 = math.sin(4.0 * degToRad(l0))
    sin2m  = math.sin(2.0 * degToRad(m))

    Etime = y * sin2l0 - 2.0 * e * sinm + 4.0 * e * y * sinm * cos2l0 - 0.5 * y * y * sin4l0 - 1.25 * e * e * sin2m
    return radToDeg(Etime)*4.0

def calcHourAngleSunrise(lat, solarDec):
    latRad = degToRad(lat)
    sdRad  = degToRad(solarDec)
    HAarg = (math.cos(degToRad(90.833))/(math.cos(latRad)*math.cos(sdRad))-math.tan(latRad) * math.tan(sdRad))
    HA = math.acos(HAarg)
    return HA


monthList = [
        31,
	28,
	31,
	30,
	31,
	30,
	31,
	31,
	30,
	31,
	30,
	31,
    ]



def getJD(docday,docmonth,docyear):
    if ( (isLeapYear(docyear)) and (docmonth == 2) ):
        if (docday > 29):
            docday = 29
            document.getElementById("daybox").selectedIndex = docday - 1
    else:
        if (docday > monthList[docmonth-1]):
            docday = monthList[docmonth-1]
            document.getElementById("daybox").selectedIndex = docday - 1
    if (docmonth <= 2):
        docyear -= 1
        docmonth += 12
    A = math.floor(docyear/100)
    B = 2 - A + math.floor(A/4)
    JD = math.floor(365.25*(docyear + 4716)) + math.floor(30.6001*(docmonth+1)) + docday + B - 1524.5
    return JD

def calcAzEl(T, localtime, latitude, longitude, zone):
    eqTime = calcEquationOfTime(T)
    theta  = calcSunDeclination(T)
    solarTimeFix = eqTime + 4.0 * longitude - 60.0 * zone
    earthRadVec = calcSunRadVector(T)
    trueSolarTime = localtime + solarTimeFix
    while (trueSolarTime > 1440):
        trueSolarTime -= 1440
    hourAngle = trueSolarTime / 4.0 - 180.0
    if (hourAngle < -180):
        hourAngle += 360.0
    haRad = degToRad(hourAngle)
    csz = math.sin(degToRad(latitude)) * math.sin(degToRad(theta)) + math.cos(degToRad(latitude)) * math.cos(degToRad(theta)) * math.cos(haRad)
    if (csz > 1.0) :
        csz = 1.0
    elif (csz < -1.0):
        csz = -1.0
    zenith = radToDeg(math.acos(csz))
    azDenom = ( math.cos(degToRad(latitude)) * math.sin(degToRad(zenith)) )
    if (abs(azDenom) > 0.001):
        azRad = (( math.sin(degToRad(latitude)) * math.cos(degToRad(zenith)) ) - math.sin(degToRad(theta))) / azDenom
        if (abs(azRad) > 1.0):
            if (azRad < 0):
                azRad = -1.0
            else:
                azRad = 1.0
        azimuth = 180.0 - radToDeg(math.acos(azRad))
        if hourAngle > 0.0:
          azimuth = -azimuth
    else:
        if (latitude > 0.0):
            azimuth = 180.0
        else:
            azimuth = 0.0
    if (azimuth < 0.0):
        azimuth += 360.0

    exoatmElevation = 90.0 - zenith


    if (exoatmElevation > 85.0):
        refractionCorrection = 0.0
    else:
        te = math.tan (degToRad(exoatmElevation))
        if (exoatmElevation > 5.0):
            refractionCorrection = 58.1 / te - 0.07 / (te*te*te) + 0.000086 / (te*te*te*te*te)
        elif (exoatmElevation > -0.575):
            refractionCorrection = 1735.0 + exoatmElevation * (-518.2 + exoatmElevation * (103.4 + exoatmElevation * (-12.79 + exoatmElevation * 0.711) ) )
        else:
            refractionCorrection = -20.774 / te
        refractionCorrection = refractionCorrection / 3600.0

    solarZen = zenith - refractionCorrection
    azimuth = (azimuth*100 + 0.5)/100.0
    elevation = ((90.0-solarZen)*100+0.5)/100.0
    return (azimuth, elevation)

def findSun(lat, lon, th, tmin=0, td=1,tm=1,ty=2020,tz=0):
    tl = th*60 + tmin
    jday = getJD(td,tm,ty)
    total = jday + tl/1440.0 - tz/24.0
    T = calcTimeJulianCent(total)
    return calcAzEl(T, tl, lat, lon, tz)

if __name__ == "__main__":
    print(findSun(40,20,12))
