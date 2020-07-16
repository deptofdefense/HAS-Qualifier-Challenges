#!/usr/bin/env bash

# Ensure variables are set, stop the script on the first error
set -u -e
: "$RECORDING_WAV_FILE"

# So we have a known state for relative paths
cd `dirname "$0"`

# Add a noise gate (cutoff@-15db) to make it easier for our dtmf decoder
ffmpeg -y -ss 0 -to 1.5 -i "$RECORDING_WAV_FILE" -af "compand=attacks=0:decays=0.002:points=-80/-115|-15.1/-114|-15/-15|20/20" /tmp/dial.wav
ffmpeg -y -ss 6 -i "$RECORDING_WAV_FILE" /tmp/data.wav

# Print numbers
python2.7 dtmf_decoder.py /tmp/dial.wav

python2.7 fsk_demodulation.py --carrier-freq 1750
mv /tmp/data.bin /tmp/remote.bin
python2.7 fsk_demodulation.py
mv /tmp/data.bin /tmp/client.bin

python3 ppp/bitstream_to_packets.py /tmp/remote.bin /tmp/remote_packets 'PPP / CHAP challenge=' > /dev/null
grep -oP "challenge=[^ ]+" /tmp/remote_packets.match | cut -d'x' -f2
python3 ppp/bitstream_to_packets.py /tmp/client.bin /tmp/client_packets 'PPP / CHAP response=' > /dev/null
grep -oP "response=[^ ]+" /tmp/client_packets.match | cut -d'x' -f2
grep -oP "optional_name='[^']+" /tmp/client_packets.match | cut -d"'" -f2
