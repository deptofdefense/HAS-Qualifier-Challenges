#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Noise
# Generated: Wed Apr 29 18:18:49 2020
##################################################


from gnuradio import analog
from gnuradio import blocks
from gnuradio import eng_notation
from gnuradio import filter
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from optparse import OptionParser


class noise(gr.top_block):

    def __init__(self, seconds=40):
        gr.top_block.__init__(self, "Noise")

        ##################################################
        # Parameters
        ##################################################
        self.seconds = seconds

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 44100

        ##################################################
        # Blocks
        ##################################################
        self.low_pass_filter_0 = filter.fir_filter_fff(1, firdes.low_pass(
        	1, samp_rate, 300, 500, firdes.WIN_HAMMING, 6.76))
        self.blocks_wavfile_sink_0 = blocks.wavfile_sink('/tmp/noise.wav', 1, samp_rate, 16)
        self.blocks_head_0 = blocks.head(gr.sizeof_float*1, int(samp_rate * seconds))
        self.blocks_add_xx_0 = blocks.add_vff(1)
        self.analog_sig_source_x_0 = analog.sig_source_f(samp_rate, analog.GR_COS_WAVE, 60, 0.1, 0.2)
        self.analog_noise_source_x_0_0 = analog.noise_source_f(analog.GR_UNIFORM, 0.05, 1)
        self.analog_noise_source_x_0 = analog.noise_source_f(analog.GR_UNIFORM, 0.01, 0)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_noise_source_x_0, 0), (self.blocks_add_xx_0, 1))
        self.connect((self.analog_noise_source_x_0_0, 0), (self.low_pass_filter_0, 0))
        self.connect((self.analog_sig_source_x_0, 0), (self.blocks_add_xx_0, 2))
        self.connect((self.blocks_add_xx_0, 0), (self.blocks_head_0, 0))
        self.connect((self.blocks_head_0, 0), (self.blocks_wavfile_sink_0, 0))
        self.connect((self.low_pass_filter_0, 0), (self.blocks_add_xx_0, 0))

    def get_seconds(self):
        return self.seconds

    def set_seconds(self, seconds):
        self.seconds = seconds
        self.blocks_head_0.set_length(int(self.samp_rate * self.seconds))

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.low_pass_filter_0.set_taps(firdes.low_pass(1, self.samp_rate, 300, 500, firdes.WIN_HAMMING, 6.76))
        self.blocks_head_0.set_length(int(self.samp_rate * self.seconds))
        self.analog_sig_source_x_0.set_sampling_freq(self.samp_rate)


def argument_parser():
    parser = OptionParser(usage="%prog: [options]", option_class=eng_option)
    parser.add_option(
        "", "--seconds", dest="seconds", type="eng_float", default=eng_notation.num_to_str(40),
        help="Set seconds [default=%default]")
    return parser


def main(top_block_cls=noise, options=None):
    if options is None:
        options, _ = argument_parser().parse_args()

    tb = top_block_cls(seconds=options.seconds)
    tb.start()
    tb.wait()


if __name__ == '__main__':
    main()
