#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Sat Feb  1 20:13:30 2020
##################################################

from distutils.version import StrictVersion


from gnuradio import blocks
from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from grc_gnuradio import blks2 as grc_blks2
from optparse import OptionParser
import sys
import os
from stdout_redirect import *

class top_block(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "Top Block")


        ##################################################
        # Variables
        ##################################################
        self.taps = taps = [1.0, 0.25-0.25j, 0.50 + 0.10j, -0.3 + 0.2j]
        self.sps = sps = 4
        self.samp_rate = samp_rate = 44100
        self.qpsk = qpsk = digital.constellation_rect(([0.707+0.707j, -0.707+0.707j,  -0.707-0.707j, 0.707-0.707j]), ([0, 1, 3, 2]), 4, 2, 2, 1, 1).base()
        self.excess_bw = excess_bw = 0.35

        ##################################################
        # Blocks
        ##################################################

        self.blocks_wavfile_sink = blocks.wavfile_sink('/tmp/challenge.wav', 2, samp_rate, 16)
        self.blocks_file_source = blocks.file_source(gr.sizeof_char*1, '/tmp/input.txt', False)
        self.blocks_complex_to_real_0 = blocks.complex_to_real(1)
        self.blocks_complex_to_imag_0 = blocks.complex_to_imag(1)

        self.digital_constellation_modulator_0 = digital.generic_mod(
          constellation=qpsk,
          differential=True,
          samples_per_symbol=sps,
          pre_diff_code=True,
          excess_bw=excess_bw,
          verbose=False,
          log=False,
          )

        ##################################################
        # Connections
        ##################################################

        self.connect((self.blocks_file_source, 0), (self.digital_constellation_modulator_0, 0))
        self.connect((self.digital_constellation_modulator_0, 0), (self.blocks_complex_to_imag_0, 0))
        self.connect((self.digital_constellation_modulator_0, 0), (self.blocks_complex_to_real_0, 0))
        self.connect((self.blocks_complex_to_real_0, 0), (self.blocks_wavfile_sink, 0))
        self.connect((self.blocks_complex_to_imag_0, 0), (self.blocks_wavfile_sink, 1))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_0.set_sample_rate(self.samp_rate)



def main(top_block_cls=top_block, options=None):

    #ASM = 0x1acffc1d
    # seed = os.getenv("SEED", "0")

    flag = os.getenv('FLAG', "flag{Placeholder}")

    with open('/tmp/input.txt', 'w') as f:

        for _ in range(0,16):
            f.write('{}'.format(flag))

    with stdout_redirected(to=sys.stderr):
        tb = top_block_cls()
        tb.start()
        tb.wait()

    print("/tmp/challenge.wav")


if __name__ == '__main__':

    main()
