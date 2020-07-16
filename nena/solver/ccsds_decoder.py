# Given an input file, generate a ccsds.bin file that encodes the bytestream
from ccsds.model.SpacePacket import SpacePacketProtocolEncoder, SpacePacketType, SpacePacketProtocolDecoder
from ccsds.model.TCChannelCoding import CLTUEncoder, CLTUDecoder
from ccsds.model.TCDataLinkPacket import TCDataLinkProtocolEncoder, ControlCommandFlag, TCDataLinkProtocolDecoder
import sys

TEST_INPUT_FILE = './red_balloon_song.txt'
TEST_OUTPUT_FILE = './recovered_data.txt'
TEST_OUTPUT_BINARY_FILE = './ccsds.bin'
START_SEQUENCE = b'\xde\xad'
TAIL_SEQUENCE = b'\xbe\xef'
APID = 1337
SPACECRAFT_ID = 80
VIRTUAL_CHANNEL_ID = 33
MAP_ID = 20

# Instantiate SpacePacket Encoder, TC DataLink Encoder and TC Channel Encoder
# Encode the bytes this way:
# file bytes -> list of space packets -> list of datalink packets -> list of channel frames

class CCSDS_Decoder():
    def __init__(self, apid=APID, spacecraft_id=SPACECRAFT_ID, virtual_channel_id=VIRTUAL_CHANNEL_ID, map_id=MAP_ID,
                 start_sequnce=START_SEQUENCE, tail_sequence=TAIL_SEQUENCE):
        # start and tail sequence must be the same as the cltu encoder
        self.cltu_decoder = CLTUDecoder(
            start_sequence=START_SEQUENCE,
            tail_sequence=TAIL_SEQUENCE
        )
        # spacecraft, virtual channel and map ID must be the same as the tc datalink encoder
        self.tc_datalink_decoder = TCDataLinkProtocolDecoder(
            spacecraft_id=SPACECRAFT_ID,
            virtual_channel_id=VIRTUAL_CHANNEL_ID,
            map_id=MAP_ID
        )
        # APID must be the same as spp encoder
        self.spp_decoder = SpacePacketProtocolDecoder(apid=APID)
    
    def decode_data(self, data):
        recovered_tcc_datalink_list = self.cltu_decoder.decode_to_tc_datalink_packets(data)    # recover tc
        # datalink
        recovered_spp_list = self.tc_datalink_decoder.decode_to_spp_packets(recovered_tcc_datalink_list) # recovere
        # space packets
        ret = self.spp_decoder.decode(recovered_spp_list) # recover original data
        return ret

if  __name__ == "__main__":
    dec = CCSDS_Decoder()
    with open(sys.argv[2], 'wb') as fh1:
        with open(sys.argv[1], 'rb') as fh2:
            fh1.write(dec.decode_data(fh2.read()))
