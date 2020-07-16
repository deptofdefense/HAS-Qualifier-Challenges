#!/usr/bin/env ruby
require 'wavefile'
require 'optparse'

SAMPLE_RATE = 44100
TONE_LENGTH = SAMPLE_RATE / 13
TWO_PI = 2 * Math::PI

# Adds two sine waves together to make a DTMF tone
def generate_tone(freq1, freq2, amplitude)
	wav1 = generate_sine_wave(TONE_LENGTH, freq1, amplitude)
	wav2 = generate_sine_wave(TONE_LENGTH, freq2, amplitude)
	wav = []
	for i in (0 .. (wav1.size - 1))
		wav.push(wav1[i] + wav2[i])
	end
	return wav
end

# Makes an audio sine wave of specific length, frequency, and amplitude
def generate_sine_wave(num_samples, frequency, max_amplitude)
	position_in_period = 0.0
	position_in_period_delta = frequency / SAMPLE_RATE
	samples = []

	num_samples.times do
		# Get the correct value from the sin curve, then move up
		samples.push(Math::sin(position_in_period * TWO_PI) * max_amplitude)
		position_in_period += position_in_period_delta
		
		# Constrain the period between 0.0 and 1.0.
		# That is, keep looping and re-looping over the same period.
		if(position_in_period >= 1.0)
			position_in_period -= 1.0
		end
	end
	return samples
end

# Calculates all the tones we need for different digits
def generateDigits(volume)
	digits = []
	digits.push(generate_tone(941.0, 1336.0, volume)) # 0
	digits.push(generate_tone(697.0, 1209.0, volume)) # 1
	digits.push(generate_tone(697.0, 1336.0, volume)) # 2
	digits.push(generate_tone(697.0, 1477.0, volume)) # 3
	digits.push(generate_tone(770.0, 1209.0, volume)) # 4
	digits.push(generate_tone(770.0, 1336.0, volume)) # 5
	digits.push(generate_tone(770.0, 1477.0, volume)) # 6
	digits.push(generate_tone(852.0, 1209.0, volume)) # 7
	digits.push(generate_tone(852.0, 1336.0, volume)) # 8
	digits.push(generate_tone(852.0, 1477.0, volume)) # 9
	return digits
end


if __FILE__ == $0
	pauseLength = nil
	volume = nil

	usage = "#{$0} [options] <digits> <outputfile>\n"
	usage += "\t-p, --pause PAUSE             Sets delay between each tone (in seconds)\n"
	usage += "\t-v, --volume VOLUME           Sets volume between 0 (silent) and 1 (max)\n"
	usage += "\t-h, --help                    Displays this usage message\n"
	usage += "\t<digits>                      Specifies digit tones to emulate\n"
	usage += "\t<outputfile>                  Specifies name of output wave file\n"

	OptionParser.new do |o|
		o.on('-p [PAUSE]', "--pause [PAUSE]") {|b| pauseLength = b}
		o.on('-h', "--help") {puts usage; exit}
		o.on('-v [VOLUME]', "--volume [VOLUME]") do |b|
			volume = b.to_f
			if(volume == 0.0 or volume > 1.0)
				puts "Volume must be above 0 and below 1!"
			end
		end
		o.parse!
	end

	# If user didn't set a volume then we default to one third max.
	if( volume == nil )
		volume = 0.3
	end

	# Alright, calculate how long each pause should be to get the desired delay.
	# We default to half a second.
	if( pauseLength == nil )
		pauseLength = 0.06
	end
	pauseLength = (SAMPLE_RATE * pauseLength.to_f).round

	if( ARGV.size != 2 )
		puts usage
		exit
	end

	file = ARGV.pop
	sequence = ARGV.pop.split(//).map {|d| d.to_i}

	# print "Recording tone "
	format = WaveFile::Format.new(:mono, :float, SAMPLE_RATE)
	pcm_format = WaveFile::Format.new(:mono, :pcm_16, SAMPLE_RATE)
	silence = WaveFile::Buffer.new(([0] * pauseLength), format)
	digits = generateDigits(volume)
	WaveFile::Writer.new(file, pcm_format) do |writer|
		for digit in sequence
			if( digit < 0 or digit > 9 )
				next
			end
			# print "#{digit} "
			buffer = WaveFile::Buffer.new(digits[digit], format)
			writer.write(buffer)
			writer.write(silence)
		end
	end
	puts ""
end
