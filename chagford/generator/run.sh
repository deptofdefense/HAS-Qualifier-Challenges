#!/bin/bash

python makeHash.py

sleep 2
tcpdump -i lo -l port 8008 -w /tmp/capture.pcap & 
tcp_pid=$!
sleep 5
export SERVICE_HOST=127.0.0.1
export SERVICE_PORT=8008
./challenge > /dev/null & 
sleep 2
./autoClient 127.0.0.1 8008  
kill  $tcp_pid
sleep 5
echo "/tmp/capture.pcap"
echo "/generator/challenge"
