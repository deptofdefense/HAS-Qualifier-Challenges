#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: pwm_side_channel_sim
# GNU Radio version: 3.8.1.0
import datetime
import struct
import time
from distutils.version import StrictVersion

from antenna_control import AntennaController
from orbit import SatelliteObserver
from randomize_challenge import RandomChallengeFactory

if __name__ == '__main__':
    import ctypes
    import sys
    if sys.platform.startswith('linux'):
        try:
            x11 = ctypes.cdll.LoadLibrary('libX11.so')
            x11.XInitThreads()
        except:
            print("Warning: failed to XInitThreads()", file=sys.stderr)

from gnuradio import analog
from gnuradio import blocks
from gnuradio import gr
from gnuradio.filter import firdes
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
import math

REALTIME_PWM_FREQUENCY = 50
PWM_FREQUENCY_MAX = 4000

MAX_DUTY_PERCENT = 0.35
MIN_DUTY_PERCENT = 0.05

WAIT_SEC = 1

OBSERVATION_TIME = 120


class pwm_side_channel_sim(gr.top_block):

    def __init__(self, duty_cycle, pwm_frequency, output_filename, noise_seed):
        gr.top_block.__init__(self, "pwm_side_channel_sim")

        ##################################################
        # Variables
        ##################################################
        self.pulse_freq = pulse_freq = pwm_frequency
        self.duty_cycle = duty_cycle
        self.samp_rate = samp_rate = 2048*pwm_frequency
        self.pulse_length = pulse_length = 0.001 / pwm_frequency
        self.pulse2_phase_shift = pulse2_phase_shift = -2*math.pi*duty_cycle
        self.output_samp_rate = output_samp_rate = 2048 * pwm_frequency
        self.output_filename = output_filename

        ##################################################
        # Blocks
        ##################################################
        self.blocks_throttle_0_1_0_0_1 = blocks.throttle(gr.sizeof_float*1, samp_rate,True)
        self.blocks_throttle_0_1_0_0_0_1_0 = blocks.throttle(gr.sizeof_float*1, samp_rate,True)
        self.blocks_throttle_0_1_0_0_0_1 = blocks.throttle(gr.sizeof_float*1, samp_rate,True)
        self.blocks_throttle_0_1_0_0_0_0 = blocks.throttle(gr.sizeof_float*1, samp_rate,True)
        self.blocks_throttle_0_1_0_0_0 = blocks.throttle(gr.sizeof_float*1, samp_rate,True)
        self.blocks_throttle_0_1_0_0 = blocks.throttle(gr.sizeof_float*1, samp_rate,True)
        self.blocks_throttle_0_0 = blocks.throttle(gr.sizeof_float*1, output_samp_rate,True)
        self.blocks_throttle_0 = blocks.throttle(gr.sizeof_float*1, output_samp_rate,True)
        self.blocks_skiphead_0 = blocks.skiphead(gr.sizeof_float * 1, 0)
        self.blocks_multiply_xx_1_0 = blocks.multiply_vff(1)
        self.blocks_multiply_xx_1 = blocks.multiply_vff(1)
        self.blocks_multiply_xx_0 = blocks.multiply_vff(1)
        self.blocks_multiply_const_vxx_4_0 = blocks.multiply_const_ff(0.75)
        self.blocks_multiply_const_vxx_4 = blocks.multiply_const_ff(0.75)
        self.blocks_multiply_const_vxx_3 = blocks.multiply_const_ff(duty_cycle)
        self.blocks_multiply_const_vxx_2 = blocks.multiply_const_ff(0.5)
        self.blocks_multiply_const_vxx_1 = blocks.multiply_const_ff(-1)
        self.blocks_multiply_const_vxx_0 = blocks.multiply_const_ff(36)
        self.blocks_head_0 = blocks.head(
            gr.sizeof_float * 1,
            int(1.25*output_samp_rate*(REALTIME_PWM_FREQUENCY / PWM_FREQUENCY_MAX))
        )
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_float*1, output_filename, False)
        self.blocks_file_sink_0.set_unbuffered(False)
        self.blocks_add_xx_1 = blocks.add_vff(1)
        self.blocks_add_xx_0 = blocks.add_vff(1)
        self.blocks_add_const_vxx_1 = blocks.add_const_ff(1)
        self.blocks_add_const_vxx_0 = blocks.add_const_ff(-90)
        self.blocks_abs_xx_0_1 = blocks.abs_ff(1)
        self.blocks_abs_xx_0_0_1 = blocks.abs_ff(1)
        self.blocks_abs_xx_0_0_0 = blocks.abs_ff(1)
        self.blocks_abs_xx_0_0 = blocks.abs_ff(1)
        self.blocks_abs_xx_0 = blocks.abs_ff(1)
        self.analog_sig_source_x_2 = analog.sig_source_f(samp_rate, analog.GR_SQR_WAVE, pulse_freq, 1, 0, 0)
        self.analog_sig_source_x_1_0_1 = analog.sig_source_f(samp_rate, analog.GR_SQR_WAVE, pulse_freq, 1, 0, -math.pi*0.0)
        self.analog_sig_source_x_1_0_0_0 = analog.sig_source_f(samp_rate, analog.GR_SQR_WAVE, pulse_freq, 1, 0, math.pi*(1-pulse_length*(pulse_freq*0.625)))
        self.analog_sig_source_x_1_0_0 = analog.sig_source_f(samp_rate, analog.GR_SQR_WAVE, pulse_freq, 1, 0, pulse2_phase_shift+math.pi*(1-pulse_length*(pulse_freq)))
        self.analog_sig_source_x_1_0 = analog.sig_source_f(samp_rate, analog.GR_SQR_WAVE, pulse_freq, 1, 0, pulse2_phase_shift)
        self.analog_sig_source_x_0 = analog.sig_source_f(samp_rate, analog.GR_TRI_WAVE, pulse_freq, 1, 0, )
        self.analog_noise_source_x_0 = analog.noise_source_f(analog.GR_GAUSSIAN, 0.06, noise_seed)



        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_noise_source_x_0, 0), (self.blocks_throttle_0_0, 0))
        self.connect((self.analog_sig_source_x_0, 0), (self.blocks_throttle_0_1_0_0_0_1, 0))
        self.connect((self.analog_sig_source_x_1_0, 0), (self.blocks_throttle_0_1_0_0, 0))
        self.connect((self.analog_sig_source_x_1_0_0, 0), (self.blocks_throttle_0_1_0_0_0, 0))
        self.connect((self.analog_sig_source_x_1_0_0_0, 0), (self.blocks_throttle_0_1_0_0_0_0, 0))
        self.connect((self.analog_sig_source_x_1_0_1, 0), (self.blocks_throttle_0_1_0_0_1, 0))
        self.connect((self.analog_sig_source_x_2, 0), (self.blocks_throttle_0_1_0_0_0_1_0, 0))
        self.connect((self.blocks_abs_xx_0, 0), (self.blocks_multiply_xx_1, 0))
        self.connect((self.blocks_abs_xx_0_0, 0), (self.blocks_multiply_xx_1, 1))
        self.connect((self.blocks_abs_xx_0_0_0, 0), (self.blocks_multiply_xx_1_0, 1))
        self.connect((self.blocks_abs_xx_0_0_1, 0), (self.blocks_multiply_const_vxx_2, 0))
        self.connect((self.blocks_abs_xx_0_1, 0), (self.blocks_multiply_xx_1_0, 0))
        self.connect((self.blocks_add_const_vxx_0, 0), (self.blocks_throttle_0, 0))
        self.connect((self.blocks_add_const_vxx_1, 0), (self.blocks_abs_xx_0_0_1, 0))
        self.connect((self.blocks_add_xx_0, 0), (self.blocks_add_xx_1, 3))
        self.connect((self.blocks_add_xx_1, 0), (self.blocks_multiply_const_vxx_0, 0))
        self.connect((self.blocks_multiply_const_vxx_0, 0), (self.blocks_add_const_vxx_0, 0))
        self.connect((self.blocks_multiply_const_vxx_1, 0), (self.blocks_add_const_vxx_1, 0))
        self.connect((self.blocks_multiply_const_vxx_2, 0), (self.blocks_multiply_xx_0, 0))
        self.connect((self.blocks_multiply_const_vxx_3, 0), (self.blocks_add_xx_0, 0))
        self.connect((self.blocks_multiply_const_vxx_4, 0), (self.blocks_add_xx_1, 1))
        self.connect((self.blocks_multiply_const_vxx_4_0, 0), (self.blocks_add_xx_1, 2))
        self.connect((self.blocks_multiply_xx_0, 0), (self.blocks_add_xx_0, 1))
        self.connect((self.blocks_multiply_xx_1, 0), (self.blocks_multiply_const_vxx_3, 0))
        self.connect((self.blocks_multiply_xx_1, 0), (self.blocks_multiply_const_vxx_4_0, 0))
        self.connect((self.blocks_multiply_xx_1_0, 0), (self.blocks_multiply_const_vxx_4, 0))
        self.connect((self.blocks_throttle_0, 0), (self.blocks_skiphead_0, 0))
        self.connect((self.blocks_head_0, 0), (self.blocks_file_sink_0, 0))
        self.connect((self.blocks_skiphead_0, 0), (self.blocks_head_0, 0))
        self.connect((self.blocks_throttle_0_0, 0), (self.blocks_add_xx_1, 0))
        self.connect((self.blocks_throttle_0_1_0_0, 0), (self.blocks_abs_xx_0, 0))
        self.connect((self.blocks_throttle_0_1_0_0_0, 0), (self.blocks_abs_xx_0_0, 0))
        self.connect((self.blocks_throttle_0_1_0_0_0_0, 0), (self.blocks_abs_xx_0_0_0, 0))
        self.connect((self.blocks_throttle_0_1_0_0_0_1, 0), (self.blocks_multiply_const_vxx_1, 0))
        self.connect((self.blocks_throttle_0_1_0_0_0_1_0, 0), (self.blocks_multiply_xx_0, 1))
        self.connect((self.blocks_throttle_0_1_0_0_1, 0), (self.blocks_abs_xx_0_1, 0))

    def closeEvent(self, event):
        self.settings.setValue("geometry", self.saveGeometry())
        event.accept()

    def get_duty_cycle(self):
        return self.duty_cycle

    def set_duty_cycle(self, duty_cycle):
        self.duty_cycle = duty_cycle
        self.set_pulse2_phase_shift(-2*math.pi*self.duty_cycle)
        self.blocks_multiply_const_vxx_3.set_k(self.duty_cycle)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)
        self.analog_sig_source_x_1_0.set_sampling_freq(self.samp_rate)
        self.analog_sig_source_x_1_0_0.set_sampling_freq(self.samp_rate)
        self.analog_sig_source_x_1_0_0_0.set_sampling_freq(self.samp_rate)
        self.analog_sig_source_x_1_0_1.set_sampling_freq(self.samp_rate)
        self.analog_sig_source_x_2.set_sampling_freq(self.samp_rate)
        self.blocks_throttle_0_1_0_0.set_sample_rate(self.samp_rate)
        self.blocks_throttle_0_1_0_0_0.set_sample_rate(self.samp_rate)
        self.blocks_throttle_0_1_0_0_0_0.set_sample_rate(self.samp_rate)
        self.blocks_throttle_0_1_0_0_0_1.set_sample_rate(self.samp_rate)
        self.blocks_throttle_0_1_0_0_0_1_0.set_sample_rate(self.samp_rate)
        self.blocks_throttle_0_1_0_0_1.set_sample_rate(self.samp_rate)

    def get_pulse_length(self):
        return self.pulse_length

    def set_pulse_length(self, pulse_length):
        self.pulse_length = pulse_length
        self.analog_sig_source_x_1_0_0.set_phase(self.pulse2_phase_shift+math.pi*(1-self.pulse_length*(self.pulse_freq)))
        self.analog_sig_source_x_1_0_0_0.set_phase(math.pi*(1-self.pulse_length*(self.pulse_freq*0.625)))

    def get_pulse_freq(self):
        return self.pulse_freq

    def set_pulse_freq(self, pulse_freq):
        self.pulse_freq = pulse_freq
        self.analog_sig_source_x_0.set_frequency(self.pulse_freq)
        self.analog_sig_source_x_1_0.set_frequency(self.pulse_freq)
        self.analog_sig_source_x_1_0_0.set_frequency(self.pulse_freq)
        self.analog_sig_source_x_1_0_0.set_phase(self.pulse2_phase_shift+math.pi*(1-self.pulse_length*(self.pulse_freq)))
        self.analog_sig_source_x_1_0_0_0.set_frequency(self.pulse_freq)
        self.analog_sig_source_x_1_0_0_0.set_phase(math.pi*(1-self.pulse_length*(self.pulse_freq*0.625)))
        self.analog_sig_source_x_1_0_1.set_frequency(self.pulse_freq)
        self.analog_sig_source_x_2.set_frequency(self.pulse_freq)

    def get_pulse2_phase_shift(self):
        return self.pulse2_phase_shift

    def set_pulse2_phase_shift(self, pulse2_phase_shift):
        self.pulse2_phase_shift = pulse2_phase_shift
        self.analog_sig_source_x_1_0.set_phase(self.pulse2_phase_shift)
        self.analog_sig_source_x_1_0_0.set_phase(self.pulse2_phase_shift+math.pi*(1-self.pulse_length*(self.pulse_freq)))

    def get_output_samp_rate(self):
        return self.output_samp_rate

    def set_output_samp_rate(self, output_samp_rate):
        self.output_samp_rate = output_samp_rate
        self.blocks_head_0.set_length(self.output_samp_rate)
        self.blocks_throttle_0.set_sample_rate(self.output_samp_rate)
        self.blocks_throttle_0_0.set_sample_rate(self.output_samp_rate)

    def get_output_filename(self):
        return self.output_filename

    def set_output_filename(self, output_filename):
        self.output_filename = output_filename
        self.blocks_file_sink_0.open(self.output_filename)


