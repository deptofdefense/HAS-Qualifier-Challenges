#!/opt/venv/bin/python

import os
import sys
import socket
import struct
import random



if __name__ == '__main__':
    Host = "localhost"
    Port = 4444

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    

    sock.bind((Host, Port))

    platform_c_maxint = 2 ** (struct.Struct('Q').size * 8 - 1) - 1

    while True:

        data, addr = sock.recvfrom(1024)

        print("Received Request from {} for {}".format(addr, data))
        
        response = b''

        if data[0:6] == b'STATUS':

            print("Sending status")

            for _ in range(0,10):
                value1 = random.randint(0, platform_c_maxint)

                response += struct.pack("Q", value1)

        elif data == b'DUMP':

            for _ in range(0,100):
                value1 = random.randint(0, platform_c_maxint)

                response += struct.pack("Q", value1)

        sock.sendto(response, addr)

