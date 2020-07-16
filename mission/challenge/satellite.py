import time
from datetime import datetime, timedelta, timezone
import numpy as np
from skyfield.api import load, EarthSatellite, Topos
from skyfield import almanac
from random import randint

# THRESHOLDS
TEMP_LOWER = 0
TEMP_UPPER = 60

ADCS_WHEEL_RPM = 7000

BATT_PERCENT = 10

OBC_DISK = 100

REQUIRED_DATA = 120.0e6  # bytes

# Conversion Params
OBC_DISK_SIZE = 95.3674e6  # bytes


class MissionFailure(Exception):
    """Mission plan failed to successfully execute the mission"""


class Satellite:
    def __init__(self, tle_1, tle_2, gs_lat, gs_long, target_lat, target_long, T0, duration):
        self.current_mode = "data_downlink"
        self.possible_modes = ["sun_point", "imaging", "data_downlink", "wheel_desaturate"]
        self.telemetry = {
            "batt": {
                "percent": 80,
                "temp": 25
            },
            "panels": {
                "illuminated": True
            },
            "comms": {
                "pwr": False,
                "temp": 25
            },
            "obc": {
                "disk": 0,
                "temp": 25
            },
            "adcs": {
                "mode": None,
                "temp": 25,
                "whl_rpm": [0, 0, 0],
                "mag_pwr": [False, False, False]
            },
            "cam": {
                "pwr": False,
                "temp": 25
            }
        }
        self.collected_data = 0
        self.start_time = datetime(
            T0[0], T0[1], T0[2],
            tzinfo=timezone.utc)
        self.end_time = self.start_time + timedelta(hours=duration)
        self.duration = duration

        self.ts = load.timescale()
        self.groundstation = Topos(gs_lat, gs_long)
        self.target = Topos(target_lat, target_long)
        self.satellite = EarthSatellite(tle_1, tle_2)
        self.ephemeris = load('de421.bsp')

        # Calculate groundstation passes in the time window
        gs_min_alt_degrees = 5.0
        gs_t, gs_events = self.satellite.find_events(
            self.groundstation,
            self.ts.utc(self.start_time),
            self.ts.utc(self.end_time),
            altitude_degrees=gs_min_alt_degrees)
        if len(gs_events) == 0:
            raise(ValueError("No ground station passes in the given time window."))

        gs_sunlit = self._satellite_sunlit(times=gs_t)
        # print("\nExpected Ground Station Passses\n##############")
        aos = []
        los = []
        for ti, event, is_sunlit in zip(gs_t, gs_events, gs_sunlit):
            name = (f'rise above {gs_min_alt_degrees}°', 'culminate',
                    f'set below {gs_min_alt_degrees}°')[event]
            # print(ti.utc_datetime().strftime("%Y-%m-%dT%H:%M:%SZ"),
            #       name, "Satellite Illuminated:", is_sunlit)
            if event == 0:
                aos.append(ti)
            elif event == 2:
                los.append(ti)

        self.gs_passes = []
        for aos_t in aos:
            for los_t in los:
                if los_t.utc_datetime() > aos_t.utc_datetime():
                    self.gs_passes.append([aos_t, los_t])
                    break

        # Calculate target passes in the time window
        target_min_alt_degrees = 5.0
        target_t, target_events = self.satellite.find_events(
            self.target,
            self.ts.utc(self.start_time),
            self.ts.utc(self.end_time),
            altitude_degrees=target_min_alt_degrees)
        if len(target_events) == 0:
            raise(ValueError("No target passes in the given time window."))

        # print("\nExpected Target Passses\n##############")
        target_aos = []
        target_los = []
        for ti, event in zip(target_t, target_events):
            name = (f'rise above {target_min_alt_degrees}°', 'culminate',
                    f'set below {target_min_alt_degrees}°')[event]

            # print(ti.utc_datetime().strftime("%Y-%m-%dT%H:%M:%SZ"),
            #       name, "Target Illuminated:", self._location_sunlit(ti, self.target))
            if event == 0:
                target_aos.append(ti)
            elif event == 2:
                target_los.append(ti)

        self.target_passes = []
        for aos_t in target_aos:
            for los_t in target_los:
                if los_t.utc_datetime() > aos_t.utc_datetime():
                    self.target_passes.append([aos_t, los_t])
                    break

    def execute_mission_plan(self, mission_plan):
        tlm_plottable = {
            "batt": {"percent": [], "temp": []},
            "panels": {"illuminated": []},
            "comms": {"pwr": [], "temp": []},
            "obc": {"disk": [], "temp": []},
            "adcs": {"mode": [], "temp": [], "whl_rpm": [], "mag_pwr": []},
            "cam": {"pwr": [], "temp": []}
        }
        print("Executing mission plan.")
        time.sleep(1)

        # Construct iterator
        step_minutes = np.arange(0, self.duration*60, 1.0)
        times = []
        for idx, step in enumerate(step_minutes):
            times.append(self.start_time+timedelta(minutes=step))

        # Calculate sunlit times
        sunlit = self._satellite_sunlit(times=self.ts.utc(times))

        # Begin simulation
        for idx, current_time in enumerate(times):
            print(current_time.strftime("%Y-%m-%dT%H:%M:%SZ"))
            for entry in mission_plan:
                if current_time == entry[0]:
                    self._mode_change(new_mode=entry[1], current_time=current_time)

            self._update_tlm(sunlit=sunlit[idx])
            self._check_pass_validity(current_time=current_time)
            errors = self._check_telemetry()
            for subsystem in self.telemetry:
                for item in self.telemetry[subsystem]:
                    tlm_plottable[subsystem][item].append(self.telemetry[subsystem][item])
            if errors != []:
                raise(MissionFailure(errors))
            time.sleep(0.005)

        if self.collected_data >= REQUIRED_DATA:
            # from matplotlib import pyplot as plt
            # plt.title('Temperatures')
            # plt.plot(times, tlm_plottable["batt"]["temp"], label="batt")
            # plt.plot(times, tlm_plottable["comms"]["temp"], label="comms")
            # plt.plot(times, tlm_plottable["obc"]["temp"], label="obs")
            # plt.plot(times, tlm_plottable["adcs"]["temp"], label="adcs")
            # plt.plot(times, tlm_plottable["cam"]["temp"], label="cam")
            # plt.title('Wheel Speeds')
            # plt.plot(times, tlm_plottable["adcs"]["whl_rpm"])
            # plt.title('Percentages')
            # plt.plot(times, tlm_plottable["batt"]["percent"], label="batt %")
            # plt.plot(times, tlm_plottable["obc"]["disk"], label="obc disk")
            # plt.legend()
            # plt.show()

            return True
        else:
            raise(MissionFailure("Data was not obtained within the time limit."))

    def _update_tlm(self, sunlit):
        # Updates all the tlm based on current mode
        self.telemetry["panels"]["illuminated"] = sunlit

        # sun_point
        if self.current_mode == "sun_point":

            # batt
            if sunlit:
                if self.telemetry["batt"]["percent"] < 100:
                    if (100 - self.telemetry["batt"]["percent"]) < 0.6:
                        self.telemetry["batt"]["percent"] = 100
                    else:
                        self.telemetry["batt"]["percent"] += 0.6
                self._change_all_temps(step=0.1, upper=30)
            else:
                self._change_all_temps(step=-0.1)

            # comms
            self.telemetry["comms"]["pwr"] = False
            if self.telemetry["comms"]["temp"] > 25:
                self.telemetry["comms"]["temp"] += -0.2

            # cam
            self.telemetry["cam"]["pwr"] = False
            if self.telemetry["cam"]["temp"] > 25:
                self.telemetry["cam"]["temp"] += -0.2

            # adcs
            self.telemetry["adcs"]["mode"] = "track_sun"
            self.telemetry["adcs"]["mag_pwr"] = [False, False, False]
            self._change_wheel_speeds(step=10)
            self.telemetry["batt"]["percent"] += -.1

            # none for obc
        elif self.current_mode == "imaging":
            # batt
            if sunlit:
                self._change_all_temps(step=0.2)
            else:
                self._change_all_temps(step=-0.1)

            # comms
            self.telemetry["comms"]["pwr"] = False
            if self.telemetry["comms"]["temp"] > 25:
                self.telemetry["comms"]["temp"] += -0.2

            # cam
            self.telemetry["cam"]["pwr"] = True
            self.telemetry["batt"]["percent"] += -8
            self.telemetry["cam"]["temp"] += 5
            self.telemetry["batt"]["temp"] += 1

            # adcs
            self.telemetry["adcs"]["mode"] = "target_track"
            self.telemetry["adcs"]["mag_pwr"] = [False, False, False]
            self._change_wheel_speeds(step=50)
            self.telemetry["batt"]["percent"] += -.1

            # obc
            self.telemetry["obc"]["disk"] += 10

        elif self.current_mode == "data_downlink":
            # batt
            if sunlit:
                self._change_all_temps(step=0.2)
            else:
                self._change_all_temps(step=-0.1)

            # comms
            self.telemetry["comms"]["pwr"] = True
            self.telemetry["batt"]["percent"] += -10
            self.telemetry["comms"]["temp"] += 7
            self.telemetry["batt"]["temp"] += 1

            # cam
            self.telemetry["cam"]["pwr"] = False
            if self.telemetry["cam"]["temp"] > 25:
                self.telemetry["cam"]["temp"] += -0.2

            # adcs
            self.telemetry["adcs"]["mode"] = "target_track"
            self.telemetry["adcs"]["mag_pwr"] = [False, False, False]
            self._change_wheel_speeds(step=50)
            self.telemetry["batt"]["percent"] += -.1

            # obc and data collection
            if self.telemetry["obc"]["disk"] <= 20:
                self.collected_data += self.telemetry["obc"]["disk"]/100*OBC_DISK_SIZE
                self.telemetry["obc"]["disk"] = 0
            else:
                self.telemetry["obc"]["disk"] += -20
                self.collected_data += 20/100*OBC_DISK_SIZE

        elif self.current_mode == "wheel_desaturate":
            # batt
            if sunlit:
                self._change_all_temps(step=0.2)
            else:
                self._change_all_temps(step=-0.1)

            # comms
            self.telemetry["comms"]["pwr"] = False

            # cam
            self.telemetry["cam"]["pwr"] = False

            # adcs
            self.telemetry["adcs"]["mode"] = "desaturate"
            self.telemetry["adcs"]["mag_pwr"] = [True, True, True]
            self._change_wheel_speeds(step=-100)
            self.telemetry["batt"]["percent"] += -.2

            # none for obc

        print(self.telemetry)
        print(f"Collected Data: {self.collected_data} bytes")

    def _mode_change(self, new_mode, current_time):
        if self.current_mode == new_mode:
            raise(ValueError(f"Already in '{new_mode}'"))
        elif new_mode not in self.possible_modes:
            raise(ValueError(f"Mode must be one of: {self.possible_modes}"))

        print(f"Changing mode to: {new_mode}")
        self.current_mode = new_mode

    def _check_pass_validity(self, current_time):
        valid_pass = False
        if self.current_mode == "imaging":
            for target_pass in self.target_passes:
                if target_pass[0].utc_datetime() < current_time and target_pass[1].utc_datetime() > current_time:
                    valid_pass = True
            if not valid_pass:
                raise(MissionFailure("ERROR: Target not in view. Cannot image."))
            if not self._location_sunlit(time=self.ts.utc(current_time), location=self.target):
                raise(MissionFailure("ERROR: Target location is not sunlit. Cannot image."))

        elif self.current_mode == "data_downlink":
            for gs_pass in self.gs_passes:
                if gs_pass[0].utc_datetime() < current_time and gs_pass[1].utc_datetime() > current_time:
                    valid_pass = True
            if not valid_pass:
                raise(MissionFailure("ERROR: Ground station not in view. Cannot downlink data."))

    def _satellite_sunlit(self, times):
        # Calculate eclipse times for passes
        Re = 6378.137
        earth = self.ephemeris['earth']
        sun = self.ephemeris['sun']
        sat = earth + self.satellite
        sunpos, earthpos, satpos = [thing.at(times).position.km for thing in (sun, earth, sat)]
        sunearth, sunsat = earthpos-sunpos, satpos-sunpos
        sunearthnorm, sunsatnorm = [
            vec/np.sqrt((vec**2).sum(axis=0)) for vec in (sunearth, sunsat)]
        angle = np.arccos((sunearthnorm * sunsatnorm).sum(axis=0))
        sunearthdistance = np.sqrt((sunearth**2).sum(axis=0))
        sunsatdistance = np.sqrt((sunsat**2).sum(axis=0))
        limbangle = np.arctan2(Re, sunearthdistance)
        sunlit = []
        for idx, value in enumerate(angle):
            sunlit.append(((angle[idx] > limbangle[idx]) or (
                sunsatdistance[idx] < sunearthdistance[idx])))
        return sunlit

    def _location_sunlit(self, time, location):
        """
        Returns a function that tells you if the sun is shining at a given
        time in a given location.
        """
        func = almanac.sunrise_sunset(self.ephemeris, self.target)
        return func(time)

    def _change_all_temps(self, step, upper=None, lower=None):
        for subsystem in self.telemetry:
            for field in self.telemetry[subsystem]:
                if field == "temp":
                    if upper:
                        if self.telemetry[subsystem][field] < upper:
                            self.telemetry[subsystem][field] += step
                    elif lower:
                        if self.telemetry[subsystem][field] > lower:
                            self.telemetry[subsystem][field] += step
                    else:
                        self.telemetry[subsystem][field] += step

    def _change_wheel_speeds(self, step):
        x = randint(1, 100)
        y = randint(1, 100)
        z = randint(1, 100)
        total = x+y+z
        x = x/total*step
        y = y/total*step
        z = z/total*step
        if step < 0:
            if self.telemetry["adcs"]["whl_rpm"][0] <= abs(x):
                self.telemetry["adcs"]["whl_rpm"][0] = 0
                x = 0
            if self.telemetry["adcs"]["whl_rpm"][1] <= abs(y):
                self.telemetry["adcs"]["whl_rpm"][1] = 0
                y = 0
            if self.telemetry["adcs"]["whl_rpm"][2] <= abs(z):
                self.telemetry["adcs"]["whl_rpm"][2] = 0
                z = 0

        self.telemetry["adcs"]["whl_rpm"] = [
            self.telemetry["adcs"]["whl_rpm"][0] + x,
            self.telemetry["adcs"]["whl_rpm"][1] + y,
            self.telemetry["adcs"]["whl_rpm"][2] + z
        ]

    def _check_telemetry(self):
        errors = []
        for subsystem in self.telemetry:
            for field in self.telemetry[subsystem]:
                if field == "temp":
                    if self.telemetry[subsystem][field] < TEMP_LOWER:
                        errors.append(
                            f"ERROR: {subsystem} is no longer operational due to low temp.")
                    elif self.telemetry[subsystem][field] > TEMP_UPPER:
                        errors.append(
                            f"ERROR: {subsystem} fried due to high temp.")

        for idx, axis in enumerate(self.telemetry['adcs']['whl_rpm']):
            if abs(axis) > ADCS_WHEEL_RPM:
                errors.append(
                    f"ERROR: adcs wheel {idx} has exceeded max wheel speed.")

        if self.telemetry["obc"]["disk"] > OBC_DISK:
            errors.append("ERROR: Disk is full. Data partition is corrupted.")

        if self.telemetry["batt"]["percent"] < BATT_PERCENT:
            errors.append("ERROR: Battery level critical. Entering Safe Mode.")

        return errors
