# Given an input file, generate a ccsds.bin file that encodes the bytestream
from ccsds.model.SpacePacket import SpacePacketProtocolEncoder, SpacePacketType, SpacePacketProtocolDecoder
from ccsds.model.TCChannelCoding import CLTUEncoder, CLTUDecoder
from ccsds.model.TCDataLinkPacket import TCDataLinkProtocolEncoder, ControlCommandFlag, TCDataLinkProtocolDecoder
from tletools import TLE

import random
import sys

TEST_INPUT_FILE = './space_oddity.txt'
TEST_FLAG_FILE = sys.argv[1]
TEST_OUTPUT_FILE = './recovered_data.txt'
TEST_OUTPUT_BINARY_FILE = sys.argv[2]

# Instantiate SpacePacket Encoder, TC DataLink Encoder and TC Channel Encoder
# Encode the bytes this way:
# file bytes -> list of space packets -> list of datalink packets -> list of channel frames

spp_encoder = SpacePacketProtocolEncoder(
    packet_type=SpacePacketType.TELECOMMAND,    # indicate direction of transmission (ground station -> satellite)
    apid=1337                                   # unique identifier of application process, must be < 2047
)

tc_datalink_encoder = TCDataLinkProtocolEncoder(
    control_command_flag=ControlCommandFlag.CONTROL,    # indicate that information is encoded
    spacecraft_id=80,                                   # unique identifier of spacecraft, must be < 1024
    virtual_channel_id=33,                              # another unique identifier, < 64
    map_id=20                                           # yet another unique identifier, < 64
)

cltu_encoder = CLTUEncoder(
    start_sequence=b'\xde\xad',                         # indicates start of transmission unit, must be 16bits
    tail_sequence=b'\xbe\xef'                           # indicates end of transmission unit, must be 16bits
)

input_flag_data = b''
with open(TEST_FLAG_FILE, 'rb') as f:
    input_flag_data = f.read()

with open(TEST_INPUT_FILE, 'rb') as f:
    #the TLE Packet is in ascii format

    tle = """
    ISS (ZARYA)
    1 25544U 98067A   19249.04864348  .00001909  00000-0  40858-4 0  9990
    2 25544  51.6464 320.1755 0007999  10.9066  53.2893 15.50437522187805
    """

    adm = """
    CCSDS_APM_VERS = 1.0
    CREATION_DATE = 2003-09-30T19:23:57
    ORIGINATOR = GSFC
    COMMENT GEOCENTRIC, CARTESIAN, EARTH FIXED
    COMMENT OBJECT_ID: 1997-009A
    COMMENT $ITIM = 1997 NOV 21 22:26:18.40000000, $ original launch time
    OBJECT_NAME = TRMM
    OBJECT_ID = 1997-009A
    CENTER_NAME = EARTH
    TIME_SYSTEM = UTC
    COMMENT Current attitude for orbit 335
    COMMENT Attitude state quaternion
    COMMENT Accuracy of this attitude is 0.02 deg RSS.
    EPOCH = 2003-09-30T14:28:15.1172
    Q_FRAME_A = SC_BODY_1
    Q_FRAME_B = ITRF-97
    Q_DIR = A2B
    Q1 = 0.00005
    Q2 = 0.87543
    Q3 = 0.40949
    QC = 0.25678 
    """

    tle_spp_list = spp_encoder.encode_packets(bytes(tle.encode("ascii")))                      # encode data into space
    tle_tc_datalink_list = tc_datalink_encoder.encode_spp_list(tle_spp_list)

    adm_spp_list = spp_encoder.encode_packets(bytes(adm.encode("ascii")))

    adm_tc_datalink_list = tc_datalink_encoder.encode_spp_list(adm_spp_list)

    tc_datalink_list = tle_tc_datalink_list + adm_tc_datalink_list

    cltu_bytes = cltu_encoder.encode_tc_datalink_packets(tc_datalink_list)  # encode datalink packets to frames

    with open(TEST_OUTPUT_BINARY_FILE, 'wb') as g:
        g.write(cltu_bytes)

"""
The challenge is generated up to this point, the folllowing code is to recover the file once the bytestream is 
recovered
"""

# start and tail sequence must be the same as the cltu encoder
cltu_decoder = CLTUDecoder(
    start_sequence=b'\xde\xad',
    tail_sequence=b'\xbe\xef'
)

# spacecraft, virtual channel and map ID must be the same as the tc datalink encoder
tc_datalink_decoder = TCDataLinkProtocolDecoder(
    spacecraft_id=80,
    virtual_channel_id=33,
    map_id=20
)

# APID must be the same as spp encoder
spp_decoder = SpacePacketProtocolDecoder(apid=1337)


with open(TEST_OUTPUT_BINARY_FILE, 'rb') as f:
    recovered_bytes = f.read()
    recovered_tcc_datalink_list = cltu_decoder.decode_to_tc_datalink_packets(cltu_bytes)    # recover tc datalink
    new_recovered_tcc_datalink_list = [None] * len(recovered_tcc_datalink_list)
    # recover order of the mixed up datalink list
    for p in recovered_tcc_datalink_list:
        new_recovered_tcc_datalink_list[p.frame_seq_num] = p
    # recover space packets
    recovered_spp_list = tc_datalink_decoder.decode_to_spp_packets(new_recovered_tcc_datalink_list)
    recovered_data = spp_decoder.decode(recovered_spp_list) # recover original data

    with open(TEST_OUTPUT_FILE, 'wb') as g:
        g.write(recovered_data)
