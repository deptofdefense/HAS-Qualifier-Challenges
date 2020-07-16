#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Fsk Modulation
# Generated: Wed Apr 29 13:29:54 2020
##################################################


from gnuradio import blocks
from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from optparse import OptionParser


class fsk_modulation(gr.top_block):

    def __init__(self, carrier_freq=1080, input_path='/media/psf/Home/test.bin'):
        gr.top_block.__init__(self, "Fsk Modulation")

        ##################################################
        # Parameters
        ##################################################
        self.carrier_freq = carrier_freq
        self.input_path = input_path

        ##################################################
        # Variables
        ##################################################
        self.oversample = oversample = 1
        self.samp_rate = samp_rate = 44100
        self.baud = baud = 300/oversample
        self.fsk_deviation_hz = fsk_deviation_hz = 100
        self.SPS = SPS = samp_rate/baud

        ##################################################
        # Blocks
        ##################################################
        self.digital_chunks_to_symbols_xx_0_0 = digital.chunks_to_symbols_bf(((2*3.14*carrier_freq-2*3.14*fsk_deviation_hz,2*3.14*carrier_freq+2*3.14*fsk_deviation_hz)), 1)
        self.blocks_wavfile_sink_0 = blocks.wavfile_sink('/media/psf/Home/test.wav', 1, samp_rate, 16)
        self.blocks_vco_f_0 = blocks.vco_f(samp_rate*oversample, 1, 1)
        self.blocks_repeat_0 = blocks.repeat(gr.sizeof_float*1, SPS)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_char*1, input_path, False)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_file_source_0, 0), (self.digital_chunks_to_symbols_xx_0_0, 0))
        self.connect((self.blocks_repeat_0, 0), (self.blocks_vco_f_0, 0))
        self.connect((self.blocks_vco_f_0, 0), (self.blocks_wavfile_sink_0, 0))
        self.connect((self.digital_chunks_to_symbols_xx_0_0, 0), (self.blocks_repeat_0, 0))

    def get_carrier_freq(self):
        return self.carrier_freq

    def set_carrier_freq(self, carrier_freq):
        self.carrier_freq = carrier_freq
        self.digital_chunks_to_symbols_xx_0_0.set_symbol_table(((2*3.14*self.carrier_freq-2*3.14*self.fsk_deviation_hz,2*3.14*self.carrier_freq+2*3.14*self.fsk_deviation_hz)))

    def get_input_path(self):
        return self.input_path

    def set_input_path(self, input_path):
        self.input_path = input_path
        self.blocks_file_source_0.open(self.input_path, False)

    def get_oversample(self):
        return self.oversample

    def set_oversample(self, oversample):
        self.oversample = oversample
        self.set_baud(300/self.oversample)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.set_SPS(self.samp_rate/self.baud)

    def get_baud(self):
        return self.baud

    def set_baud(self, baud):
        self.baud = baud
        self.set_SPS(self.samp_rate/self.baud)

    def get_fsk_deviation_hz(self):
        return self.fsk_deviation_hz

    def set_fsk_deviation_hz(self, fsk_deviation_hz):
        self.fsk_deviation_hz = fsk_deviation_hz
        self.digital_chunks_to_symbols_xx_0_0.set_symbol_table(((2*3.14*self.carrier_freq-2*3.14*self.fsk_deviation_hz,2*3.14*self.carrier_freq+2*3.14*self.fsk_deviation_hz)))

    def get_SPS(self):
        return self.SPS

    def set_SPS(self, SPS):
        self.SPS = SPS
        self.blocks_repeat_0.set_interpolation(self.SPS)


def argument_parser():
    parser = OptionParser(usage="%prog: [options]", option_class=eng_option)
    parser.add_option(
        "", "--carrier-freq", dest="carrier_freq", type="intx", default=1080,
        help="Set carrier_freq [default=%default]")
    parser.add_option(
        "", "--input-path", dest="input_path", type="string", default='/media/psf/Home/test.bin',
        help="Set input_path [default=%default]")
    return parser


def main(top_block_cls=fsk_modulation, options=None):
    if options is None:
        options, _ = argument_parser().parse_args()

    tb = top_block_cls(carrier_freq=options.carrier_freq, input_path=options.input_path)
    tb.start()
    tb.wait()


if __name__ == '__main__':
    main()
