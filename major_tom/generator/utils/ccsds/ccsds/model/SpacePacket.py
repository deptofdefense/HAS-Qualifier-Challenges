# Contains definition of Space Packet, and its corresponding encoder and decoder
# CCSDS-133.0-B-1 standard

from dataclasses import dataclass
from enum import Enum
from typing import List

from construct import BitStruct, BitsInteger, Flag

MAX_APID_VAL = 2047
MAX_SEQ_NUM = 16383
MAX_BYTES_PER_PACKET = 65536
SPP_HEADER_BYTES = 6

SpacePacketHeader = BitStruct('ccsds_version' / BitsInteger(3),
                              'packet_type' / BitsInteger(1),
                              'sec_hdr_flag' / Flag,
                              'apid' / BitsInteger(11),
                              'seq_flags' / BitsInteger(2),
                              'packet_seq_count' / BitsInteger(14),
                              'data_length' / BitsInteger(16))


class SpacePacketType(Enum):
    TELECOMMAND = 0  # ground station to satellite
    TELEMETRY = 1  # satellite to ground station


class SpacePacketSequenceFlags(Enum):
    SEGMENT_CONTINUATION = 0
    SEGMENT_FIRST = 1
    SEGMENT_LAST = 2
    UNSEGMENTED = 3


@dataclass
class SpacePacket:
    ccsds_version: int
    packet_type: SpacePacketType
    sec_hdr_flag: bool
    apid: int
    seq_flags: SpacePacketSequenceFlags
    packet_seq_count: int
    data: bytes

    def __repr__(self):
        return (f'{self.__class__.__name__}'
                f'(version={self.ccsds_version!r}, '
                f'type={self.packet_type!r}, '
                f'sec_hdr_flag={self.sec_hdr_flag!r}, '
                f'apid={self.apid!r}, '
                f'seq_flags={self.seq_flags!r}, '
                f'seq_count={self.packet_seq_count!r}, '
                f'data_length={len(self.data)!r}, '
                f'data={self.data!r})')

    def to_bytes(self):
        header = SpacePacketHeader.build(
            dict(
                ccsds_version=self.ccsds_version,
                packet_type=self.packet_type.value,
                sec_hdr_flag=self.sec_hdr_flag,
                apid=self.apid,
                seq_flags=self.seq_flags.value,
                packet_seq_count=self.packet_seq_count,
                data_length=len(self.data) - 1
            ))
        return header + self.data

    @staticmethod
    def from_bytes(bytestream):
        header_bytes = bytestream[0:SPP_HEADER_BYTES]
        space_packet_header = SpacePacketHeader.parse(header_bytes)
        return SpacePacket(
            space_packet_header.ccsds_version,
            SpacePacketType(space_packet_header.packet_type),
            space_packet_header.sec_hdr_flag,
            space_packet_header.apid,
            SpacePacketSequenceFlags(space_packet_header.seq_flags),
            space_packet_header.packet_seq_count,
            bytestream[SPP_HEADER_BYTES:]
        )


class SpacePacketProtocolDecoder:
    """
    Decodes space packet with CCSDS-133.0-B-1 standard.
    """

    def __init__(self, apid):
        self.apid = apid

    def decode(
            self,
            space_packet_list: List[SpacePacket]
    ):
        """
        Given a list of bytestring, decodes it to ONE Space Packet construct
        If needed, we can make another function that decodes a stream of bytes, but I don't know how necessary it is
        right now
        """
        user_data = b''
        # TODO: reorder the packets
        for packet in space_packet_list:
            if packet.apid != self.apid:
                continue
            user_data += packet.data
        return user_data


class SpacePacketProtocolEncoder:
    """
    Encodes space packet, takes into account of sequece counting
    and asserts the values are valid before encoding the packet
    CCSDS-133.0-B-1
    """

    def __init__(
            self,
            packet_type: SpacePacketType,
            apid: int
    ):
        """

        :param packet_type: either Telemetry or Telecommand
        :param apid: Application Process ID, must be less than 2047
        """
        assert (isinstance(packet_type, SpacePacketType))
        assert (apid < MAX_APID_VAL)
        self.apid = apid
        self.packet_type = packet_type
        self.ccsds_version = 0  # recommened by standard
        self.sec_hdr_flag = False  # optional to have secondary header
        self.seq_num = 0

    def encode_packets(
            self,
            data: bytes
    ) -> List[SpacePacket]:
        """
        Encodes a chunk of data into a list of space packets
        :param data:
        :return:
        """
        data_list = []
        space_packet_list = []

        # Split the data into segments if necessary
        if len(data) <= MAX_BYTES_PER_PACKET:
            data_list.append((SpacePacketSequenceFlags.UNSEGMENTED, data))
        else:
            for i in range(0, len(data), MAX_BYTES_PER_PACKET):
                if i == 0:
                    data_list.append((SpacePacketSequenceFlags.SEGMENT_FIRST, data[i:i + MAX_BYTES_PER_PACKET]))
                elif i + MAX_BYTES_PER_PACKET >= len(data):
                    data_list.append((SpacePacketSequenceFlags.SEGMENT_LAST, bytes(data[i:])))
                else:
                    data_list.append((SpacePacketSequenceFlags.SEGMENT_CONTINUATION, data[i:i + MAX_BYTES_PER_PACKET]))

        for (seq_flag, segmented_data) in data_list:
            # create space packets
            space_packet_list.append(SpacePacket(
                ccsds_version=self.ccsds_version,
                packet_type=self.packet_type,
                sec_hdr_flag=self.sec_hdr_flag,
                apid=self.apid,
                seq_flags=seq_flag,
                packet_seq_count=self.seq_num,
                data=segmented_data
            ))
            # keep track of sequence number, overflows at MAX_SEQ_NUM
            self.seq_num += 1
            if self.seq_num > MAX_SEQ_NUM:
                self.seq_num = 0
        return space_packet_list
