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
        self.samp_rate = samp_rate = 32000
        self.bpsk1 = bpsk1 = digital.constellation_bpsk().base()


        ##################################################
        # Blocks
        ##################################################
        self.digital_constellation_modulator_0 = digital.generic_mod(
          constellation=bpsk1,
          differential=False,
          samples_per_symbol=4,
          pre_diff_code=False,
          excess_bw=0.35,
          verbose=False,
          log=False,
          )
        self.blocks_wavfile_sink_0 = blocks.wavfile_sink('/tmp/' + filename, 1, samp_rate, 16)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_char*1, '/tmp/input.txt', False)
        self.blocks_complex_to_float_0 = blocks.complex_to_float(1)


        ##################################################
        # Connections
        ##################################################

        self.connect((self.blocks_complex_to_float_0, 0), (self.blocks_wavfile_sink_0, 0))
        self.connect((self.blocks_file_source_0, 0), (self.digital_constellation_modulator_0, 0))
        self.connect((self.digital_constellation_modulator_0, 0), (self.blocks_complex_to_float_0, 0))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_0.set_sample_rate(self.samp_rate)

    def get_bpsk1(self):
        return self.bpsk1

    def set_bpsk1(self, bpsk1):
        self.bpsk1 = bpsk1


def main(top_block_cls=top_block, options=None):

    # ASM = 0x1acffc1d
    flag = os.getenv('FLAG', "flag{Placeholder}")

    with open('/tmp/input.txt', 'w') as f:

        for _ in range(0,20):
            f.write('THE FLAG IS: {}'.format(flag))

    with stdout_redirected(to=sys.stderr):
        tb = top_block_cls()
        tb.start()
        tb.wait()
        
    print("/tmp/" + filename)

if __name__ == '__main__':
    seed = os.getenv("SEED", "0")
    filename = "challenge.wav"
    main()
