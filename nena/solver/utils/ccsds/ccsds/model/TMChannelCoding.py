from reedsolo import RSCodec
import collections
import struct
from typing import List
from ccsds.model.TCDataLinkPacket import TCDataLinkPacket, FRAME_PRIMARY_HEADER_BYTES, TransferFramePrimaryHeader
import re

ASM = b"\x1A\xCF\xFC\x1D"
ECC = 16
INTERLEAVING_DEPTH = 1
VIRTUAL_FILL_SYMBOLA = 0
FRAME_LENGTH = 255 - ((2*ECC - 0) * INTERLEAVING_DEPTH)

def bytes_2_bits(data):
    bit_split_data = []
    for i, byte in enumerate(data):
        for bit_i in range(7, -1, -1):
            mask = 1 << bit_i
            bit = (byte & mask) >> bit_i
            bit_split_data.append(bit)
    return bit_split_data


def bits_2_bytes(bit_split_data):
    data = b""
    for i in range(int(len(bit_split_data) / 8)):
        byte = 0
        for bit_i in range(0, 8, 1):
            bit = bit_split_data[(i * 8) + bit_i]
            mask = bit << (7 - bit_i)
            byte = int(byte) | mask
        data += struct.pack(">B", byte)
    return data


class TMEncoder:
    def __init__(self):
        self.rsc = RSCodec(ECC)

    def encode_tc_datalink_packets(
            self,
            datalink_packets
    ) -> bytes:
        bytestream = b''
        for packet in datalink_packets:
            bytestream += self.encode_bytes(packet.to_bytes())
        return bytestream

    def encode_bytes(self, data):
        frames = []
        for i in range(0, len(data), FRAME_LENGTH):
            frame = data[i: i + FRAME_LENGTH]
            encoded_data = self.rsc.encode(frame)
            sync_frame = ASM + encoded_data
            frames.append(sync_frame)
        return b''.join(frames)

    def convolve_code(self, data):
        bits = bytes_2_bits(data)
        state = collections.deque([0, 0, 0, 0, 0, 0], 6)
        c_bits = []
        for bit in bits:
            c1 = bit ^ state[0] ^ state[1] ^ state[2] ^ state[5]
            c2 = bit ^ state[1] ^ state[2] ^ state[4] ^ state[5]
            state.appendleft(bit)
            c_bits.append(c1)
            c_bits.append(abs(c2 - 1))
        return bits_2_bytes(c_bits)

class TMDecoder:
    def __init__(self):
        self.rsc = RSCodec(ECC)

    def decode_to_bytes(self, data):
        frames = data.split(ASM)
        decoded_frames = []
        for frame in frames:
            decoded_frame = self.rsc.decode(frame)[0]
            decoded_frames.append(decoded_frame)
        return b''.join(decoded_frames)

    def decode_to_tc_datalink_packets(self, data):
        i = 0
        frames = []
        spacecraft_id = None
        data_bytes = self.decode_to_bytes(data)
        while i < len(data_bytes):
            frame_header = TransferFramePrimaryHeader.parse(
                        data_bytes[i:i + FRAME_PRIMARY_HEADER_BYTES]
                    )
            if spacecraft_id == None:
                spacecraft_id = frame_header.spacecraft_id
            else:
                if frame_header.spacecraft_id != spacecraft_id:  # If there is trailing noise at the end of the signal
                    return frames
            frame_length = frame_header.frame_length + 1
            frame = data_bytes[i: i + frame_length]
            i += frame_length
            frames.append(TCDataLinkPacket.from_bytes(frame))
        return frames

    def unconvolve_code(self, data):
        pass
