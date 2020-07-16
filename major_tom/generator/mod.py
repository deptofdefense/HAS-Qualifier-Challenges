#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Mod
# Generated: Tue May 12 12:51:20 2020
##################################################


from gnuradio import analog
from gnuradio import blocks
from gnuradio import channels
from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from optparse import OptionParser

import sys
import random
import os

class mod(gr.top_block):

    def __init__(self, infile, outfile):
        gr.top_block.__init__(self, "Mod")

        bitmappings = [ 
            [ 0, 1, 2, 3],
            # [ 0, 1, 3, 2],
            [ 0, 2, 1, 3],
            # [ 0, 2, 3, 1],
            # [ 0, 3, 1, 2],
            [ 0, 3, 2, 1],
            [ 1, 0, 2, 3],
            [ 1, 0, 3, 2],
            # [ 1, 2, 0, 3],
            # [ 1, 2, 3, 0],
            # [ 1, 3, 0, 2],
            # [ 1, 3, 2, 0],
            # [ 2, 0, 1, 3],
            # [ 2, 0, 3, 1],
            [ 2, 1, 0, 3],
            # [ 2, 1, 3, 0],
            [ 2, 3, 0, 1],
            # [ 2, 3, 1, 0],
            # [ 3, 0, 1, 2],
            # [ 3, 0, 2, 1],
            # [ 3, 1, 0, 2], 
            [ 3, 1, 2, 0],
            # [ 3, 2, 0, 1],
            [ 3, 2, 1, 0],
        ]

        constellation_map = random.choice(bitmappings)

        # overwride the above for now until the dynamic solver works
        # constellation_map = [ 2, 3, 0, 1]

        # sys.stderr.write('{}'.format(constellation_map))
        ##################################################
        # Variables
        ##################################################
        self.taps = taps = [1.0, 0.25-0.25j, 0.50 + 0.10j, -0.3 + 0.2j]
        self.sps = sps = 8
        self.samp_rate = samp_rate = 32000
        self.qpsk = qpsk = digital.constellation_rect(([0.707+0.707j, -0.707+0.707j,  -0.707-0.707j, 0.707-0.707j]), (constellation_map), 4, 2, 2, 1, 1).base()
        self.fsk_deviation_hz = fsk_deviation_hz = 100
        self.excess_bw = excess_bw = 0.35

        ##################################################
        # Blocks
        ##################################################
  
        self.digital_constellation_modulator_0 = digital.generic_mod(
          constellation=qpsk,
          differential=True,
          samples_per_symbol=sps,
          pre_diff_code=True,
          excess_bw=excess_bw,
          verbose=False,
          log=False,
          )
        self.blocks_wavfile_sink_0 = blocks.wavfile_sink(outfile, 2, samp_rate, 16)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_char*1, infile, False)
        self.blocks_complex_to_real_0 = blocks.complex_to_real(1)
        self.blocks_complex_to_imag_0 = blocks.complex_to_imag(1)

        ##################################################
        # Connections
        ##################################################
        # self.connect((self.blocks_file_source_0, 0), (self.digital_psk_mod_0, 0))
        self.connect((self.blocks_file_source_0, 0), (self.digital_constellation_modulator_0, 0))
        # self.connect((self.digital_psk_mod_0, 0), (self.blocks_complex_to_imag_0, 0))
        # self.connect((self.digital_psk_mod_0, 0), (self.blocks_complex_to_real_0, 0))
        self.connect((self.digital_constellation_modulator_0, 0), (self.blocks_complex_to_imag_0, 0))
        self.connect((self.digital_constellation_modulator_0, 0), (self.blocks_complex_to_real_0, 0))
        self.connect((self.blocks_complex_to_imag_0, 0), (self.blocks_wavfile_sink_0, 1))
        self.connect((self.blocks_complex_to_real_0, 0), (self.blocks_wavfile_sink_0, 0))


    def get_taps(self):
        return self.taps

    def set_taps(self, taps):
        self.taps = taps
        self.channels_channel_model_0.set_taps((self.taps))

    def get_sps(self):
        return self.sps

    def set_sps(self, sps):
        self.sps = sps

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)

    def get_qpsk(self):
        return self.qpsk

    def set_qpsk(self, qpsk):
        self.qpsk = qpsk

    def get_num_repeats(self):
        return self.num_repeats

    def set_num_repeats(self, num_repeats):
        self.num_repeats = num_repeats

    def get_fsk_deviation_hz(self):
        return self.fsk_deviation_hz

    def set_fsk_deviation_hz(self, fsk_deviation_hz):
        self.fsk_deviation_hz = fsk_deviation_hz

    def get_fake_message(self):
        return self.fake_message

    def set_fake_message(self, fake_message):
        self.fake_message = fake_message

    def get_excess_bw(self):
        return self.excess_bw

    def set_excess_bw(self, excess_bw):
        self.excess_bw = excess_bw

    def get_carrier_freq(self):
        return self.carrier_freq

    def set_carrier_freq(self, carrier_freq):
        self.carrier_freq = carrier_freq


def modulate(infile, outfile, top_block_cls=mod, options=None):

    tb = top_block_cls(infile, outfile)
    tb.start()
    tb.wait()


if __name__ == '__main__':

    seed = os.getenv("SEED", "0")
    random.seed(seed)
    modulate(sys.argv[1], sys.argv[2])
