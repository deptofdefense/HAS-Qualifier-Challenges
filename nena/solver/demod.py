#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Demod
# Generated: Wed Apr 29 15:43:20 2020
##################################################


from gnuradio import analog
from gnuradio import blocks
from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import filter
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from optparse import OptionParser

import sys

class demod(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "Demod")

        ##################################################
        # Variables
        ##################################################
        self.sps = sps = 20
        self.nfilts = nfilts = 32
        self.samp_rate = samp_rate = 44100
        self.rrc_taps = rrc_taps = firdes.root_raised_cosine(nfilts, nfilts, 1.0/float(sps), 0.35, 11*sps*nfilts)
        self.qpsk = qpsk = digital.constellation_rect(([0.707+0.707j, -0.707+0.707j,  -0.707-0.707j, 0.707-0.707j]), ([0, 1, 3, 2]), 4, 2, 2, 1, 1).base()
        self.arity = arity = 4

        ##################################################
        # Blocks
        ##################################################
        self.low_pass_filter_0 = filter.fir_filter_ccf(1, firdes.low_pass(
        	1, samp_rate, 1.6e3, .6E3, firdes.WIN_HAMMING, 6.76))
        self.low_pass_filter_1 = filter.fir_filter_ccf(1, firdes.low_pass(
            1, samp_rate, 5000, 100, firdes.WIN_HAMMING, 6.76))
        self.digital_pfb_clock_sync_xxx_0 = digital.pfb_clock_sync_ccf(sps, 62.8e-3, (rrc_taps), nfilts, nfilts/2, 1.5, 2)
        self.digital_map_bb_0 = digital.map_bb(([0, 1, 3, 2]))
        self.digital_diff_decoder_bb_0 = digital.diff_decoder_bb(4)
        self.digital_costas_loop_cc_0 = digital.costas_loop_cc(62.8e-3, arity, False)
        self.digital_constellation_decoder_cb_0 = digital.constellation_decoder_cb(qpsk)
        self.digital_cma_equalizer_cc_0 = digital.cma_equalizer_cc(15, 1, 10e-3, 2)
        self.blocks_wavfile_source_0 = blocks.wavfile_source(sys.argv[1], False)
        self.blocks_unpack_k_bits_bb_0 = blocks.unpack_k_bits_bb(2)
        self.blocks_multiply_xx_0_0 = blocks.multiply_vcc(1)
        self.blocks_float_to_complex_0 = blocks.float_to_complex(1)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_char*1, sys.argv[2], False)
        self.blocks_file_sink_0.set_unbuffered(False)
        self.analog_sig_source_x_0_0 = analog.sig_source_c(samp_rate, analog.GR_COS_WAVE, -8e3, 1, 0)


        self.blocks_wavfile_sink_0 = blocks.wavfile_sink("/mnt/test.wav", 2, samp_rate, 16)
        self.blocks_complex_to_real_1 = blocks.complex_to_real(1)
        self.blocks_complex_to_imag_1 = blocks.complex_to_imag(1)
        ##################################################
        # Connections
        ##################################################
        # self.connect((self.analog_sig_source_x_0_0, 0), (self.blocks_multiply_xx_0_0, 1))
        self.connect((self.blocks_wavfile_source_0, 0), (self.blocks_float_to_complex_0, 0))
        self.connect((self.blocks_wavfile_source_0, 1), (self.blocks_float_to_complex_0, 1))
        self.connect((self.blocks_float_to_complex_0, 0), (self.low_pass_filter_1, 0))
        self.connect((self.low_pass_filter_1, 0), (self.low_pass_filter_0, 0))
        self.connect((self.low_pass_filter_0, 0), (self.digital_pfb_clock_sync_xxx_0, 0))
        self.connect((self.digital_pfb_clock_sync_xxx_0, 0), (self.digital_cma_equalizer_cc_0, 0))
        self.connect((self.digital_cma_equalizer_cc_0, 0), (self.digital_costas_loop_cc_0, 0))
        self.connect((self.digital_costas_loop_cc_0, 0), (self.digital_constellation_decoder_cb_0, 0))
        self.connect((self.digital_constellation_decoder_cb_0, 0), (self.digital_diff_decoder_bb_0, 0))
        self.connect((self.digital_diff_decoder_bb_0, 0), (self.digital_map_bb_0, 0))
        self.connect((self.digital_map_bb_0, 0), (self.blocks_unpack_k_bits_bb_0, 0))
        self.connect((self.blocks_unpack_k_bits_bb_0, 0), (self.blocks_file_sink_0, 0))

        #Test wav
        self.connect((self.low_pass_filter_1, 0), (self.blocks_complex_to_imag_1, 0))
        self.connect((self.low_pass_filter_1, 0), (self.blocks_complex_to_real_1, 0))
        self.connect((self.blocks_complex_to_imag_1, 0), (self.blocks_wavfile_sink_0, 1))
        self.connect((self.blocks_complex_to_real_1, 0), (self.blocks_wavfile_sink_0, 0))

    def get_sps(self):
        return self.sps

    def set_sps(self, sps):
        self.sps = sps
        self.set_rrc_taps(firdes.root_raised_cosine(self.nfilts, self.nfilts, 1.0/float(self.sps), 0.35, 11*self.sps*self.nfilts))

    def get_nfilts(self):
        return self.nfilts

    def set_nfilts(self, nfilts):
        self.nfilts = nfilts
        self.set_rrc_taps(firdes.root_raised_cosine(self.nfilts, self.nfilts, 1.0/float(self.sps), 0.35, 11*self.sps*self.nfilts))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, 1.6e3, .6E3, firdes.WIN_HAMMING, 6.76))
        self.analog_sig_source_x_0_0.set_sampling_freq(self.samp_rate)

    def get_rrc_taps(self):
        return self.rrc_taps

    def set_rrc_taps(self, rrc_taps):
        self.rrc_taps = rrc_taps
        self.digital_pfb_clock_sync_xxx_0.update_taps((self.rrc_taps))

    def get_qpsk(self):
        return self.qpsk

    def set_qpsk(self, qpsk):
        self.qpsk = qpsk

    def get_arity(self):
        return self.arity

    def set_arity(self, arity):
        self.arity = arity


def main(top_block_cls=demod, options=None):

    tb = top_block_cls()
    tb.start()
    tb.wait()


if __name__ == '__main__':
    main()
