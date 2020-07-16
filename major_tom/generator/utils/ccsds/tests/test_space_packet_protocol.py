import pytest
import os
from ccsds.model.SpacePacket import SpacePacketProtocolEncoder, SpacePacketType, SpacePacketSequenceFlags,\
    MAX_BYTES_PER_PACKET, SpacePacket, SpacePacketProtocolDecoder

TEST_APID_VAL = 1337

def test_encoder_decoder_compatibility():
    """
    Decoder should be able to decode the list of space packets from encoder
    """
    spp_encoder = SpacePacketProtocolEncoder(
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL
    )
    spp_decoder = SpacePacketProtocolDecoder(apid=TEST_APID_VAL)
    random_data = os.urandom(MAX_BYTES_PER_PACKET * 10 + 77)
    encoded_packet_list = spp_encoder.encode_packets(random_data)
    decoded_data = spp_decoder.decode(encoded_packet_list)
    assert(decoded_data == random_data)


def test_segmented_space_packet_protocol():
    """
    Test formation of segmented space packet (length of data greater than 16384 bytes)
    """
    spp_encoder = SpacePacketProtocolEncoder(
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL
    )
    random_data = os.urandom(MAX_BYTES_PER_PACKET + 1)   #  one more byte than space packet can handle
    encoded_data_list = spp_encoder.encode_packets(random_data)
    expected_space_packet_0 = SpacePacket(
        ccsds_version=0,
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL,
        seq_flags=SpacePacketSequenceFlags.SEGMENT_FIRST,
        packet_seq_count=0,
        data=random_data[0:MAX_BYTES_PER_PACKET],
        sec_hdr_flag=False
    )
    expected_space_packet_1 = SpacePacket(
        ccsds_version=0,
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL,
        seq_flags=SpacePacketSequenceFlags.SEGMENT_LAST,
        packet_seq_count=1,
        data=bytes(random_data[MAX_BYTES_PER_PACKET:]),
        sec_hdr_flag=False
    )

    # assert that only one packet exists and that the packets match
    assert(len(encoded_data_list) == 2)
    assert(encoded_data_list[0] == expected_space_packet_0)
    assert(encoded_data_list[1] == expected_space_packet_1)


def test_unsegmented_space_packet_protocol():
    """
    Test formation of unsegmented space packet (length of data less than 16384 bytes)
    """
    spp_encoder = SpacePacketProtocolEncoder(
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL
    )
    random_data = os.urandom(256)   # generate 256 bytes of random data
    encoded_data_list = spp_encoder.encode_packets(random_data)
    expected_space_packet = SpacePacket(
        ccsds_version=0,
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL,
        seq_flags=SpacePacketSequenceFlags.UNSEGMENTED,
        packet_seq_count=0,
        data=random_data,
        sec_hdr_flag=False
    )
    # assert that only one packet exists and that the packets match
    assert(len(encoded_data_list) == 1)
    assert(encoded_data_list[0] == expected_space_packet)


def test_space_packet_decoder_segmented():
    """
    Test the decoder with a list of packets
    """
    random_data = os.urandom(MAX_BYTES_PER_PACKET + 1)  # one more byte than space packet can handle
    expected_space_packet_0 = SpacePacket(
        ccsds_version=0,
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL,
        seq_flags=SpacePacketSequenceFlags.SEGMENT_FIRST,
        packet_seq_count=0,
        data=random_data[0:MAX_BYTES_PER_PACKET],
        sec_hdr_flag=False
    )
    expected_space_packet_1 = SpacePacket(
        ccsds_version=0,
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL,
        seq_flags=SpacePacketSequenceFlags.SEGMENT_LAST,
        packet_seq_count=1,
        data=bytes(random_data[MAX_BYTES_PER_PACKET:]),
        sec_hdr_flag=False
    )
    space_packet_list = [expected_space_packet_0, expected_space_packet_1]
    decoder = SpacePacketProtocolDecoder(apid=TEST_APID_VAL)
    user_data = decoder.decode(space_packet_list)
    assert(user_data == random_data)


def test_space_packet_decoder_unsegmented():
    """
    Test the decoder on ONE space packet
    """
    expected_data = b'\xde\xad\xbe\xef'
    space_packet = SpacePacket(
        ccsds_version=0,
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL,
        seq_flags=SpacePacketSequenceFlags.UNSEGMENTED,
        packet_seq_count=17,
        data=expected_data,
        sec_hdr_flag=False
    )
    decoder = SpacePacketProtocolDecoder(apid=TEST_APID_VAL)
    user_data = decoder.decode([space_packet])
    assert (user_data == expected_data)


def test_space_packet_from_bytes():
    """
    Test deserialization of space packets
    :return:
    """
    byte_sequence = b'\x05\x39\xc0\x11\x00\x04\xde\xad\xbe\xef'
    expected_space_packet = SpacePacket(
        ccsds_version=0,
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL,
        seq_flags=SpacePacketSequenceFlags.UNSEGMENTED,
        packet_seq_count=17,
        data=b'\xde\xad\xbe\xef',
        sec_hdr_flag=False
    )
    space_packet = SpacePacket.from_bytes(byte_sequence)
    assert(space_packet == expected_space_packet)


def test_space_packet_to_bytes():
    """
    Test serializing space packets to bytes
    """

    expected_byte_sequence = b'\x05\x39\xc0\x11\x00\x04\xde\xad\xbe\xef'
    space_packet = SpacePacket(
        ccsds_version=0,
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL,
        seq_flags=SpacePacketSequenceFlags.UNSEGMENTED,
        packet_seq_count=17,
        data=b'\xde\xad\xbe\xef',
        sec_hdr_flag=False
    )

    assert(expected_byte_sequence == space_packet.to_bytes())
