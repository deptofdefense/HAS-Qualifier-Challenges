#!/usr/bin/env python2
# -*- coding: utf-8 -*-
##################################################
# GNU Radio Python Flow Graph
# Title: Fsk Demodulation
# Generated: Thu May 14 16:11:07 2020
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
import math
import numpy


class fsk_demodulation(gr.top_block):

    def __init__(self, carrier_freq=1080, input_path='/tmp/data.wav', output_path='/tmp/data.bin'):
        gr.top_block.__init__(self, "Fsk Demodulation")

        ##################################################
        # Parameters
        ##################################################
        self.carrier_freq = carrier_freq
        self.input_path = input_path
        self.output_path = output_path

        ##################################################
        # Variables
        ##################################################
        self.nfilts = nfilts = 32
        self.SPS = SPS = 147
        self.RX_decimation = RX_decimation = 49
        self.EBW = EBW = .05
        self.samp_rate = samp_rate = 44.1E3
        self.fsk_deviation_hz = fsk_deviation_hz = 100

        self.RRC_filter_taps = RRC_filter_taps = firdes.root_raised_cosine(nfilts, nfilts, 1.0, EBW, 5*SPS*nfilts/RX_decimation)


        ##################################################
        # Blocks
        ##################################################
        self.rational_resampler_xxx_1 = filter.rational_resampler_ccc(
                interpolation=1,
                decimation=RX_decimation,
                taps=None,
                fractional_bw=None,
        )
        self.digital_pfb_clock_sync_xxx_0 = digital.pfb_clock_sync_fff(SPS/RX_decimation, 6.28/400.0*2/70, (RRC_filter_taps), nfilts, nfilts/2, 2, 1)
        self.digital_binary_slicer_fb_0_0 = digital.binary_slicer_fb()
        self.blocks_wavfile_source_0 = blocks.wavfile_source(input_path, False)
        self.blocks_multiply_xx_1 = blocks.multiply_vcc(1)
        self.blocks_float_to_complex_0 = blocks.float_to_complex(1)
        self.blocks_file_sink_0 = blocks.file_sink(gr.sizeof_char*1, output_path, False)
        self.blocks_file_sink_0.set_unbuffered(False)
        self.analog_sig_source_x_1 = analog.sig_source_c(samp_rate, analog.GR_COS_WAVE, -carrier_freq, 1, 0)
        self.analog_quadrature_demod_cf_0 = analog.quadrature_demod_cf(samp_rate/(2*math.pi*fsk_deviation_hz/8.0)/(RX_decimation))
        self.analog_pwr_squelch_xx_0 = analog.pwr_squelch_cc(-60, .01, 0, True)
        self.analog_feedforward_agc_cc_0 = analog.feedforward_agc_cc(1024, 1.0)
        self.analog_const_source_x_0 = analog.sig_source_f(0, analog.GR_CONST_WAVE, 0, 0, 0)

        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_const_source_x_0, 0), (self.blocks_float_to_complex_0, 1))
        self.connect((self.analog_feedforward_agc_cc_0, 0), (self.analog_quadrature_demod_cf_0, 0))
        self.connect((self.analog_pwr_squelch_xx_0, 0), (self.analog_feedforward_agc_cc_0, 0))
        self.connect((self.analog_quadrature_demod_cf_0, 0), (self.digital_pfb_clock_sync_xxx_0, 0))
        self.connect((self.analog_sig_source_x_1, 0), (self.blocks_multiply_xx_1, 1))
        self.connect((self.blocks_float_to_complex_0, 0), (self.blocks_multiply_xx_1, 0))
        self.connect((self.blocks_multiply_xx_1, 0), (self.rational_resampler_xxx_1, 0))
        self.connect((self.blocks_wavfile_source_0, 0), (self.blocks_float_to_complex_0, 0))
        self.connect((self.digital_binary_slicer_fb_0_0, 0), (self.blocks_file_sink_0, 0))
        self.connect((self.digital_pfb_clock_sync_xxx_0, 0), (self.digital_binary_slicer_fb_0_0, 0))
        self.connect((self.rational_resampler_xxx_1, 0), (self.analog_pwr_squelch_xx_0, 0))

    def get_carrier_freq(self):
        return self.carrier_freq

    def set_carrier_freq(self, carrier_freq):
        self.carrier_freq = carrier_freq
        self.analog_sig_source_x_1.set_frequency(-self.carrier_freq)

    def get_input_path(self):
        return self.input_path

    def set_input_path(self, input_path):
        self.input_path = input_path

    def get_output_path(self):
        return self.output_path

    def set_output_path(self, output_path):
        self.output_path = output_path
        self.blocks_file_sink_0.open(self.output_path)

    def get_nfilts(self):
        return self.nfilts

    def set_nfilts(self, nfilts):
        self.nfilts = nfilts

    def get_SPS(self):
        return self.SPS

    def set_SPS(self, SPS):
        self.SPS = SPS

    def get_RX_decimation(self):
        return self.RX_decimation

    def set_RX_decimation(self, RX_decimation):
        self.RX_decimation = RX_decimation
        self.analog_quadrature_demod_cf_0.set_gain(self.samp_rate/(2*math.pi*self.fsk_deviation_hz/8.0)/(self.RX_decimation))

    def get_EBW(self):
        return self.EBW

    def set_EBW(self, EBW):
        self.EBW = EBW

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.analog_sig_source_x_1.set_sampling_freq(self.samp_rate)
        self.analog_quadrature_demod_cf_0.set_gain(self.samp_rate/(2*math.pi*self.fsk_deviation_hz/8.0)/(self.RX_decimation))

    def get_fsk_deviation_hz(self):
        return self.fsk_deviation_hz

    def set_fsk_deviation_hz(self, fsk_deviation_hz):
        self.fsk_deviation_hz = fsk_deviation_hz
        self.analog_quadrature_demod_cf_0.set_gain(self.samp_rate/(2*math.pi*self.fsk_deviation_hz/8.0)/(self.RX_decimation))

    def get_RRC_filter_taps(self):
        return self.RRC_filter_taps

    def set_RRC_filter_taps(self, RRC_filter_taps):
        self.RRC_filter_taps = RRC_filter_taps
        self.digital_pfb_clock_sync_xxx_0.update_taps((self.RRC_filter_taps))


def argument_parser():
    parser = OptionParser(usage="%prog: [options]", option_class=eng_option)
    parser.add_option(
        "", "--carrier-freq", dest="carrier_freq", type="intx", default=1080,
        help="Set carrier_freq [default=%default]")
    parser.add_option(
        "", "--input-path", dest="input_path", type="string", default='/tmp/data.wav',
        help="Set input_path [default=%default]")
    parser.add_option(
        "", "--output-path", dest="output_path", type="string", default='/tmp/data.bin',
        help="Set output_path [default=%default]")
    return parser


def main(top_block_cls=fsk_demodulation, options=None):
    if options is None:
        options, _ = argument_parser().parse_args()

    tb = top_block_cls(carrier_freq=options.carrier_freq, input_path=options.input_path, output_path=options.output_path)
    tb.start()
    tb.wait()


if __name__ == '__main__':
    main()
