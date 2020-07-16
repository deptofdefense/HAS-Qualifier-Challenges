#!/usr/bin/env python3
import os
import sys
from scapy.utils import hexdump
from scapy.layers.ppp import PPP

from fcs16 import FCS16


class Packetizer(object):
    SKIP_SET_BITS = 20
    START_BYTE = 0x7E
    END_BYTE = 0x7E

    def __init__(self):
        self.packets = list()
        self.escaped_packets = list()
        self.packet_start_indices = list()

    def from_file(self, path):
        with open(path, 'r') as fh:
            self.from_data(fh.read())

    @staticmethod
    def bit_string_to_byte(bit_string):
        ordered_string = bit_string[1:][::-1]
        bin_string = ''.join(['0' if bit == '\x00' else '1' for bit in ordered_string])
        return int(bin_string, 2)

    def escape_packets(self):
        # Messy...
        self.escaped_packets = list()
        bad_packet_indices_indices = list()
        for idx, packet in enumerate(self.packets):
            print(f"\n= UNESCAPE PACKET {idx} ====================================")
            hexdump(packet)
            unescaped_packet = bytearray()
            escaped = False
            drop_packet = False
            for byte_idx, byte in enumerate(packet[:-1]):
                if escaped:
                    if byte == 0x5E:
                        byte = 0x7E
                    elif byte == 0x5D:
                        byte = 0x7D
                    elif 0x40 > byte >= 0x20:
                        byte = byte - 0x20
                    else:
                        print(f"[ERROR] Incorrect byte escape value ({hex(byte)}) on byte {hex(byte_idx)} in packet {idx}... dropping packet")
                        # bad_packet_indices_indices.append(idx)
                        drop_packet = True
                        break
                    escaped = False
                    unescaped_packet.append(byte)
                elif byte == 0x7D:
                    escaped = True
                else:
                    unescaped_packet.append(byte)
            if drop_packet:
                continue
            if escaped:
                print(f"[WARN] ends with 0x7D")
            unescaped_packet.extend(packet[-1:])
            calculated_crc = FCS16.calculate(unescaped_packet[1:-3]).hex()
            extracted_crc = unescaped_packet[-3:-1].hex()
            if calculated_crc != extracted_crc:
                print(f"[WARN] - CRC mismatch!")
                print(f"    CALCULATED FCS: {calculated_crc}")
                print(f"    EXTRACTED FCS: {extracted_crc}")
            self.escaped_packets.append(unescaped_packet)
        for idx in bad_packet_indices_indices:
            del self.packet_start_indices[idx]

    def from_data(self, bits: str):
        skipped = 0
        byte_started = False
        current_byte = ''
        packet_started = False
        current_packet = bytearray()
        for bit_idx, bit in enumerate(bits):
            # Skip noise at the start
            if skipped < Packetizer.SKIP_SET_BITS:
                if bit == '\x01':
                    skipped += 1
            else:
                # Actual processing
                if not byte_started:
                    # 0 is the start bit, trigger on it
                    byte_started = (bit == '\x00')
                if byte_started:
                    current_byte += bit
                    if len(current_byte) == 9:
                        # Create the whole byte and reset
                        byte = Packetizer.bit_string_to_byte(current_byte)
                        byte_started = False
                        current_byte = ''

                        # Packet-level analysis
                        if len(current_packet) == 0:
                            # Start a new packet
                            print(f"\n= START PACKET {len(self.packets)} @ INDEX {bit_idx} ====================================")
                            if byte != Packetizer.START_BYTE:
                                print(f"[WARN] Starting on non-start byte {hex(byte)}!")
                            packet_started = True
                            self.packet_start_indices.append(bit_idx)
                            current_packet.append(byte)
                        elif packet_started:
                            current_packet.append(byte)
                            if byte == Packetizer.END_BYTE:
                                print(f"Packet ended @ index {bit_idx}")
                                # We've reached the packet end, wrap it up and start over
                                # print(f">>> Ending packet {len(self.packets)}")
                                self.packets.append(current_packet)
                                packet_started = False
                                current_packet = bytearray()
        if len(self.packet_start_indices) == len(self.packets) + 1:
            self.packet_start_indices.pop()


if __name__ == '__main__':
    assert len(sys.argv) in [3, 4], "require two arguments: infile outfile"

    packet_search_string = None
    if len(sys.argv) == 4 and sys.argv[3]:
        packet_search_string = sys.argv[3]

    packetizer = Packetizer()
    packetizer.from_file(sys.argv[1])
    packetizer.escape_packets()

    with open(sys.argv[2] + ".original_packets", "w+") as orig_fh:
        with open(sys.argv[2] + ".timestamps", "w+") as index_fh:
            with open(sys.argv[2] + ".packets", "w+") as fh:
                for idx, orig_packet in enumerate(packetizer.packets):
                    if idx < len(packetizer.escaped_packets):
                        packet = packetizer.escaped_packets[idx]
                        print(f"\n= WRITE PACKET {idx} ====================================")
                        trimmed_packet = packet[1:-3]
                        scapy_summary = PPP(trimmed_packet).summary()
                        print(scapy_summary)
                        if packet_search_string and packet_search_string in scapy_summary:
                            with open(sys.argv[2] + ".match", "w+") as match_fh:
                                match_fh.write(scapy_summary)
                        hexdump(trimmed_packet)
                        if packet[0] != 0x7E or packet[-1] != 0x7E:
                            print(f"[WARN] Improperly formatted PPP packet")
                            # continue
                        fh.write('\n')
                        fh.write(hexdump(trimmed_packet, dump=True))
                        fh.write('\n')
                    index_fh.write(str(packetizer.packet_start_indices[idx]) + '\n')
                    orig_fh.write('\n')
                    orig_fh.write(hexdump(orig_packet[1:-3], dump=True))
                    orig_fh.write('\n')

    os.system(f"text2pcap -l9 '{sys.argv[2] + '.packets'}' '{sys.argv[2] + '.pcap'}'")
