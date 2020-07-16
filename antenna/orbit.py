import datetime
import time
from skyfield.api import load, Topos, EarthSatellite, Time, Angle, Distance

#longlat_regex = "-?[0-9]{1,3}\.[0-9]{1,5} [NSEW]"
#noaa_file = "/home/pi/orbit/noaa-20200409.txt"
# #satellites = load.tle_file(noaa_file)
#by_name = {sat.name: sat for sat in satellites}
#planets = load('de421.bsp')
#earth, mars = planets['earth'], planets['mars']
#print("loaded {} noaa sats from {}".format(len(satellites), noaa_file))

#ts = load.timescale()
#t = ts.now()

class SatelliteObserver:

    def __init__(self, where: Topos, what: EarthSatellite):
        self.where = where
        self.sat = what
        self.sat_name = what.name
        self.ts = load.timescale(builtin=True)

    @classmethod
    def from_strings(cls, longitude: str or float, latitude: str or float, sat_name: str, tle_file: str) -> 'SatelliteObserver':
        place = Topos(latitude, longitude)
        satellites = load.tle(tle_file)
        #print("loaded {} sats from {}".format(len(satellites), tle_file))
        _sats_by_name = {sat.name: sat for sat in satellites.values()}
        satellite = _sats_by_name[sat_name]
        return cls(place, satellite)

    def altAzDist_at(self, at: float) -> (float, float, float):
        """
        :param at: Unix time GMT (timestamp)
        :return: (altitude, azimuth, distance)
        """
        current_gmt = datetime.datetime.utcfromtimestamp(at)
        current_ts = self.ts.utc(current_gmt.year, current_gmt.month, current_gmt.day, current_gmt.hour,
                            current_gmt.minute, current_gmt.second + current_gmt.microsecond / 1000000.0)
        difference = self.sat - self.where
        observer_to_sat = difference.at(current_ts)
        altitude, azimuth, distance = observer_to_sat.altaz()
        return (altitude.degrees, azimuth.degrees, distance.km)

    def current_azAltDist(self) -> (float, float, float):
        return self.altAzDist_at(time.time())

    def above_horizon(self, at: float) -> bool:
        """
        :param at: Unix time GMT
        :return:
        """
        (alt, az, dist) = self.altAzDist_at(at)
        return alt > 0





