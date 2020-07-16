#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Mod
# Generated: Wed Apr 29 15:43:17 2020
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

class mod(gr.top_block):

    def __init__(self, infile, infile_fake, outfile):
        gr.top_block.__init__(self, "Mod")

        ##################################################
        # Variables
        ##################################################
        self.taps = taps = [1.0, 0.25-0.25j, 0.50 + 0.10j, -0.3 + 0.2j]
        self.sps = sps = 20
        self.samp_rate = samp_rate = 44100
        self.qpsk = qpsk = digital.constellation_rect(([0.707+0.707j, -0.707+0.707j, -0.707-0.707j, 0.707-0.707j]), ([0, 1, 3, 2]), 4, 2, 2, 1, 1).base()
        self.num_repeats = num_repeats = 200
        self.fsk_deviation_hz = fsk_deviation_hz = 100
        self.fake_message = fake_message = "This is not the flag\x00\x00\x00\x00\x00"
        self.excess_bw = excess_bw = 0.35
        self.carrier_freq = carrier_freq = 1000

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

        # self.digital_psk_mod_0 = digital.psk.psk_mod(
        #   constellation_points=4,
        #   mod_code="gray",
        #   differential=True,
        #   samples_per_symbol=sps,
        #   excess_bw=0.35,
        #   verbose=False,
        #   log=False,
        #   )
        # self.digital_chunks_to_symbols_xx_0 = digital.chunks_to_symbols_bf(((2*3.14*carrier_freq-2*3.14*fsk_deviation_hz,2*3.14*carrier_freq+2*3.14*fsk_deviation_hz)), 1)
        self.channels_channel_model_0 = channels.channel_model(
        	noise_voltage=0.35,
        	frequency_offset=0,
        	epsilon=1,
        	taps=(taps),
        	noise_seed=0,
        	block_tags=False
        )
        self.blocks_wavfile_sink_0 = blocks.wavfile_sink(outfile, 2, samp_rate, 16)
        self.blocks_vco_f_0 = blocks.vco_f(samp_rate, 1, 1)
        self.blocks_repeat_0 = blocks.repeat(gr.sizeof_float*1, num_repeats)
        self.blocks_repack_bits_bb_0 = blocks.repack_bits_bb(8, 1, "", False, gr.GR_LSB_FIRST)
        self.blocks_multiply_xx_0 = blocks.multiply_vcc(1)
        self.blocks_float_to_complex_0 = blocks.float_to_complex(1)
        # self.blocks_file_source_1 = blocks.file_source(gr.sizeof_char*1, infile_fake, True)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_char*1, infile, False)
        self.blocks_complex_to_real_0 = blocks.complex_to_real(1)
        self.blocks_complex_to_imag_0 = blocks.complex_to_imag(1)
        self.blocks_add_xx_0 = blocks.add_vcc(1)
        self.analog_sig_source_x_0 = analog.sig_source_c(samp_rate, analog.GR_COS_WAVE, 8000, 1, 0)

        ##################################################
        # Connections
        ##################################################
        # self.connect((self.blocks_file_source_0, 0), (self.digital_psk_mod_0, 0))
        # self.connect((self.digital_psk_mod_0, 0),(self.channels_channel_model_0, 0))
        self.connect((self.blocks_file_source_0, 0), (self.digital_constellation_modulator_0, 0))
        self.connect((self.digital_constellation_modulator_0, 0),(self.channels_channel_model_0, 0))
            
        self.connect((self.channels_channel_model_0, 0), (self.blocks_add_xx_0, 0))

        self.connect((self.analog_sig_source_x_0, 0), (self.blocks_add_xx_0, 1))

        # self.connect((self.blocks_file_source_1, 0), (self.blocks_repack_bits_bb_0, 0))
        # self.connect((self.blocks_repack_bits_bb_0, 0), (self.digital_chunks_to_symbols_xx_0, 0))
        # self.connect((self.digital_chunks_to_symbols_xx_0, 0), (self.blocks_repeat_0, 0))
        # self.connect((self.blocks_repeat_0, 0), (self.blocks_vco_f_0, 0))
        # self.connect((self.blocks_vco_f_0, 0), (self.blocks_float_to_complex_0, 0))
        # self.connect((self.blocks_float_to_complex_0, 0), (self.blocks_multiply_xx_0, 0))
        # self.connect((self.blocks_multiply_xx_0, 0), (self.blocks_add_xx_0, 1))

        self.connect((self.blocks_add_xx_0, 0), (self.blocks_complex_to_imag_0, 0))
        self.connect((self.blocks_add_xx_0, 0), (self.blocks_complex_to_real_0, 0))
        # self.connect((self.channels_channel_model_0, 0), (self.blocks_complex_to_imag_0, 0))
        # self.connect((self.channels_channel_model_0, 0), (self.blocks_complex_to_real_0, 0))

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
        self.blocks_repeat_0.set_interpolation(self.num_repeats)

    def get_fsk_deviation_hz(self):
        return self.fsk_deviation_hz

    def set_fsk_deviation_hz(self, fsk_deviation_hz):
        self.fsk_deviation_hz = fsk_deviation_hz
        self.digital_chunks_to_symbols_xx_0.set_symbol_table(((2*3.14*self.carrier_freq-2*3.14*self.fsk_deviation_hz,2*3.14*self.carrier_freq+2*3.14*self.fsk_deviation_hz)))

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
        self.digital_chunks_to_symbols_xx_0.set_symbol_table(((2*3.14*self.carrier_freq-2*3.14*self.fsk_deviation_hz,2*3.14*self.carrier_freq+2*3.14*self.fsk_deviation_hz)))


def modulate(infile, infile_fake, outfile, top_block_cls=mod, options=None):

    tb = top_block_cls(infile, infile_fake, outfile)
    tb.start()
    tb.wait()


if __name__ == '__main__':
    modulate(sys.argv[1], sys.argv[2], sys.argv[3])