def generate_signal_for_duty_cycle(duty_cycle, signal_time, suffix, noise_seed):
    out_path = "/tmp/pwm_side_channel_{}.bin".format(suffix)
    compressed_signal_time = (REALTIME_PWM_FREQUENCY / PWM_FREQUENCY_MAX * signal_time)
    tb = pwm_side_channel_sim(
        duty_cycle=duty_cycle,
        pwm_frequency=PWM_FREQUENCY_MAX,
        output_filename=out_path,
        noise_seed=noise_seed
    )

    tb.run()

    return out_path


def trim_signal_to_one_second(file_handle):
    """
    Get exactly one second (2048 * 50 samples) from an open generated signal file
    :param file_handle:
    :return:
    """
    PEAK_THRESHOLD = -60.0

    # find first peak of current signal, discard earlier data

    sample_bytes = file_handle.read(4)
    sample = struct.unpack("<f", sample_bytes)[0]

    while sample < PEAK_THRESHOLD:
        sample_bytes = file_handle.read(4)
        sample = struct.unpack("<f", sample_bytes)[0]

    yield sample_bytes

    for i in range(2048 * 50):
        # if this raises an error, so be it
        sample_bytes = file_handle.read(4)
        yield sample_bytes


def generate_composite_signal(duty_cycle_intervals, noise_seed):
    az_duty_cycles, el_duty_cycles = duty_cycle_intervals
    az_signal_files = [
        generate_signal_for_duty_cycle(dc, 1, f"{noise_seed}_az_{i}", noise_seed)
        for i, dc in enumerate(az_duty_cycles)
    ]

    el_signal_files = [
        generate_signal_for_duty_cycle(dc, 1, f"{noise_seed}_el_{i}", noise_seed*2)
        for i, dc in enumerate(el_duty_cycles)
    ]

    for az_signal_file, el_signal_file in zip(az_signal_files, el_signal_files):
        f_az = open(az_signal_file, 'rb')
        f_el = open(el_signal_file, 'rb')

        for az_sample, el_sample in zip(
                trim_signal_to_one_second(f_az),
                trim_signal_to_one_second(f_el)
        ):
            yield az_sample + el_sample

        f_az.close()
        f_el.close()


