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
        self.sps = sps = 4
        self.nfilts = nfilts = 32
        self.samp_rate = samp_rate = 44100
        self.rrc_taps = rrc_taps = firdes.root_raised_cosine(nfilts, nfilts, 1.0/float(sps), 0.35, 11*sps*nfilts)
        self.qpsk = qpsk = digital.constellation_rect(([0.707+0.707j, -0.707+0.707j,  -0.707-0.707j, 0.707-0.707j]), ([0, 1, 3, 2]), 4, 2, 2, 1, 1).base()
        self.arity = arity = 4

        ##################################################
        # Blocks
        ##################################################


        self.digital_pfb_clock_sync_xxx_0 = digital.pfb_clock_sync_ccf(sps, 62.8e-3, (rrc_taps), nfilts, nfilts/2, 1.5, 2)
        self.digital_map_bb_0 = digital.map_bb(([0, 1, 3, 2]))
        self.digital_diff_decoder_bb_0 = digital.diff_decoder_bb(4)
        self.digital_costas_loop_cc_0 = digital.costas_loop_cc(62.8e-3, arity, False)
        self.digital_constellation_decoder_cb_0 = digital.constellation_decoder_cb(qpsk)
        self.digital_cma_equalizer_cc_0 = digital.cma_equalizer_cc(15, 1, 10e-3, 2)
        self.blocks_wavfile_source_0 = blocks.wavfile_source(os.getenv("DIR", "/data") + os.sep + 'challenge.wav', False)
        self.blocks_unpack_k_bits_bb_0 = blocks.unpack_k_bits_bb(2)
        self.blocks_multiply_xx_0_0 = blocks.multiply_vcc(1)
        self.blocks_float_to_complex_0 = blocks.float_to_complex(1)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_char*1, os.getenv("DIR", "/data") + os.sep + 'output.txt', False)
        self.blocks_file_sink_0.set_unbuffered(False)


        ##################################################
        # Connections
        ##################################################

        self.connect((self.blocks_wavfile_source_0, 0), (self.blocks_float_to_complex_0, 0))
        self.connect((self.blocks_wavfile_source_0, 1), (self.blocks_float_to_complex_0, 1))
        self.connect((self.blocks_float_to_complex_0, 0), (self.digital_pfb_clock_sync_xxx_0, 0))
        self.connect((self.digital_pfb_clock_sync_xxx_0, 0), (self.digital_cma_equalizer_cc_0, 0))
        self.connect((self.digital_cma_equalizer_cc_0, 0), (self.digital_costas_loop_cc_0, 0))
        self.connect((self.digital_costas_loop_cc_0, 0), (self.digital_constellation_decoder_cb_0, 0))
        self.connect((self.digital_constellation_decoder_cb_0, 0), (self.digital_diff_decoder_bb_0, 0))
        self.connect((self.digital_diff_decoder_bb_0, 0), (self.digital_map_bb_0, 0))
        self.connect((self.digital_map_bb_0, 0), (self.blocks_unpack_k_bits_bb_0, 0))
        self.connect((self.blocks_unpack_k_bits_bb_0, 0), (self.blocks_file_sink_0, 0))


    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.blocks_throttle_0_0.set_sample_rate(self.samp_rate)



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
