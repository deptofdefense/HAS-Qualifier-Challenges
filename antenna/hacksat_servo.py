# The MIT License (MIT)
#
# Copyright (c) 2017 Scott Shawcroft for Adafruit Industries LLC
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
"""
`adafruit_motor.servo`
====================================================

Servos are motor based actuators that incorporate a feedback loop into the design. These feedback
loops enable pulse width modulated control to determine position or rotational speed.

* Author(s): Scott Shawcroft
"""

__version__ = "0.0.0-auto.0"
__repo__ = "https://github.com/adafruit/Adafruit_CircuitPython_Motor.git"

class PWMOut:
    def __init__(self, frequency=50, duty_cycle=0):
        self.frequency = frequency
        self.duty_cycle = duty_cycle

# We disable the too few public methods check because this is a private base class for the two types
# of servos.
class _BaseServo:  # pylint: disable-msg=too-few-public-methods
    """Shared base class that handles pulse output based on a value between 0 and 1.0

       :param ~pulseio.PWMOut pwm_out: PWM output object.
       :param int min_pulse: The minimum pulse length of the servo in microseconds.
       :param int max_pulse: The maximum pulse length of the servo in microseconds."""

    def __init__(self, pwm_out, *, min_pulse=750, max_pulse=2250): 
        self._pwm_out = PWMOut()
        self.set_pulse_width_range(min_pulse, max_pulse)


    def set_pulse_width_range(self, min_pulse=750, max_pulse=2250):
        """Change min and max pulse widths."""
        self._min_duty = int((min_pulse * self._pwm_out.frequency) / 1000000 * 0xFFFF)
        max_duty = (max_pulse * self._pwm_out.frequency) / 1000000 * 0xFFFF
        self._duty_range = int(max_duty - self._min_duty)

    @property
    def fraction(self):
        """Pulse width expressed as fraction between 0.0 (`min_pulse`) and 1.0 (`max_pulse`).
        For conventional servos, corresponds to the servo position as a fraction
        of the actuation range. Is None when servo is diabled (pulsewidth of 0ms).
        """
        if self._pwm_out.duty_cycle == 0:  # Special case for disabled servos
            return None
        return (self._pwm_out.duty_cycle - self._min_duty) / self._duty_range

    @fraction.setter
    def fraction(self, value):
        if value is None:
            self._pwm_out.duty_cycle = 0  # disable the motor
            return
        if not 0.0 <= value <= 1.0:
            raise ValueError("Must be 0.0 to 1.0")
        duty_cycle = self._min_duty + int(value * self._duty_range)
        self._pwm_out.duty_cycle = duty_cycle


class Servo(_BaseServo):
    """Control the position of a servo.

       :param ~pulseio.PWMOut pwm_out: PWM output object.
       :param int actuation_range: The physical range of motion of the servo in degrees, \
           for the given ``min_pulse`` and ``max_pulse`` values.
       :param int min_pulse: The minimum pulse width of the servo in microseconds.
       :param int max_pulse: The maximum pulse width of the servo in microseconds.

       ``actuation_range`` is an exposed property and can be changed at any time:

        .. code-block:: python

          servo = Servo(pwm)
          servo.actuation_range = 135

       The specified pulse width range of a servo has historically been 1000-2000us,
       for a 90 degree range of motion. But nearly all modern servos have a 170-180
       degree range, and the pulse widths can go well out of the range to achieve this
       extended motion. The default values here of ``750`` and ``2250`` typically give
       135 degrees of motion. You can set ``actuation_range`` to correspond to the
       actual range of motion you observe with your given ``min_pulse`` and ``max_pulse``
       values.

       .. warning:: You can extend the pulse width above and below these limits to
         get a wider range of movement. But if you go too low or too high,
         the servo mechanism may hit the end stops, buzz, and draw extra current as it stalls.
         Test carefully to find the safe minimum and maximum.
    """

    def __init__(self, pwm_out, *, actuation_range=180, min_pulse=750, max_pulse=2250):
        super().__init__(pwm_out, min_pulse=min_pulse, max_pulse=max_pulse)
        self.actuation_range = actuation_range
        """The physical range of motion of the servo in degrees."""
        self._pwm = self._pwm_out

    @property
    def angle(self):
        """The servo angle in degrees. Must be in the range ``0`` to ``actuation_range``.
        Is None when servo is disabled."""
        if self.fraction is None:  # special case for disabled servos
            return None
        return self.actuation_range * self.fraction

    @angle.setter
    def angle(self, new_angle):
        if new_angle is None:  # disable the servo by sending 0 signal
            self.fraction = None
            return
        if new_angle < 0 or new_angle > self.actuation_range:
            raise ValueError("Angle out of range")
        self.fraction = new_angle / self.actuation_range


class ContinuousServo(_BaseServo):
    """Control a continuous rotation servo.

       :param int min_pulse: The minimum pulse width of the servo in microseconds.
       :param int max_pulse: The maximum pulse width of the servo in microseconds."""

    @property
    def throttle(self):
        """How much power is being delivered to the motor. Values range from ``-1.0`` (full
           throttle reverse) to ``1.0`` (full throttle forwards.) ``0`` will stop the motor from
           spinning."""
        return self.fraction * 2 - 1

    @throttle.setter
    def throttle(self, value):
        if value > 1.0 or value < -1.0:
            raise ValueError("Throttle must be between -1.0 and 1.0")
        if value is None:
            raise ValueError("Continuous servos cannot spin freely")
        self.fraction = (value + 1) / 2

    def __enter__(self):
        return self

    def __exit__(self, exception_type, exception_value, traceback):
        self.throttle = 0
