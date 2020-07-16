#!/bin/bash
python3 -m vax_challenge.run_setup
genisoimage -l -V SERVER -o /vax/server/server.iso /tmp/challenge_files/
mkdir /tmp/client_challenge_files
cp /tmp/challenge_files/* /tmp/client_challenge_files
rm /tmp/client_challenge_files/*.txt
cp /assets/client/* /tmp/client_challenge_files/
genisoimage -l -V CLIENT -o /vax/client/client.iso /tmp/client_challenge_files/
unset FLAG
unset SEED
/run_server.sh &> /dev/null &
python3 -m vax_challenge.run_client
