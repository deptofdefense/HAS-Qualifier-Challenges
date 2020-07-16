#!/opt/venv/bin/python

import os
import sys
import socket
import struct
import random


if __name__ == '__main__':
    Host = "localhost"
    Port = 6667

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    sock.bind((Host, Port))

    platform_c_maxint = 2 ** (struct.Struct('I').size * 8 - 1) - 1

    while True:

        data, addr = sock.recvfrom(1024)

        print("EPS: Received Request from {} for {}".format(addr, data))
        
        response = b''

        if data == b'PING':

            print("Sending status")

            response = b'PONG'

        elif data == b'TELEMETRY':

            for _ in range(0,5):
                value1 = random.randint(0, platform_c_maxint)

                response += struct.pack("I", value1)

        sock.sendto(response, addr)