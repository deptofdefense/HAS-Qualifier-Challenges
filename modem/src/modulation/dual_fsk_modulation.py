#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Dual Fsk Modulation
# Generated: Thu May 14 16:11:19 2020
##################################################


from gnuradio import blocks
from gnuradio import digital
from gnuradio import eng_notation
from gnuradio import gr
from gnuradio.eng_option import eng_option
from gnuradio.filter import firdes
from optparse import OptionParser


class dual_fsk_modulation(gr.top_block):

    def __init__(self, carrier_freq_hi=1750, carrier_freq_lo=1080, input_path_hi='/tmp/remote.bin', input_path_lo='/tmp/local.bin', lo_delay=180):
        gr.top_block.__init__(self, "Dual Fsk Modulation")

        ##################################################
        # Parameters
        ##################################################
        self.carrier_freq_hi = carrier_freq_hi
        self.carrier_freq_lo = carrier_freq_lo
        self.input_path_hi = input_path_hi
        self.input_path_lo = input_path_lo
        self.lo_delay = lo_delay

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
        self.digital_chunks_to_symbols_xx_0_0_0 = digital.chunks_to_symbols_bf(((2*3.14*carrier_freq_lo-2*3.14*fsk_deviation_hz,2*3.14*carrier_freq_lo+2*3.14*fsk_deviation_hz)), 1)
        self.digital_chunks_to_symbols_xx_0_0 = digital.chunks_to_symbols_bf(((2*3.14*carrier_freq_hi-2*3.14*fsk_deviation_hz,2*3.14*carrier_freq_hi+2*3.14*fsk_deviation_hz)), 1)
        self.blocks_wavfile_sink_0 = blocks.wavfile_sink('/tmp/data.wav', 1, samp_rate, 16)
        self.blocks_vco_f_0_0 = blocks.vco_f(samp_rate*oversample, 1, 0.25)
        self.blocks_vco_f_0 = blocks.vco_f(samp_rate*oversample, 1, 0.25)
        self.blocks_repeat_0_0 = blocks.repeat(gr.sizeof_float*1, SPS)
        self.blocks_repeat_0 = blocks.repeat(gr.sizeof_float*1, SPS)
        self.blocks_file_source_0_0 = blocks.file_source(gr.sizeof_char*1, input_path_lo, False)
        self.blocks_file_source_0 = blocks.file_source(gr.sizeof_char*1, input_path_hi, False)
        self.blocks_delay_0 = blocks.delay(gr.sizeof_float*1, lo_delay * SPS)
        self.blocks_add_xx_0 = blocks.add_vff(1)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.blocks_add_xx_0, 0), (self.blocks_wavfile_sink_0, 0))
        self.connect((self.blocks_delay_0, 0), (self.blocks_add_xx_0, 1))
        self.connect((self.blocks_file_source_0, 0), (self.digital_chunks_to_symbols_xx_0_0, 0))
        self.connect((self.blocks_file_source_0_0, 0), (self.digital_chunks_to_symbols_xx_0_0_0, 0))
        self.connect((self.blocks_repeat_0, 0), (self.blocks_vco_f_0, 0))
        self.connect((self.blocks_repeat_0_0, 0), (self.blocks_vco_f_0_0, 0))
        self.connect((self.blocks_vco_f_0, 0), (self.blocks_add_xx_0, 0))
        self.connect((self.blocks_vco_f_0_0, 0), (self.blocks_delay_0, 0))
        self.connect((self.digital_chunks_to_symbols_xx_0_0, 0), (self.blocks_repeat_0, 0))
        self.connect((self.digital_chunks_to_symbols_xx_0_0_0, 0), (self.blocks_repeat_0_0, 0))

    def get_carrier_freq_hi(self):
        return self.carrier_freq_hi

    def set_carrier_freq_hi(self, carrier_freq_hi):
        self.carrier_freq_hi = carrier_freq_hi
        self.digital_chunks_to_symbols_xx_0_0.set_symbol_table(((2*3.14*self.carrier_freq_hi-2*3.14*self.fsk_deviation_hz,2*3.14*self.carrier_freq_hi+2*3.14*self.fsk_deviation_hz)))

    def get_carrier_freq_lo(self):
        return self.carrier_freq_lo

    def set_carrier_freq_lo(self, carrier_freq_lo):
        self.carrier_freq_lo = carrier_freq_lo
        self.digital_chunks_to_symbols_xx_0_0_0.set_symbol_table(((2*3.14*self.carrier_freq_lo-2*3.14*self.fsk_deviation_hz,2*3.14*self.carrier_freq_lo+2*3.14*self.fsk_deviation_hz)))

    def get_input_path_hi(self):
        return self.input_path_hi

    def set_input_path_hi(self, input_path_hi):
        self.input_path_hi = input_path_hi
        self.blocks_file_source_0.open(self.input_path_hi, False)

    def get_input_path_lo(self):
        return self.input_path_lo

    def set_input_path_lo(self, input_path_lo):
        self.input_path_lo = input_path_lo
        self.blocks_file_source_0_0.open(self.input_path_lo, False)

    def get_lo_delay(self):
        return self.lo_delay

    def set_lo_delay(self, lo_delay):
        self.lo_delay = lo_delay
        self.blocks_delay_0.set_dly(self.lo_delay * self.SPS)

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
        self.digital_chunks_to_symbols_xx_0_0_0.set_symbol_table(((2*3.14*self.carrier_freq_lo-2*3.14*self.fsk_deviation_hz,2*3.14*self.carrier_freq_lo+2*3.14*self.fsk_deviation_hz)))
        self.digital_chunks_to_symbols_xx_0_0.set_symbol_table(((2*3.14*self.carrier_freq_hi-2*3.14*self.fsk_deviation_hz,2*3.14*self.carrier_freq_hi+2*3.14*self.fsk_deviation_hz)))

    def get_SPS(self):
        return self.SPS

    def set_SPS(self, SPS):
        self.SPS = SPS
        self.blocks_repeat_0_0.set_interpolation(self.SPS)
        self.blocks_repeat_0.set_interpolation(self.SPS)
        self.blocks_delay_0.set_dly(self.lo_delay * self.SPS)


def argument_parser():
    parser = OptionParser(usage="%prog: [options]", option_class=eng_option)
    parser.add_option(
        "", "--carrier-freq-hi", dest="carrier_freq_hi", type="intx", default=1750,
        help="Set carrier_freq_hi [default=%default]")
    parser.add_option(
        "", "--carrier-freq-lo", dest="carrier_freq_lo", type="intx", default=1080,
        help="Set carrier_freq_lo [default=%default]")
    parser.add_option(
        "", "--input-path-hi", dest="input_path_hi", type="string", default='/tmp/remote.bin',
        help="Set input_path_hi [default=%default]")
    parser.add_option(
        "", "--input-path-lo", dest="input_path_lo", type="string", default='/tmp/local.bin',
        help="Set input_path_lo [default=%default]")
    parser.add_option(
        "", "--lo-delay", dest="lo_delay", type="intx", default=180,
        help="Set lo_delay [default=%default]")
    return parser


def main(top_block_cls=dual_fsk_modulation, options=None):
    if options is None:
        options, _ = argument_parser().parse_args()

    tb = top_block_cls(carrier_freq_hi=options.carrier_freq_hi, carrier_freq_lo=options.carrier_freq_lo, input_path_hi=options.input_path_hi, input_path_lo=options.input_path_lo, lo_delay=options.lo_delay)
    tb.start()
    tb.wait()


if __name__ == '__main__':
    main()
