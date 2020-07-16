#!/bin/python3

import bitstring
import os
import sys
import socket

FLAG_APID = 102
EPS_APID = 103
PAYLOAD_APID = 105


if __name__ == '__main__':
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31337))

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    

    ticket = os.getenv("TICKET", "")
    if len(ticket):
        sock.recv(128)
        sock.send((ticket + "\n").encode("utf-8"))
    #fsock = sock.makefile('rw')
    line = sock.recv(128)
    sock.close()

    Host, Port = line.split(b" ")[-1].split(b":")
    print(Host,Port)
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, int(Port)))

    while True:

        #data = sys.stdin.buffer.read(6)

        data = b''

        while len(data) < 6:
            data += sock.recv(6 - len(data))

        s = bitstring.BitArray(data)

        version, type, sec_header, apid, sequence_flags, sequence_count, data_length = s.unpack('uint:3, uint:1, uint:1, uint:11, uint:2, uint:14, uint:16')

        print("APID: {}\nLength: {}\n".format(apid, data_length))

        #data = sys.stdin.buffer.read(data_length+1)

        data = b''

        while len(data) < data_length+1:
            data += sock.recv(data_length+1 - len(data))

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


    
