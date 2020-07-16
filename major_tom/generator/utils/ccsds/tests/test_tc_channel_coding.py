from ccsds.model.TCChannelCoding import CLTUEncoder
from ccsds.model.TCDataLinkPacket import TCDataLinkPacket, ControlCommandFlag, SegmentHeaderSequenceFlags


def test_tc_channel_coding_tc_datalink_packets():
    """
    Test TC Channel Encoder encoding a datalink packet
    :return:
    """

    spacecraft_id = 1000
    virtual_channel_id = 10
    map_id = 20

    data = b'\x01\x02\x03\x04\x05\x06\x07\x08\x09\x10'

    tc_datalink_packet = TCDataLinkPacket(
        tx_frame_version=0,
        bypass_flag=True,
        control_command_flag=ControlCommandFlag.CONTROL,
        spacecraft_id=spacecraft_id,
        virtual_channel_id=virtual_channel_id,
        frame_seq_num=0,
        seq_flags=SegmentHeaderSequenceFlags.UNSEGMENTED,
        map_id=map_id,
        data=data
    )

    start_sequence = b'\xca\xfe'
    tail_sequence = b'\xba\xbe'
    cltu_encoder = CLTUEncoder(
        start_sequence=start_sequence,
        tail_sequence=tail_sequence
    )
    final_byte_sequence = cltu_encoder.encode_tc_datalink_packets([tc_datalink_packet])


def test_tc_channel_coding_random_payload():
    """
    Test TC Channel Encoder with random data
    :return:
    """
    data = b'\xde\xad\xbe\xef'
    start_sequence = b'\xca\xfe'
    tail_sequence = b'\xba\xbe'
    cltu_encoder = CLTUEncoder(
        start_sequence=start_sequence,
        tail_sequence=tail_sequence
    )
    # 0xfe is parity bit + 1 filler bit
    # 3 \x00 are filler bytes
    expected_byte_sequence = start_sequence + data + b'\x55' * 3 + b'\xfe' + tail_sequence
    final_byte_sequence = cltu_encoder.encode_bytes(data)
    assert (expected_byte_sequence == final_byte_sequence)

