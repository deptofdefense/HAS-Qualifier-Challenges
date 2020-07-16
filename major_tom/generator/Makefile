encode:
	python3 overlay.py >> generator.log
	python3 ccsds_encoder.py flag.jp2 encoded_flag >> generator.log

modulate:
	python2 mod.py encoded_flag challenge.wav >> generator.log

clean:
	generator.log challenge.wav recovered_data.txt encoded_flag

challenge: encode modulate
	mv challenge.wav /mnt >> generator.log
	echo "challenge.wav"