def make_observations(n_observations, challenge, tle_file, satellite_index, verbose=False):
    observations = []
    start = int(time.time())
    now = start

    observer = SatelliteObserver.from_strings(
        challenge.groundstation_location.longitude,
        challenge.groundstation_location.latitude,
        challenge.satellites[satellite_index].name,
        tle_file
    )

    antenna = AntennaController(motion_restrict=False, simulate=True)

    for i in range(1, n_observations + 1):
        difference = now - start
        current_time = challenge.observation_time + difference
        altitude, azimuth, distance = observer.altAzDist_at(current_time)
        visible = observer.above_horizon(current_time)
        if visible:
            antenna.set_azimuth(azimuth)
            antenna.set_elevation(altitude)
        else:
            antenna.set_azimuth(0)
            antenna.set_elevation(0)
        (az_duty, el_duty) = antenna.get_duty_cycles()
        if verbose:
            print("{}: {} at ({}, {}) from {} ({}) duty cycle: ({}, {})".format(
                datetime.datetime.utcfromtimestamp(current_time),
                observer.sat_name, azimuth, altitude, observer.where,
                "visible" if visible else "not visible",
                az_duty, el_duty), file=sys.stderr)

        def int_duty_to_percent(duty, servo):
            return round(
                ((float(duty) - servo._min_duty) / servo._duty_range) \
                * (MAX_DUTY_PERCENT - MIN_DUTY_PERCENT) + MIN_DUTY_PERCENT,
                4
            )

        obs = (
            current_time,
            int_duty_to_percent(az_duty, antenna.azimuth_servo),
            int_duty_to_percent(el_duty, antenna.elevation_servo),
        )
        observations.append(obs)
        now += WAIT_SEC

    return observations


