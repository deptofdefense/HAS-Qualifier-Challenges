from ccsds.model.SpacePacket import SpacePacketProtocolEncoder, SpacePacketType
from ccsds.model.TMChannelCoding import TMEncoder
from ccsds.model.TCDataLinkPacket import TCDataLinkProtocolEncoder, ControlCommandFlag
import sys
import os
import random
from subprocess import run
import gzip

FAKE_FLAG = b'This is not a flag\x00\x00\x00'

IMAGE_FILE = "./resources/satellite.jpg"
LYRIC_FILE = './resources/red_balloon_song.txt'
TLE_LOC = "./resources/tles.txt"

seed = os.getenv("SEED", "0")
random.seed(seed)

flag = os.getenv("FLAG", "flag{PLACEHOLDER}")


def tle_hide_flag():
    with open(TLE_LOC, 'rb') as fh:
        data = str(fh.read())
    lines = data.split("\\n")
    tles = []
    j = 0
    with open(LYRIC_FILE, 'r') as fh:
        song = "".join(fh.read().splitlines())
    flag_pad = "".join([("U" * 48), song[:int(len(song)/2)], flag, song[int(len(song)/2):], ("U" * 48)])
    for i in range(0, len(lines) - 1, 3):
        name = flag_pad[j:j+24]
        j += 24
        lines1 = lines[i+1]
        lines2 = lines[i+2]
        tles.append("\n".join([name, lines1, lines2]))
        if j + 24 >= len(flag_pad):
            break
    random.shuffle(tles)
    return "\n".join(tles)

def inject_errors(data):
    with open("/mnt/pre_error", 'wb') as fh:
        fh.write(data)
    rate = 800 # random.randint(200,250)
    input_data_list = []
    # Inject Errors
    for i in data:
        input_data_list.append(bytes([i]))
    for i in range(int(rate/2), len(input_data_list) - rate, rate*2):
        index = i + random.randint(0, rate)
        original = int.from_bytes(input_data_list[index], "little")
        mask1 = 1 << random.randint(0,7)
        mask2 = 1 << random.randint(0,7)
        choices = [ original,  original ^ mask1 , original ^ mask2 ]
        input_data_list[index] = bytes([random.choice(choices)])

    data =  b"".join(input_data_list)
    with open("/mnt/post_error", 'wb') as fh:
        fh.write(data)
    return data


def build_challenge(data):
    gz_data = gzip.compress(data.encode("ascii"))
    with open(LYRIC_FILE, 'rb') as fh:
        song = fh.read()
    song_data = b"".join([song[:int(len(song)/2)], gz_data, song[int(len(song)/2):]])
    spp_encoder = SpacePacketProtocolEncoder(
        packet_type=SpacePacketType.TELEMETRY,  # indicate direction of transmission (ground station -> satellite)
        apid=1337  # unique identifier of application process, must be < 2047
    )

    tc_datalink_encoder = TCDataLinkProtocolEncoder(
        control_command_flag=ControlCommandFlag.CONTROL,  # indicate that information is encoded
        spacecraft_id=80,  # unique identifier of spacecraft, must be < 1024
        virtual_channel_id=33,  # another unique identifier, < 64
        map_id=20  # yet another unique identifier, < 64
    )

    tm_encoder = TMEncoder()

    # Encode Flag
    # Space Packets
    spp_list_flag = spp_encoder.encode_packets(song_data)

    # Datalink Packets
    tc_datalink_list_flag = tc_datalink_encoder.encode_spp_list(spp_list_flag)
    random.shuffle(tc_datalink_list_flag)
    # Uplink
    tm_bytes = tm_encoder.encode_tc_datalink_packets(tc_datalink_list_flag)  # encode datalink packets to frames

    return inject_errors(tm_bytes)

def generate_fake_flag(data):
    # generate a fake flag base on the length of the data
    data_length = len(data)
    num_repeats = len(data) / len(FAKE_FLAG)
    return FAKE_FLAG * int(num_repeats)

def preprocess_data(data):
    # pad data with zeros
    return b'\x00' * 200 + data + b'\x00' * 200

def modulate(infile, infile_fake, outfile):
    stdout_log = open("./logs/stdout", 'a')
    stderr_log = open("./logs/stderr", 'a')
    run(["python2",  "mod.py", infile, infile_fake, outfile], stdout=stdout_log, stderr=stderr_log)
    stdout_log.close()
    stderr_log.close()


if __name__ == "__main__":

    # specify output file
    #fileid = random.randint(0, 0xfffff)
    filename = "challenge.wav"
    outdir = os.getenv("DIR", "/mnt")
    mounted_filename =  outdir + os.sep + filename

    tle_flags = tle_hide_flag()

    # generate padded challenge data
    flag_data_file = "/tmp/challenge.wav"
    challenge_data = preprocess_data(build_challenge(tle_flags))
    with open(flag_data_file, 'wb') as f:
        f.write(challenge_data)

    # modulate the fake flag and actual flag together to output_file
    modulate(flag_data_file, flag_data_file, mounted_filename)

    sys.stdout.write(mounted_filename + "\n")
