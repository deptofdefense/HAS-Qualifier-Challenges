from ccsds.model.SpacePacket import SpacePacketProtocolEncoder, SpacePacketType, SpacePacketProtocolDecoder
from ccsds.model.TCChannelCoding import CLTUEncoder, CLTUDecoder
from ccsds.model.TCDataLinkPacket import TCDataLinkProtocolEncoder, ControlCommandFlag, TCDataLinkProtocolDecoder
# from PIL import Image
# from PIL import ImageFont
# from PIL import ImageDraw
import random
import sys
import os
from subprocess import run

IMAGE_FILE = "./resources/satellite.jpg"
LYRIC_FILE = './resources/space_oddity.txt'

flag = os.getenv("FLAG", "{}".format("1234567890123" * 10))
seed = os.getenv("SEED", "0")
random.seed(seed)

# def overlay_flag(image):
#     res = 'flag.jpg'
#     img = Image.open(image)
#     draw = ImageDraw.Draw(img)
#     font = ImageFont.truetype("./resources/Roboto-Light.ttf", 16)
#     j = 0
#     for i in range(0, int(len(flag)/24), 1):
#         draw.text((0, i  * 16), flag[i*24: (i+1)*24],(255,255,255),font=font)
#         j = i
#     j += 1
#     draw.text((0, j * 16), flag[j * 24: len(flag)], (255, 255, 255), font=font)
#     img.save(res)
#     return res

def preprocess_data(data):
    return b'\x00\xff' * 100 + data + b'\x00\xff' * 100


def build_challenge(input_flag_data):
    spp_encoder = SpacePacketProtocolEncoder(
        packet_type=SpacePacketType.TELECOMMAND,  # indicate direction of transmission (ground station -> satellite)
        apid=1337  # unique identifier of application process, must be < 2047
    )

    tc_datalink_encoder = TCDataLinkProtocolEncoder(
        control_command_flag=ControlCommandFlag.CONTROL,  # indicate that information is encoded
        spacecraft_id=80,  # unique identifier of spacecraft, must be < 1024
        virtual_channel_id=33,  # another unique identifier, < 64
        map_id=20  # yet another unique identifier, < 64
    )

    cltu_encoder = CLTUEncoder(
        start_sequence=b'\xde\xad',  # indicates start of transmission unit, must be 16bits
        tail_sequence=b'\xbe\xef'  # indicates end of transmission unit, must be 16bits
    )

    with open(LYRIC_FILE, 'rb') as f:
        input_data = f.read()

    first_half_song = input_data[0:int(len(input_data)/2)]
    second_half_song = input_data[int(len(input_data)/2):]

    # Encode Flag
    # Space Packets
    spp_list_first = spp_encoder.encode_packets(first_half_song)                       # encode data into space packets
    spp_list_second = spp_encoder.encode_packets(second_half_song)
    spp_list_flag = spp_encoder.encode_packets(input_flag_data)
    spp_list = spp_list_first + spp_list_flag + spp_list_second

    # Datalink Packets
    tc_datalink_list_first = tc_datalink_encoder.encode_spp_list(spp_list_first)
    tc_datalink_list_flag = tc_datalink_encoder.encode_spp_list(spp_list_flag)
    random.shuffle(tc_datalink_list_flag)
    tc_datalink_list_second = tc_datalink_encoder.encode_spp_list(spp_list_second)
    tc_datalink_list = tc_datalink_list_first + tc_datalink_list_flag + tc_datalink_list_second

    # Uplink
    cltu_bytes = cltu_encoder.encode_tc_datalink_packets(tc_datalink_list)  # encode datalink packets to frames

    return cltu_bytes

def modulate(infile, outfile):
    stdout_log = open("./logs/stdout", 'a')
    stderr_log = open("./logs/stderr", 'a')
    run(["python2",  "mod.py", infile, outfile], stdout=stdout_log, stderr=stderr_log)
    stdout_log.close()
    stderr_log.close()
    # run(["python2",  "mod.py", infile, outfile])

if __name__ == "__main__":
    filename = "challenge.wav"
    tmp_filename = "/tmp/{}".format(filename)
    outdir = os.getenv("DIR", "/mnt")
    filename = outdir + os.sep + filename

    # flag_img = overlay_flag(IMAGE_FILE)
    # with open (flag_img, 'rb') as fh:
    #     image_data = fh.read()

    image_data = flag.encode('utf-8')

    with open(tmp_filename, 'wb') as fh:
        fh.write(preprocess_data(build_challenge(image_data)))
    modulate(tmp_filename, filename)

    sys.stdout.write(filename + "\n")