def generate_duty_cycles_for_seed(seed, tle_file, groundstation_file):
    rcf = RandomChallengeFactory(tle_file, groundstation_file)
    challenge = rcf.create_random_challenge(seed)

    sat_duty_cycles = []

    for sat_idx in range(3):
        observations = make_observations(OBSERVATION_TIME, challenge, tle_file, sat_idx,
                                         verbose=False)

        az_duty_cycles = [obs[1] for obs in observations]
        el_duty_cycles = [obs[2] for obs in observations]

        sat_duty_cycles.append((az_duty_cycles, el_duty_cycles))

    return sat_duty_cycles


def generate_signals_for_seed(seed, tle_file, groundstation_file):

    sat_duty_cycles = generate_duty_cycles_for_seed(
        seed,
        tle_file,
        groundstation_file
    )

    for i, (az_duty_cycles, el_duty_cycles) in enumerate(sat_duty_cycles):
        print(f"azimuth: {az_duty_cycles[0]:02%} to {az_duty_cycles[-1]:02%}", file=sys.stderr)
        print(f"elevation: {el_duty_cycles[0]:02%} to {el_duty_cycles[-1]:02%}", file=sys.stderr)

        with open(f"/generator/signal_{i}.bin", 'wb+') as f:
            for cycle in generate_composite_signal((az_duty_cycles, el_duty_cycles), seed + i):
                f.write(cycle)


if __name__ == '__main__':
    generate_signals_for_seed(1337, '/generator/satellites.txt', '/generator/groundstations.csv')
