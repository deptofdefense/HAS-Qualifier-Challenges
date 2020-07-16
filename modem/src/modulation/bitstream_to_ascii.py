#!/usr/bin/env python3

import sys

assert len(sys.argv) > 1, "filename required"

BASELINE_THRESHOLD = 20
if len(sys.argv) == 3:
    BASELINE_THRESHOLD = int(sys.argv[2])

with open(sys.argv[1], 'r') as fh:
    data = fh.read()

baseline_count = 0
datagram_started = False
pdus = []
current_pdu = ''
for i in data:
    if i == '\x00':
        if baseline_count >= BASELINE_THRESHOLD:
            datagram_started = True
            current_pdu += i
            if len(current_pdu) == 9:
                pdus.append(current_pdu)
                current_pdu = ''
                datagram_started = False
    elif i == '\x01':
        if baseline_count < BASELINE_THRESHOLD:
            baseline_count += 1
        elif datagram_started:
            current_pdu += i
            if len(current_pdu) == 9:
                pdus.append(current_pdu)
                current_pdu = ''
                datagram_started = False

cleaned_pdus = []
for pdu in pdus:
    cleaned_pdus.append(pdu[1:][::-1])

data = []
for pdu in cleaned_pdus:
    bin_string = ''.join(['0' if bit == '\x00' else '1' for bit in pdu])
    data.append(int(bin_string, 2))

if data[0] == 0xff:
    data = data[1:]

for datum in data:
    # print(hex(datum)[2:] + "\t" + chr(datum))
    print(chr(datum), end="")
