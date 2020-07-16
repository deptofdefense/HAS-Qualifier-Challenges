#!/opt/venv/bin/python

import os
import sys
import socket
import struct
import random
import datetime


if __name__ == '__main__':
    Host = "localhost"
    Port = 5555
    Flag = os.getenv("FLAG", "flag{blahblahblah}")

    startup_time = datetime.datetime.now()

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    sock.bind((Host, Port))


    while True:

        data, addr = sock.recvfrom(1024)

        print("Received Request from {} for {}".format(addr, data))

        response = b''

        if data[0:6] == b'STATUS':

            # send some stats, e.g. uptime,
            sock.sendto(b'FLAG APP FINE', addr)

        elif data[0:4] == b'FLAG':

            sock.sendto(Flag.encode('utf-8'), addr)

        elif data[0:8] == b'SHUTDOWN':

            sock.sendto(b"SHUTDOWN OK", addr)
            break;
        else:
            sock.sendto(b"WHAT?", addr)




