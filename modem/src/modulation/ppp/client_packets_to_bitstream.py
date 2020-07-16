#!/usr/bin/env python3
import sys

from fcs16 import FCS16
from ntlm_auth.compute_response import ComputeResponse
from scapy.utils import hexdump

FILL_VALUE = '\x01'


def escape_packet_data(packet_data, escape_low_chars=False):
    escaped_data = bytearray()
    for byte in packet_data:
        if byte < 0x20 and escape_low_chars:
            escaped_data.append(0x7D)
            byte += 0x20
        elif byte in [0x7D, 0x7E]:
            escaped_data.append(0x7D)
            byte -= 0x20
        escaped_data.append(byte)
    return escaped_data


# python3 client_packets_to_bitstream.py scripts/client_tx_script.packets scripts/client_tx_script.timestamps /tmp/test.bin 180 13998 7 8 password 162d63479f2327ff
if __name__ == '__main__':
    # Oof.
    assert len(sys.argv) == 11, "require 10 arguments: " \
                                "packet_file timestamp_file out_file " \
                                "initial_sample end_sample " \
                                "accm_update_idx " \
                                "response_packet_idx password challenge username_suffix"

    result = ''

    packet_file = sys.argv[1]
    timestamp_file = sys.argv[2]
    out_file = sys.argv[3]
    initial_sample = int(sys.argv[4])
    end_sample = int(sys.argv[5])
    accm_update_idx = int(sys.argv[6])
    response_packet_idx = int(sys.argv[7])
    password = sys.argv[8]
    challenge = bytearray.fromhex(sys.argv[9])
    username_suffix = sys.argv[10]

    with open(timestamp_file, 'r') as fh:
        # Read timestamps into array of integers
        timestamps = [int(t) for t in fh.read().split('\n') if t]

    with open(packet_file, 'r') as fh:
        # Read packets into array of bytearrays
        packets = list()
        packet_hexdumps = fh.read().split('\n\n')
        for idx, packet_hexdump in enumerate(packet_hexdumps):
            print(f"Reading packet {idx}")
            hex_string = ''
            for line in packet_hexdump.split('\n'):
                if line:
                    hex_string += line.split('  ')[1].replace(' ', '')
            packet_data = bytearray.fromhex(hex_string)
            if idx == response_packet_idx:
                # Swap in hash
                resp, _ = ComputeResponse._get_NTLMv1_response(password, challenge)
                packet_data[0x1F:0x37] = resp
                packet_data += bytearray(username_suffix.encode('charmap'))
            packet_data += FCS16.calculate(packet_data)
            packet_data = escape_packet_data(packet_data, (idx <= accm_update_idx))
            packet_bytes = bytearray(b'\x7E') + packet_data + b'\x7E'
            hexdump(packet_bytes)
            print("")
            packets.append(packet_bytes)

    current_time = initial_sample
    for idx, timestamp in enumerate(timestamps):
        # Synthesize the gaps with FILL_BYTE, then the packet
        print(f"Synthesizing bitstream for packet {idx}: "
              f"current timestamp {current_time}, target timestamp {timestamp}")
        if current_time > timestamp - 8:    # Since we measure the timestamp at the end of the byte
            print(f"[WARN] Overrun in previous sample")
        else:
            while current_time < timestamp - 8:
                result += FILL_VALUE
                current_time += 1
        packet = packets[idx]
        for byte_idx, byte in enumerate(packet):
            bits = bin(byte)[2:].rjust(8, '0') + '0'  # Start bit
            if byte_idx != 0:
                bits += FILL_VALUE
            for bit in bits[::-1]:
                result += '\x00' if bit == '0' else '\x01'
                current_time += 1
        if current_time > end_sample:
            break

    # Trim to length
    result = result[:end_sample - initial_sample]

    with open(out_file, 'w') as fh:
        # Output results
        fh.write(result)
