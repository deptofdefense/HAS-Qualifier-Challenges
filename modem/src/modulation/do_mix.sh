#!/bin/bash

# Ensure variables are set, stop the script on the first error
set -u -e
: "$SOLUTION_NUMBER"
: "$PPP_CHALLENGE"
: "$PPP_PASSWORD"
: "$USERNAME_SUFFIX"

# So we have a known state for relative paths
cd `dirname "$0"`

# Generate the dial tones (DTMF). Prints a newline for some reason so redirect output
ruby dtmf.rb $SOLUTION_NUMBER /tmp/dial.wav > /dev/null

# Generate the bitstream for modulating both the "remote" and the "local" modems
python3 ppp/server_packets_to_bitstream.py ppp/scripts/server_tx_script.packets ppp/scripts/server_tx_script.timestamps /tmp/remote.bin 0 9000 5 6 $PPP_CHALLENGE > /dev/null
python3 ppp/client_packets_to_bitstream.py ppp/scripts/client_tx_script.packets ppp/scripts/client_tx_script.timestamps /tmp/local.bin 6 9000 7 8 $PPP_PASSWORD $PPP_CHALLENGE $USERNAME_SUFFIX > /dev/null

# Perform modulation, outputs to /tmp/data.wav (parameterized wav outputs are broken...)
python2.7 dual_fsk_modulation.py
# Generate noise, outputs to /tmp/noise.wav
python2.7 noise.py

# Join the audio files into /tmp/concat.wav
# wait.wav is mostly silence with a click (heard in my setup)
ffmpeg -y -i /tmp/dial.wav -i ./wait.wav -i /tmp/data.wav -filter_complex '[0:0][1:0][2:0]concat=n=3:v=0:a=1[out]' -map '[out]' /tmp/concat.wav
# Layer noise on top of /tmp/concat.wav to produce the final result in /tmp/recording.wav
ffmpeg -y -i /tmp/concat.wav -i /tmp/noise.wav -filter_complex amerge -ac 1 /tmp/recording.wav

# Echo result so that the uploader sees it
echo "/tmp/recording.wav"
