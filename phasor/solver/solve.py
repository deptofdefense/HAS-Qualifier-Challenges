#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Top Block
# Generated: Sat Feb  1 20:16:02 2020
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
from bitstring import BitArray
import sys
import os

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
        self.digital_pfb_clock_sync_xxx_0 = digital.pfb_clock_sync_ccf(4, .0628, (firdes.root_raised_cosine(32, 32, 1.0/float(1), 0.35, 45*32)), 32, 16, 1.5, 1)
        self.digital_constellation_decoder_cb_0 = digital.constellation_decoder_cb(bpsk1)
        self.blocks_wavfile_source_0 = blocks.wavfile_source(os.getenv("DIR", "/data") + os.sep + 'challenge.wav', False)
        self.blocks_float_to_complex_0 = blocks.float_to_complex(1)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_char*1, os.getenv("DIR", "/data") + os.sep + 'output.txt', False)
        self.blocks_file_sink_0.set_unbuffered(True)
   


        ##################################################
        # Connections
        ##################################################

        self.connect((self.blocks_wavfile_source_0, 0), (self.blocks_float_to_complex_0, 0))
        self.connect((self.blocks_float_to_complex_0, 0), (self.digital_pfb_clock_sync_xxx_0, 0))
        self.connect((self.digital_pfb_clock_sync_xxx_0, 0), (self.digital_constellation_decoder_cb_0, 0))
        self.connect((self.digital_constellation_decoder_cb_0, 0), (self.blocks_file_sink_0, 0))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_0_0.set_sample_rate(self.samp_rate)

    def get_bpsk1(self):
        return self.bpsk1

    def set_bpsk1(self, bpsk1):
        self.bpsk1 = bpsk1


def main(top_block_cls=top_block, options=None):



    tb = top_block_cls()
    tb.start()
    tb.wait()

    print("Looking for flag")

    stream = BitArray()
    with open(os.getenv("DIR", "/data") + os.sep + "output.txt", "rb") as f:
        byte = f.read(1)
        while byte:
            if byte == b'\x01':
                stream.append('0b1')
            else:
                stream.append('0b0')
            byte = f.read(1)

    # look for the start of the flag in the stream of bits
    pos = stream.find('0x666c6167')

    if len(pos) > 0:
        stream <<= pos[0]

        bitlen = len(stream)

        print(stream[0:bitlen/8*8].bytes)
    else:
        print("Did not find the flag")



if __name__ == '__main__':
    main()
