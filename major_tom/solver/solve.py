from ccsds.model.SpacePacket import SpacePacketProtocolEncoder, SpacePacketType, SpacePacketProtocolDecoder
from ccsds.model.TCChannelCoding import CLTUEncoder, CLTUDecoder
from ccsds.model.TCDataLinkPacket import TCDataLinkProtocolEncoder, ControlCommandFlag, TCDataLinkProtocolDecoder
import os
import sys
from subprocess import run
import random
from bitstring import BitStream, BitArray

START_SEQUENCE = b'\xde\xad'
TAIL_SEQUENCE = b'\xbe\xef'
JPEG = b"\xFF\xD8\xFF\xE0\x00\x10\x4A\x46\x49\x46\x00"
APID = 1337
SPACECRAFT_ID = 80
VIRTUAL_CHANNEL_ID = 33
MAP_ID = 20

# temporary for testing with static flag value
ZULU = "0xbeefdead"

bitmappings = [ 
    [ 0, 1, 2, 3],
    [ 0, 1, 3, 2],
    [ 0, 2, 1, 3],
    [ 0, 2, 3, 1],
    [ 0, 3, 1, 2],
    [ 0, 3, 2, 1],
    [ 1, 0, 2, 3],
    [ 1, 0, 3, 2],
    [ 1, 2, 0, 3],
    [ 1, 2, 3, 0],
    [ 1, 3, 0, 2],
    [ 1, 3, 2, 0],
    [ 2, 0, 1, 3],
    [ 2, 0, 3, 1],
    [ 2, 1, 0, 3],
    [ 2, 1, 3, 0],
    [ 2, 3, 0, 1],
    [ 2, 3, 1, 0],
    [ 3, 0, 1, 2],
    [ 3, 0, 2, 1],
    [ 3, 1, 0, 2], 
    [ 3, 1, 2, 0],
    [ 3, 2, 0, 1],
    [ 3, 2, 1, 0]
]


def find_mapping(infile, outfile):


    stream = BitStream()

    with open(infile) as f:
        byte = f.read(1)
        while byte:
            if byte == '\x01':
                stream.append('0b1')
            else:
                stream.append('0b0')
            byte = f.read(1)

    iteration = 0
    for mapping in bitmappings:

        stream.pos = 0
        tmpstream = BitStream()

        for pie in stream.cut(2):

            index = pie.read('uint:2')

            tmpstream.append( BitArray(uint=mapping[index], length=2) )


    # look for the start of the flag in the stream of bits
        pos = tmpstream.find(ZULU)

        if len(pos) > 0:

            # print("Found the bytes we are looking for on iteration {}".format(iteration))
            # print("pos = {}".format(pos))

            tmpstream <<= pos[0] % 8
            data = tmpstream.tobytes()

            # print(data)
            with open(outfile, 'wb') as fh:
                fh.write(data)

            break
        else:
            # print("Did not find the header")
            iteration += 1



def demodulate(infile, outfile):
    stdout_log = open("./logs/stdout", 'a')
    stderr_log = open("./logs/stderr", 'a')
    run(["python2",  "demod.py", infile, outfile], stdout=stdout_log, stderr=stderr_log)
    # run(["python2",  "demod.py", infile, outfile])
    stdout_log.close()
    stderr_log.close()


def convert_bit_stream(infile, outfile):
    stdout_log = open("./logs/stdout", 'a')
    stderr_log = open("./logs/stderr", 'a')
    run(["python2",  "convert.py", infile, outfile], stdout=stdout_log, stderr=stderr_log)
    stdout_log.close()


def solve_challenge(data):
    cltu_decoder = CLTUDecoder(
        start_sequence=START_SEQUENCE,
        tail_sequence=TAIL_SEQUENCE
    )
    tc_datalink_decoder = TCDataLinkProtocolDecoder(
        spacecraft_id=SPACECRAFT_ID,
        virtual_channel_id=VIRTUAL_CHANNEL_ID,
        map_id=MAP_ID
    )
    spp_decoder = SpacePacketProtocolDecoder(apid=APID)

    recovered_tcc_datalink_list = cltu_decoder.decode_to_tc_datalink_packets(data)
    recovered_spp_list = tc_datalink_decoder.decode_to_spp_packets(recovered_tcc_datalink_list)
    ret = spp_decoder.decode(recovered_spp_list)
    return ret


if __name__ == "__main__":
    Ticket = os.getenv("TICKET", "")
    inputdir = os.getenv("DIR", "/mnt")
    filename = inputdir + os.sep + "challenge.wav"

    temp_filename = "/tmp/{}".format(filename.split("/")[-1])
    new_temp_filename = "/tmp/new_{}".format(filename.split("/")[-1])
    demodulate(filename, temp_filename)

    find_mapping(temp_filename, new_temp_filename)
    # convert_bit_stream(temp_filename, new_temp_filename)

    with open(new_temp_filename, 'rb') as fh:
        data = fh.read()

    res = solve_challenge(data)

    start_pos = res.find(b'flag')

    if start_pos > 0:

        print("Success: challenge solved.")

        end_pos = res[start_pos:].find(b'}')

        print(res[start_pos: start_pos+end_pos + 1])

        sys.exit(0)
    else:
        sys.exit(1)
