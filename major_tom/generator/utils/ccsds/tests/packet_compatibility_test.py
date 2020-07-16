import os

import pytest

from ccsds.model.SpacePacket import SpacePacketProtocolEncoder, SpacePacketType, SpacePacketProtocolDecoder, \
    MAX_BYTES_PER_PACKET, SpacePacket, SpacePacketSequenceFlags
from ccsds.model.TCChannelCoding import CLTUEncoder, CLTUDecoder
from ccsds.model.TCDataLinkPacket import TCDataLinkProtocolEncoder, TCDataLinkProtocolDecoder, ControlCommandFlag, \
    SegmentHeaderSequenceFlags, TCDataLinkPacket

TEST_APID_VAL = 1337
TEST_SPACECRAFT_ID = 88
TEST_VIRTUAL_CHANNEL_ID = 62
TEST_MAP_ID = 61

TEST_START_SEQUENCE = b'\xca\xfe'
TEST_END_SEQUENCE = b'\xba\xbe'


@pytest.fixture
def setup_encoder_decoder():
    # setup space packet, tc datalink and tc channel encoder/decoder
    spp_encoder = SpacePacketProtocolEncoder(
        packet_type=SpacePacketType.TELECOMMAND,
        apid=TEST_APID_VAL
    )

    tc_datalink_encoder = TCDataLinkProtocolEncoder(
        control_command_flag=ControlCommandFlag.CONTROL,
        spacecraft_id=TEST_SPACECRAFT_ID,
        virtual_channel_id=TEST_VIRTUAL_CHANNEL_ID,
        map_id=TEST_MAP_ID
    )

    cltu_encoder = CLTUEncoder(
        start_sequence=TEST_START_SEQUENCE,
        tail_sequence=TEST_END_SEQUENCE
    )

    cltu_decoder = CLTUDecoder(
        start_sequence=TEST_START_SEQUENCE,
        tail_sequence=TEST_END_SEQUENCE
    )

    tc_datalink_decoder = TCDataLinkProtocolDecoder(
        spacecraft_id=TEST_SPACECRAFT_ID,
        virtual_channel_id=TEST_VIRTUAL_CHANNEL_ID,
        map_id=TEST_MAP_ID
    )

    spp_decoder = SpacePacketProtocolDecoder(apid=TEST_APID_VAL)

    return [spp_encoder, tc_datalink_encoder, cltu_encoder, cltu_decoder, tc_datalink_decoder, spp_decoder]


def test_full_spp_to_tc_channel_encode_decode(setup_encoder_decoder):
    """
    Test full flow from space packet encoding/decoding to TC channel encoding/decoding
    :return:
    """
    spp_encoder, tc_datalink_encoder, cltu_encoder, cltu_decoder, tc_datalink_decoder, spp_decoder = \
        setup_encoder_decoder

    random_data = os.urandom(MAX_BYTES_PER_PACKET * 10)
    spp_list = spp_encoder.encode_packets(random_data)
    tc_datalink_list = tc_datalink_encoder.encode_spp_list(spp_list)
    cltu_bytes = cltu_encoder.encode_tc_datalink_packets(tc_datalink_list)

    recovered_tcc_datalink_list = cltu_decoder.decode_to_tc_datalink_packets(cltu_bytes)
    recovered_spp_list = tc_datalink_decoder.decode_to_spp_packets(recovered_tcc_datalink_list)
    recovered_data = spp_decoder.decode(recovered_spp_list)
    assert(recovered_data == random_data)

def test_tc_channel_encoder_decoder_compatibility(setup_encoder_decoder):
    """
    Test that the data encoded by TC Channel encoder can be decoded properly.
    :return:
    """
    random_data = os.urandom(256)
    _, _, cltu_encoder, cltu_decoder, _, _ = setup_encoder_decoder
    expected_tc_datalink_packet = TCDataLinkPacket(
        tx_frame_version=0,
        bypass_flag=True,
        control_command_flag=ControlCommandFlag.CONTROL,
        spacecraft_id=TEST_SPACECRAFT_ID,
        virtual_channel_id=TEST_VIRTUAL_CHANNEL_ID,
        frame_seq_num=0,
        seq_flags=SegmentHeaderSequenceFlags.UNSEGMENTED,
        map_id=TEST_MAP_ID,
        data=random_data

    )

    encoded_bytestream = cltu_encoder.encode_tc_datalink_packets([expected_tc_datalink_packet])

    decoded_tc_datalink_packet_list = cltu_decoder.decode_to_tc_datalink_packets(encoded_bytestream)
    assert (len(decoded_tc_datalink_packet_list) == 1)
    assert (decoded_tc_datalink_packet_list[0] == expected_tc_datalink_packet)


def test_spp_to_datalink_compatibility(setup_encoder_decoder):
    """
    Send random data through the whole pipeline to make sure we can recover the data
    :return:
    """
    spp_encoder, tc_datalink_encoder, _, _, tc_datalink_decoder, spp_decoder = setup_encoder_decoder

    random_data = os.urandom(MAX_BYTES_PER_PACKET * 10 + 77)
    # Encode data
    # random data -> spp packets -> tc datalink packets
    spp_encoded_list = spp_encoder.encode_packets(random_data)
    tc_datalink_encoded_list = tc_datalink_encoder.encode_spp_list(spp_encoded_list)

    # Decodes data
    # tc_datalink_packets -> spp packets -> random data

    spp_decoded_list = tc_datalink_decoder.decode_to_spp_packets(tc_datalink_encoded_list)
    assert (spp_encoded_list == spp_decoded_list)
    recovered_data = spp_decoder.decode(spp_encoded_list)
    assert(recovered_data == random_data)


def test_spp_encoder_decoder_compatibility(setup_encoder_decoder):
    """
    SpacePacketDecoder should be able to decode the list of space packets from SpacePacketEncoder
    """
    spp_encoder, _, _, _, _, spp_decoder = setup_encoder_decoder
    random_data = os.urandom(MAX_BYTES_PER_PACKET * 10 + 77)
    encoded_packet_list = spp_encoder.encode_packets(random_data)
    decoded_data = spp_decoder.decode(encoded_packet_list)
    assert (decoded_data == random_data)


def test_tc_datalink_encoder_decoder_compatibility(setup_encoder_decoder):
    """
    Encode one space packet and try to decode it to make sure encoder/decoder are compatible
    :return:
    """
    _, tc_datalink_encoder, _, _, tc_datalink_decoder, _ = setup_encoder_decoder
    # The IDs are arbitrarily set
    random_data = os.urandom(256)  # generate 256 bytes of random data
    spp_list = [
        SpacePacket(
            ccsds_version=0,
            packet_type=SpacePacketType.TELECOMMAND,
            apid=TEST_APID_VAL,
            seq_flags=SpacePacketSequenceFlags.UNSEGMENTED,
            packet_seq_count=17,
            data=random_data,
            sec_hdr_flag=False
        )
    ]
    encoded_data_list = tc_datalink_encoder.encode_spp_list(spp_list)
    assert (len(encoded_data_list) == 1)

    decoded_spp_list = tc_datalink_decoder.decode_to_spp_packets(encoded_data_list)
    assert (len(decoded_spp_list) == 1)
    assert (decoded_spp_list[0] == spp_list[0])
