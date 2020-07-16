demodulate:
	python2 demod.py /mnt/challenge.wav encoded_flag_bitstream

decode:
	python2 convert.py encoded_flag_bitstream encoded_flag
	python ccsds_decoder.py encoded_flag /mnt/flag

clean:
	rm encoded_flag_bitstream encoded_flag /mnt/flag

flag: demodulate decode
