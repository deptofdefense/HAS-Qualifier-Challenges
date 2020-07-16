import os
import sys
from subprocess import run
from ccsds.model.SpacePacket import SpacePacketProtocolDecoder
from ccsds.model.TMChannelCoding import TMDecoder
from ccsds.model.TCDataLinkPacket import TCDataLinkProtocolDecoder
import gzip
import random
import re

JPEG = b"\xFF\xD8\xFF\xE0\x00\x10\x4A\x46\x49\x46\x00"
START_SEQUENCE = b'\xde\xad'
TAIL_SEQUENCE = b'\xbe\xef'
APID = 1337
SPACECRAFT_ID = 80
VIRTUAL_CHANNEL_ID = 33
MAP_ID = 20
LYRIC_FILE = './resources/red_balloon_song.txt'


def demodulate(infile, outfile):
    stdout_log = open("./logs/stdout", 'a')
    stderr_log = open("./logs/stderr", 'a')
    run(["python2",  "demod.py", infile, outfile], stdout=stdout_log, stderr=stderr_log)
    stdout_log.close()
    stderr_log.close()


def convert_bit_stream(infile, outfile):
    stdout_log = open("./logs/stdout", 'a')
    stderr_log = open("./logs/stderr", 'a')
    run(["python2",  "convert.py", infile, outfile], stdout=stdout_log, stderr=stderr_log)
    stdout_log.close()


def solve_challenge(data):
    tm_decoder = TMDecoder()
    tc_datalink_decoder = TCDataLinkProtocolDecoder(
        spacecraft_id=SPACECRAFT_ID,
        virtual_channel_id=VIRTUAL_CHANNEL_ID,
        map_id=MAP_ID
    )
    spp_decoder = SpacePacketProtocolDecoder(apid=APID)

    recovered_tcc_datalink_list = tm_decoder.decode_to_tc_datalink_packets(data)
    recovered_spp_list = tc_datalink_decoder.decode_to_spp_packets(recovered_tcc_datalink_list)
    msg_song = spp_decoder.decode(recovered_spp_list)
    with open(LYRIC_FILE, 'r') as fh:
        song = fh.read()
    msg = msg_song[int(len(song)/2):int(-len(song)/2)]
    res = gzip.decompress(msg)

    return res


if __name__ == "__main__":

    Ticket = os.getenv("TICKET", "")
    filename = os.getenv("DIR", "/mnt" ) + "/challenge.wav"
    temp_filename = "/tmp/{}".format(filename.split("/")[-1])
    new_temp_filename = "/tmp/1_{}".format(filename.split("/")[-1])

    demodulate(filename, temp_filename)
    convert_bit_stream(temp_filename, new_temp_filename)
    with open(new_temp_filename, 'rb') as fh:
        data = fh.read()
    res = solve_challenge(data)
    with open("/mnt/flag", 'wb') as fh:
        fh.write(res)

    lines = res.splitlines()
    tle_dict = {}

    for i in range(0, len(lines), 3):
        name = lines[i]
        norad_number = lines[i+1][9:17]
        tle_dict[norad_number] = name
    flag_file = b""
    for element in sorted(tle_dict):
        flag_file += tle_dict[element]

    with open("/mnt/result.txt", 'wb') as fh:
        fh.write(flag_file)

    m = re.search(b"(flag{.+})", flag_file)
    if m:
        print(m.group(1))
    else:
        print("Error: Flag not found in result")
        sys.exit(1)
