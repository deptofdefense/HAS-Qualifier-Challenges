import struct
from typing import List

from construct import BitStruct, BitsInteger, Bytes

from ccsds.model.TCDataLinkPacket import TCDataLinkPacket, FRAME_PRIMARY_HEADER_BYTES, TransferFramePrimaryHeader, \
    SEGMENT_HEADER_BYTES, SegmentHeader, ControlCommandFlag, SegmentHeaderSequenceFlags

CommunicationLinkTransmissionUnit = BitStruct('start_sequence' / Bytes(2),
                                              'information_bits' / Bytes(7),
                                              'parity_bits' / Bytes(1),
                                              'tail_sequence' / Bytes(2))

MAX_INFORMATION_BITS = 56
MAX_INFORMATION_BYTES = 7 # 56 / 8


class CLTUDecoder:

    def __init__(
        self,
        start_sequence: bytes,
        tail_sequence: bytes
    ):
        assert(len(start_sequence) == 2)
        assert(len(tail_sequence) == 2)

        self.start_sequence = start_sequence
        self.tail_sequence = tail_sequence

    def decode_to_tc_datalink_packets(self, data):
        """
        Given a bytestream, recover the datalink packet from it
        :param bytestream:
        :return:
        """
        byte_index = 0
        extracted_data_from_cltu = b''
        extracted_tc_datalink_packets = []
        part_of_previous_frame = False
        frame_length = 0
        while byte_index < len(data):
            if data[byte_index:byte_index+2] == self.start_sequence:
                # start sequence is detected, retrieve 7 bytes from it
                # TODO: Perform parity check
                header = data[byte_index:byte_index+2]
                byte_index += 2
                # extract 7byte data
                extracted_data_from_cltu += data[byte_index:byte_index+MAX_INFORMATION_BYTES]
                byte_index += MAX_INFORMATION_BYTES
                # parity byte
                byte_index += 1
                # check that tail sequence exists
                assert data[byte_index:byte_index+2] == self.tail_sequence
                byte_index += 2
                # reconstruct the packet here
                if not part_of_previous_frame:
                    # we got the first part of a frame, reconstruct the frame header here and get the length of frame
                    part_of_previous_frame = True
                    curr_frame_header = TransferFramePrimaryHeader.parse(
                        extracted_data_from_cltu[:FRAME_PRIMARY_HEADER_BYTES]
                    )
                    frame_length = curr_frame_header.frame_length + 1
                else:
                    # if the frame length matches the current extracted data from transmission unit, try
                    # to reconstruct the packet here
                    if len(extracted_data_from_cltu) >= frame_length:
                        # the frame is delimited by frame length, the rest should be just fillers
                        frame_data = extracted_data_from_cltu[:frame_length]
                        extracted_tc_datalink_packets.append(
                           TCDataLinkPacket.from_bytes(frame_data)
                        )

                        # after constructing the packet, reset frame
                        part_of_previous_frame = False
                        extracted_data_from_cltu = b''
            else:
                byte_index += 1

        return extracted_tc_datalink_packets

class CLTUEncoder:

    def __init__(
            self,
            start_sequence: bytes,
            tail_sequence : bytes
    ):

        assert(len(start_sequence) == 2)
        assert(len(tail_sequence) == 2)

        self.start_sequence = start_sequence
        self.tail_sequence = tail_sequence

    def encode_tc_datalink_packets(
            self,
            datalink_packets: List[TCDataLinkPacket]
    ) -> bytes:
        """
        Encodes a list of datalink packets and returns corresponding stream
        :param datalink_packets:
        :return:
        """
        bytestream = b''
        for packet in datalink_packets:
            bytestream += self.encode_bytes(packet.to_bytes())
        return bytestream

    def calculate_parity(self, information_bits):
        # TODO: Implement parity calculation
        return b'\xfe'

    def encode_bytes(self, data: bytes) -> bytes:
        """
        Given a bytestream, encode them as CLTU units and return a stream of bytes
        :param data:
        :return:
        """
        ret_bytestream = b''
        # first parse them as 56 information bit units
        for i in range(0, len(data), MAX_INFORMATION_BYTES):
            # what if it rolls over?
            if i + MAX_INFORMATION_BYTES > len(data):
                information_bits = data[i:]
            else:
                information_bits = data[i:i+MAX_INFORMATION_BYTES]
            # calculate amount of filler bits, need to fill up the codeword to 64 bits
            # calculate 7-bit parity
            information_bits += b'\x55' * (7-len(information_bits))
            parity_bits = self.calculate_parity(information_bits)
            # concatenate start_sequence, tail_sequence,
            ret_bytestream += self.start_sequence + information_bits + parity_bits + self.tail_sequence

        return ret_bytestream

