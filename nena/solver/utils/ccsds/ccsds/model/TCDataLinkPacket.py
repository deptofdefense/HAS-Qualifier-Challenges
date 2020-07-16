# Contains definition of Telecommand Data Link Protocol, and its corresponding encoder and decoder
# CCSDS-232.0-B-3 standard
from dataclasses import dataclass
from enum import Enum
from typing import List

from construct import BitStruct, BitsInteger, Flag
from ccsds.model.SpacePacket import SpacePacket, SpacePacketType, SpacePacketSequenceFlags

TransferFramePrimaryHeader = BitStruct('tx_frame_version' / BitsInteger(2),
                                       'bypass_flag' / Flag,
                                       'control_command_flag' / Flag,
                                       'reserved_spare' / BitsInteger(2),
                                       'spacecraft_id' / BitsInteger(10),
                                       'virtual_channel_id' / BitsInteger(6),
                                       'frame_length' / BitsInteger(10),
                                       'frame_seq_num' / BitsInteger(8))

SegmentHeader = BitStruct('seq_flags' / BitsInteger(2),
                          'map_id' / BitsInteger(6))
FRAME_PRIMARY_HEADER_BYTES = 5
SEGMENT_HEADER_BYTES = 1
MAX_TRANSFER_FRAME_BYTES_WITH_SEGMENT_HEADER = 1019
MAX_TRANSFER_FRAME_BYTES_WITHOUT_SEGMENT_HEADER = MAX_TRANSFER_FRAME_BYTES_WITH_SEGMENT_HEADER - 1
FRAME_MAX_SEQ_NUM = 255
MAX_SPACECRAFT_ID = 1023
MAX_VIRTUAL_CHANNEL_ID = 63
MAX_MAP_ID = 63
MAX_TRANSFER_FRAME_LENGTH = 1024


class ControlCommandFlag(Enum):
    COMMAND = 0  # Contains frame data unit, currently the control commands are defined in 4.1.3.3.1
    CONTROL = 1  # Contains information, this is the more commonly used one


class SegmentHeaderSequenceFlags(Enum):
    SEGMENT_CONTINUATION = 0
    SEGMENT_FIRST = 1
    SEGMENT_LAST = 2
    UNSEGMENTED = 3


@dataclass
class TCDataLinkPacket:
    tx_frame_version: int
    bypass_flag: bool
    control_command_flag: ControlCommandFlag
    spacecraft_id: int  # unique to each spacecraft it communicates to
    virtual_channel_id: int
    frame_seq_num: int
    seq_flags: SegmentHeaderSequenceFlags
    map_id: int
    data: bytes

    def __repr__(self):
        return (f'{self.__class__.__name__}'
                '(TransferFramePrimaryHeader'
                f'(version={self.tx_frame_version!r}, '
                f'bypass_flag={self.bypass_flag!r}, '
                f'control_command_flag={self.control_command_flag!r}, '
                f'spacecraft_id={self.spacecraft_id!r}, '
                f'virtual_channel_id={self.virtual_channel_id!r}, '
                f'frame_length={(len(self.data)+SEGMENT_HEADER_BYTES+FRAME_PRIMARY_HEADER_BYTES-1)!r}, '
                f'frame_seq_num={self.frame_seq_num!r}), '
                'SegmentHeader'
                f'(seq_flags={self.seq_flags!r}, '
                f'map_id={self.map_id!r}), '
                f'data={self.data!r})')

    def to_bytes(self):
        # TODO: Optional - implement error control field (In section 4.1.4 of CCSDS standard)
        segment_header = SegmentHeader.build(
            dict(
                seq_flags=self.seq_flags.value,
                map_id=self.map_id
            )
        )
        header = TransferFramePrimaryHeader.build(
            dict(
                tx_frame_version=self.tx_frame_version,
                bypass_flag=self.bypass_flag,
                control_command_flag=self.control_command_flag.value,
                reserved_spare=0,
                spacecraft_id=self.spacecraft_id,
                virtual_channel_id=self.virtual_channel_id,
                frame_length=len(self.data) + SEGMENT_HEADER_BYTES + FRAME_PRIMARY_HEADER_BYTES - 1,
                frame_seq_num=self.frame_seq_num
            )
        )
        return header + segment_header + self.data

    @staticmethod
    def from_bytes(bytestream):

        # TODO: Add assertions to different fields here
        header_bytes = bytestream[0:FRAME_PRIMARY_HEADER_BYTES]
        segment_header_bytes = bytestream[FRAME_PRIMARY_HEADER_BYTES:SEGMENT_HEADER_BYTES + FRAME_PRIMARY_HEADER_BYTES]
        data = bytestream[FRAME_PRIMARY_HEADER_BYTES + SEGMENT_HEADER_BYTES: ]

        transfer_frame_header = TransferFramePrimaryHeader.parse(header_bytes)
        segment_header = SegmentHeader.parse(segment_header_bytes)

        return TCDataLinkPacket(
            tx_frame_version=transfer_frame_header.tx_frame_version,
            bypass_flag=transfer_frame_header.bypass_flag,
            control_command_flag=ControlCommandFlag(transfer_frame_header.control_command_flag),
            spacecraft_id=transfer_frame_header.spacecraft_id,
            virtual_channel_id=transfer_frame_header.virtual_channel_id,
            frame_seq_num=transfer_frame_header.frame_seq_num,
            seq_flags=SegmentHeaderSequenceFlags(segment_header.seq_flags),
            map_id=segment_header.map_id,
            data=data
        )


