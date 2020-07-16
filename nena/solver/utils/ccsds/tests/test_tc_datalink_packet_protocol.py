import os

from ccsds.model.SpacePacket import SpacePacket, SpacePacketType, SpacePacketSequenceFlags
from ccsds.model.TCDataLinkPacket import TCDataLinkProtocolEncoder, ControlCommandFlag, TCDataLinkPacket, \
    SegmentHeaderSequenceFlags

TEST_APID_VAL = 1337

def test_unsegmented_spp_packet_tc_datalnk_encoding():
    """
    Test encoding a Space Packet
    :return:
    """
    data = b'\xde\xad\xbe\xef'
    expected_spp_byte_sequence = b'\x05\x39\xc0\x11\x00\x04\xde\xad\xbe\xef'
    virtual_channel_id = 36
    map_id = 18
    spacecraft_id = 555
    space_packet = SpacePacket(
        ccsds_version=0,
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL,
        seq_flags=SpacePacketSequenceFlags.UNSEGMENTED,
        packet_seq_count=17,
        data=data,
        sec_hdr_flag=False
    )
    tc_datalink_encoder = TCDataLinkProtocolEncoder(
        control_command_flag=ControlCommandFlag.CONTROL,
        spacecraft_id=spacecraft_id,
        virtual_channel_id=virtual_channel_id,
        map_id=map_id
    )

    datalink_packet_list = tc_datalink_encoder.encode_spp_list([space_packet])

    expected_tc_datalink_packet = TCDataLinkPacket(
        tx_frame_version=0,
        bypass_flag=True,
        control_command_flag=ControlCommandFlag.CONTROL,
        spacecraft_id=spacecraft_id,
        virtual_channel_id=virtual_channel_id,
        frame_seq_num=0,
        seq_flags=SegmentHeaderSequenceFlags.UNSEGMENTED,
        map_id=map_id,
        data=expected_spp_byte_sequence
    )

    assert(datalink_packet_list[0] == expected_tc_datalink_packet)
    assert(datalink_packet_list[0].to_bytes() == expected_tc_datalink_packet.to_bytes())


def test_unsegmented_tc_datalink_packet_protocol():
    """
    Test encoding random bytes into one TC datalink packet
    :return:
    """
    spacecraft_id = 1000
    virtual_channel_id = 10
    map_id = 20
    tc_datalink_encoder = TCDataLinkProtocolEncoder(
        control_command_flag=ControlCommandFlag.CONTROL,
        spacecraft_id=spacecraft_id,
        virtual_channel_id=virtual_channel_id,
        map_id=map_id
    )
    random_data = os.urandom(256)   # generate 256 bytes of random data
    encoded_data_list = tc_datalink_encoder.encode(random_data)
    expected_tc_datalink_packet = TCDataLinkPacket(
        tx_frame_version=0,
        bypass_flag=True,
        control_command_flag=ControlCommandFlag.CONTROL,
        spacecraft_id=spacecraft_id,
        virtual_channel_id=virtual_channel_id,
        frame_seq_num=0,
        seq_flags=SegmentHeaderSequenceFlags.UNSEGMENTED,
        map_id=map_id,
        data=random_data

    )
    # assert that only one packet exists and that the packets match
    assert(len(encoded_data_list) == 1)
    assert(encoded_data_list[0] == expected_tc_datalink_packet)
    assert(encoded_data_list[0].to_bytes() == expected_tc_datalink_packet.to_bytes())


def test_segmented_tc_datalink_packets():
    """
    Test segmenting datalink packets
    :return:
    """
    pass

def test_tc_datalink_packets_to_bytes():
    """
    Test serializing datalink packets to bytes
    """
