try:
    from adafruit_servokit import ServoKit
except:
    from hacksat_servokit import ServoKit
from typing import Tuple
from collections import namedtuple

AZIMUTH_SERVO = 3
ELEVATION_SERVO = 4
SIMULATE_AZIMUTH_SERVO = 6
SIMULATE_ELEVATION_SERVO = 7
MIN_ANGLE = 1   # this is used in a division and floating point rounds to a value below 0 >=(
                # better than accidentally being negative...

MAX_ELEVATION = 155 # for safety with the LynxMotion kit. would be nice to have 180.
                    # don't restrict when generating motion trace examples

DutyCycle = namedtuple("DutyCycle", ["az_duty", "el_duty"])

class AntennaController:

    def __init__(self, motion_restrict: bool=False, simulate: bool=False):
        self.kit = ServoKit(channels=16)
        if simulate:
            self.azimuth_servo = self.kit.servo[SIMULATE_AZIMUTH_SERVO]
            self.elevation_servo = self.kit.servo[SIMULATE_ELEVATION_SERVO]
        else:
            self.azimuth_servo = self.kit.servo[AZIMUTH_SERVO]
            self.elevation_servo = self.kit.servo[ELEVATION_SERVO]
        self.azimuth_servo.angle = MIN_ANGLE
        self.elevation_servo.angle = MIN_ANGLE
        self.desired_elevation = MIN_ANGLE
        self.western_azimuth = False
        self.motion_restrict = motion_restrict

    def set_azimuth(self, az: int) -> Tuple[int, int]:
        """
        Our servos only move within 180 degrees, so if we want to point at something
        to the west (>180deg azimuth), we have to take the complement, essentially,
        by adjusting the azimuth within the acceptable range and then subtracting the elevation
        from 180 to account for the rotation of the whole antenna assembly
        being pointed the other way. When crossing from 0->359 or 180->181, we have to
        perform this adjustment on the elevation.
        :param az: new azimuth, [0, 360) degrees
        :return: the new duty cycles for the azimuth and elevation servos: (az_duty, el_duty)
        """
        if not 0 <= az < 360:
            raise ValueError("illegal azimuth: {}".format(az))

        if not self.western_azimuth and az <= 180:
            # everything normal
            self.azimuth_servo.angle = az
        elif self.western_azimuth and az > 180:
            # already western, don't modify elevation
            reverse_azimuth = az - 180
            self.azimuth_servo.angle = reverse_azimuth
        elif not self.western_azimuth and az > 180:
            # going from eastern to western azimuth, reverse elevation to complement
            self.western_azimuth = True
            reverse_azimuth = az - 180
            reverse_elevation = 180 - self.elevation_servo.angle
            self.azimuth_servo.angle = reverse_azimuth
            if self.motion_restrict:
                self.desired_elevation = reverse_azimuth
                self.elevation_servo.angle = reverse_elevation if reverse_elevation <= MAX_ELEVATION else self.desired_elevation
            else:
                self.elevation_servo.angle = reverse_elevation
        elif self.western_azimuth and az <= 180:
            # going from western to eastern, reverse elevation back to normal
            self.western_azimuth = False
            self.azimuth_servo.angle = az
            if self.motion_restrict:
                reverse_elevation = 180 - self.desired_elevation
            else:
                reverse_elevation = 180 - self.elevation_servo.angle
            self.elevation_servo.angle = reverse_elevation
        else:
            raise RuntimeError("Wha?? {} {} {}".format(self.azimuth_servo.angle, az, self.western_azimuth))

        if self.elevation_servo.angle < MIN_ANGLE:
            self.elevation_servo.angle = MIN_ANGLE

        az_duty = self.azimuth_servo._pwm_out.duty_cycle
        el_duty = self.elevation_servo._pwm_out.duty_cycle
        return (az_duty, el_duty)

    def set_elevation(self, el: int) -> Tuple[int, int]:
        """
        :param el: the new elevation, [0,90] degrees
        :return: the new duty cycles for the azimuth and elevation servos: (az_duty, el_duty)
        """
        if not 0 <= el <= 90:
            raise ValueError("illegal elevation: {}".format(el))

        if self.western_azimuth and el != 90:
            if self.motion_restrict:
                self.desired_elevation = 180 - el
                self.elevation_servo.angle = self.desired_elevation if self.desired_elevation <= MAX_ELEVATION else MAX_ELEVATION
            else:
                self.elevation_servo.angle = 180 - el
        else:
            self.elevation_servo.angle = el

        if self.elevation_servo.angle < MIN_ANGLE:
            self.elevation_servo.angle = MIN_ANGLE

        az_duty = self.azimuth_servo._pwm_out.duty_cycle
        el_duty = self.elevation_servo._pwm_out.duty_cycle
        return (az_duty, el_duty)

    def get_duty_cycles(self) -> Tuple[int, int]:
        """
        :return: the duty cycles for the azimuth and elevation servos: (az_duty, el_duty)
        """
        az_duty = self.azimuth_servo._pwm_out.duty_cycle
        el_duty = self.elevation_servo._pwm_out.duty_cycle
        return (az_duty, el_duty)


class AntennaDeterminator:
    DUMMY_SERVO_OFFSET = 8 # we don't actually want to control a real servo with this class

    def __init__(self):
        self.kit = ServoKit(channels=16)
        self.azimuth_servo = self.kit.servo[AZIMUTH_SERVO + self.DUMMY_SERVO_OFFSET]
        self.azimuth_servo.angle = MIN_ANGLE
        self.elevation_servo = self.kit.servo[ELEVATION_SERVO + self.DUMMY_SERVO_OFFSET]
        self.elevation_servo.angle = MIN_ANGLE

    def set_duty_cycle(self, az_duty: int, el_duty: int):
        """
        :param az_duty:
        :param el_duty:
        """
        self.azimuth_servo._pwm_out.duty_cycle = az_duty
        self.elevation_servo._pwm_out.duty_cycle = el_duty

    def get_angles(self) -> Tuple[float, float]:
        """
        :return: (azimuth, elevation)
        """
        azimuth = self.azimuth_servo.angle
        elevation = self.elevation_servo.angle
        if elevation > 90:
            azimuth = azimuth + 180
            elevation = 180 - elevation
        return (azimuth, elevation)