class TCDataLinkProtocolDecoder:

    def __init__(
            self,
            spacecraft_id: int,
            virtual_channel_id: int,
            map_id: int
    ):
        # TODO : Suppport spacecraftID, virtualChannelID and mapID multiplexing, right now it only supports
        # TODO: 1 spacecraftID, virtualChannelID and mapID
        assert (spacecraft_id <= MAX_SPACECRAFT_ID)
        assert (virtual_channel_id <= MAX_VIRTUAL_CHANNEL_ID)
        assert (map_id <= MAX_MAP_ID)

        self.spacecraft_id = spacecraft_id
        self.virtual_channel_id = virtual_channel_id
        self.map_id = map_id
        pass

    def decode_to_spp_packets(
            self,
            datalink_list: List[TCDataLinkPacket]
    ):
        """
        Given a list of datalink packest, reconstruct the SPP packets
        :param datalink_list:
        :return:
        """
        spp_packet_list = []
        segmented_packet_list = []
        # TODO : Support reordering of packets, right now it assumes that packets must come in order
        reordered_datalink_list = [None] * len(datalink_list)
        for packet in datalink_list:
            reordered_datalink_list[packet.frame_seq_num] = packet
        for packet in reordered_datalink_list:
            # filter out packets that do not match spacecraft_id, virtual_channel_id and map_id
            if packet.spacecraft_id != self.spacecraft_id or packet.virtual_channel_id != self.virtual_channel_id or \
                    packet.map_id != self.map_id:
                continue
            # handle different case scenarios
            if packet.seq_flags == SegmentHeaderSequenceFlags.UNSEGMENTED:
                spp_packet_list.append(SpacePacket.from_bytes(packet.data))
            elif packet.seq_flags == SegmentHeaderSequenceFlags.SEGMENT_FIRST:
                segmented_packet_list = [packet]
            elif packet.seq_flags == SegmentHeaderSequenceFlags.SEGMENT_CONTINUATION:
                assert (len(segmented_packet_list) > 0)
                segmented_packet_list.append(packet)
            elif packet.seq_flags == SegmentHeaderSequenceFlags.SEGMENT_LAST:
                segmented_packet_list.append(packet)
                # receive the last segmented packet, reconstruct the packet here
                data_bytestream = b''
                for segmented_packet in segmented_packet_list:
                    data_bytestream += segmented_packet.data
                segmented_packet_list = []
                spp_packet_list.append(SpacePacket.from_bytes(data_bytestream))
            else:
                raise RuntimeError("Sequence Flag {} not implemented".format(packet.seq_flags))

        return spp_packet_list


