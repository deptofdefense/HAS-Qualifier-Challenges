#!/usr/bin/python3
import zlib
import random
import bitstring
import threading
import time
import socket
import os
import sys
import math
import struct

FLAG_APID = 100 
FLAG_INTERVAL = 4.0
EPS_APID = 108
PAYLOAD_APID = 110
PAYLOAD_INTERVAL = 2.0
HK_APID = 106


# class to put a lock around the socket so that multiple threads can use it
class socketSender:

    def __init__(self):

        self.lock = threading.Lock()

        Host = os.getenv("HOST", "localhost")
        Port = int(os.getenv("PORT", 4321))

        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect((Host, Port))


    def send(self, message):

        with self.lock:

            try:
                # sys.stdout.buffer.write( message )
                # sys.stdout.flush()

                self.sock.sendall(message)

            except:

                # sys.stderr.write("exception in sending\n")
                return False
            
        return True


class tlmSender:

    def __init__(self, APID, serversocket):

        self.enabled = False
        self.packet_version = 0
        self.packet_type = 0 #telemetry
        self.sec_header_flag = 0 # no secondary header
        self.APID = APID
        self.sequence_flags = 3 # its a complete packet, not fragmented
        self.packet_sequence_count = random.randint(1000, 10000)
        self.packet_data_length = 1

        self.socket = serversocket
        self._timer = None
        self.running = False
        self.tlmData = None # this is set to a bytes object in updateTlmData()

 
    def sendTLM(self, payload):


        self.packet_data_length = len(payload) - 1 + 4
        
        packet = bitstring.pack('uint:3, uint:1, uint:1, uint:11, uint:2, uint:14, uint:16',
            self.packet_version, self.packet_type, self.sec_header_flag, self.APID, self.sequence_flags,
            self.packet_sequence_count, self.packet_data_length)

        packethdr = packet.tobytes()

        wholepacket = packethdr + payload

        crc = zlib.crc32(wholepacket)

        print("crc = {:x}".format(crc) )

        wholepacket += struct.pack(">I", crc)
        
        self.packet_sequence_count += 1

        if not self.socket.send(wholepacket):
            return False

        return True



if __name__ == '__main__':


    sock = socketSender()

    if not sock:
        exit()

    hkSend = tlmSender(HK_APID, sock)

    tlmsend = tlmSender(EPS_APID, sock)

    flagsend = tlmSender(FLAG_APID, sock)

    appsend = tlmSender(0, sock)

    while True:

        line = sys.stdin.readline()

        line.strip('\n')

        if line[0] == '0':

            print("Sending command 0")
            tlmsend.sendTLM(b'\x00127.0.0.1:3221')

        elif line[0] == '1':

            print("Sending command 1")
            tlmsend.sendTLM(b'\x01')


        elif line[0] == '2':

            print("Sending command to HK")

            delay = int(line[1:])

            print("Sending interval command to housekeeping")

            cmd = b'\x02' + struct.pack(">H", delay)
            hkSend.sendTLM(cmd)

            print(cmd)


        elif line[0] == '3':

            print("Sending bad HK command")
            hkSend.sendTLM(b'\x00')


        elif line[0] == '4':

            print("Sending bad HK command")
            flagsend.sendTLM(b'\x00sovrysecur3')

        elif line[0] == '5':

            print("Sending bad HK command")
            flagsend.sendTLM(b'\x01sovrysecur3')

        elif line[0] == '6':

            print("Sending bad HK command")
            flagsend.sendTLM(b'\x02')

        elif line[0] == '7':

            print("Sending new interval")

            interval = int(line[1:])

            command = b'\x03' + struct.pack(">H", interval)

            flagsend.sendTLM(command)

        elif line[0] == '8':

            print("Sending bad HK command")
            flagsend.sendTLM(b'\x02')
            flagsend.sendTLM(b'\x02')
            flagsend.sendTLM(b'\x02')
            flagsend.sendTLM(b'\x02')

        elif line[0] == '9':

            appsend.sendTLM(b'\x04')