class TCDataLinkProtocolEncoder:

    def __init__(
            self,
            control_command_flag: ControlCommandFlag,
            spacecraft_id: int,
            virtual_channel_id: int,
            map_id: int
    ):
        assert (spacecraft_id <= MAX_SPACECRAFT_ID)
        assert (virtual_channel_id <= MAX_VIRTUAL_CHANNEL_ID)
        assert (map_id <= MAX_MAP_ID)
        self.tx_frame_version = 0  # recommended by CCSDS
        self.bypass_flag = True  # TODO: Implement non-bypass mechanism. let's bypass FARM check for now
        self.control_command_flag = control_command_flag
        self.frame_sequence_number = 0
        self.spacecraft_id = spacecraft_id
        self.virtual_channel_id = virtual_channel_id
        self.map_id = map_id

    def encode_spp_list(
            self,
            spp_packet_list: List[SpacePacket]
    ):
        """
        encode a list of spp packets to DataLinkPackets
        :param spp_packet_list:
        :return:
        """
        datalink_packets = []
        for spp_packet in spp_packet_list:
            datalink_packets += self.encode(spp_packet.to_bytes())
        return datalink_packets

    def encode(
            self,
            data: bytes
    ) -> List[TCDataLinkPacket]:
        """
        Given a bytestream, parse the bytestream into suitable sizes and generate a list of TCDataLinkPackets
        :param data: data to be encoded to packets
        :return: List[TCDataLinkPackets]
        """
        data_list = []
        tc_datalink_packet_list = []
        # parse bytestream into segments
        if len(data) <= MAX_TRANSFER_FRAME_BYTES_WITHOUT_SEGMENT_HEADER:
            data_list.append((SegmentHeaderSequenceFlags.UNSEGMENTED, data))
        else:
            for i in range(0, len(data), MAX_TRANSFER_FRAME_BYTES_WITHOUT_SEGMENT_HEADER):
                if i == 0:
                    data_list.append((
                        SegmentHeaderSequenceFlags.SEGMENT_FIRST,
                        data[i:i + MAX_TRANSFER_FRAME_BYTES_WITHOUT_SEGMENT_HEADER]
                    ))
                elif i + MAX_TRANSFER_FRAME_BYTES_WITHOUT_SEGMENT_HEADER >= len(data):
                    data_list.append((
                        SegmentHeaderSequenceFlags.SEGMENT_LAST,
                        bytes(data[i:])
                    ))
                else:
                    data_list.append((
                        SegmentHeaderSequenceFlags.SEGMENT_CONTINUATION,
                        data[i:i + MAX_TRANSFER_FRAME_BYTES_WITHOUT_SEGMENT_HEADER]
                    ))
        for (seq_flag, segmented_data) in data_list:
            # Create datalink packet
            datalink_packet = TCDataLinkPacket(
                tx_frame_version=self.tx_frame_version,
                bypass_flag=self.bypass_flag,
                control_command_flag=self.control_command_flag,
                spacecraft_id=self.spacecraft_id,
                virtual_channel_id=self.virtual_channel_id,
                frame_seq_num=self.frame_sequence_number,
                seq_flags=seq_flag,
                map_id=self.map_id,
                data=segmented_data
            )
            # TODO: the transmission of sequence number is actually much more complicated than this (detailed in CCSDS
            # TODO: 232-1-B.2) Implement it when i get the chance
            self.frame_sequence_number += 1
            if self.frame_sequence_number > FRAME_MAX_SEQ_NUM:
                self.frame_sequence_number = 0
            assert (len(datalink_packet.to_bytes()) <= MAX_TRANSFER_FRAME_LENGTH)
            tc_datalink_packet_list.append(datalink_packet)
        return tc_datalink_packet_list

