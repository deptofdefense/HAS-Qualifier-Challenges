#!/bin/python3

import random
import bitstring
import threading
import time
import socket
import os
import sys
import math
import struct
import signal


FLAG_APID = 102
FLAG_INTERVAL = 4.0
EPS_APID = 103
EPS_INTERVAL = 2.0
PAYLOAD_APID = 105
PAYLOAD_INTERVAL = 2.0

MAX_FLAG_LENGTH = 5 + 22 + 73  # 'flag{' + 'november12345november:' + <remainder of flag>


def logging(message):

    sys.stderr.write("{}\n".format(message))

# class to put a lock around the socket so that multiple threads can use it
class socketSender:

    def __init__(self, s):

        self.lock = threading.Lock()
        self._socket = s

    def send(self, message):

        with self.lock:

            try:
                # sys.stdout.buffer.write( message )
                # sys.stdout.flush()

                self._socket.send(message)

            except:

                # sys.stderr.write("exception in sending\n")
                return False
            
        return True

class tlmSender:

    def __init__(self, APID, interval, serversocket):

        self.enabled = False
        self.packet_version = 0
        self.packet_type = 0 #telemetry
        self.sec_header_flag = 0 # no secondary header
        self.APID = APID
        self.sequence_flags = 3 # its a complete packet, not fragmented
        self.packet_sequence_count = random.randint(1000, 10000)
        self.packet_data_length = 1

        self.socket = serversocket
        self.interval = interval
        self._timer = None
        self.running = False
        self.tlmData = None # this is set to a bytes object in updateTlmData()

    # subclasses must define this for their particular telemetry

    def enable(self):

        self.enabled = True

    def disable(self):

        self.enabled = False

    def updateTlmData(self):

        return True

    def __call__(self):

        self.running = False
        if not self.updateTlmData():

            return
            

        if self.sendTLM():
            self.start()
            # sys.stderr.write("sent telemety for APID {}\n".format(self.APID))      

    def start(self):

        if self.running:
            return

        self._timer = threading.Timer(self.interval, self)
        self._timer.start()
        self.running = True


    def stop(self):

        if self._timer is not None:

            self._timer.cancel()

    def sendTLM(self):

        if not self.enabled:
            return True

        if self.tlmData is None:
            sys.stderr.write("no telemtry for APID {}\n".format(self.APID))
            return False

        self.packet_data_length = len(self.tlmData) - 1
        
        packet = bitstring.pack('uint:3, uint:1, uint:1, uint:11, uint:2, uint:14, uint:16',
            self.packet_version, self.packet_type, self.sec_header_flag, self.APID, self.sequence_flags,
            self.packet_sequence_count, self.packet_data_length)

        packethdr = packet.tobytes()

        wholepacket = packethdr + self.tlmData

        self.packet_sequence_count += 1

        if not self.socket.send(wholepacket):
            return False

        return True

class payloadTLM(tlmSender):

    def __init__(self, thesocket):

        super().__init__(PAYLOAD_APID, PAYLOAD_INTERVAL, thesocket)

        self.payloaddata = bytearray(random.getrandbits(8) for _ in range(12))

        self.tlmData = self.payloaddata

    def updateTlmData(self):

        self.payloaddata = bytearray(random.getrandbits(8) for _ in range(12))

        self.tlmData = self.payloaddata

        return True


class epsTLM(tlmSender):

    def __init__(self, serversocket, controlledSubsystems):


        super().__init__(EPS_APID, EPS_INTERVAL, serversocket)

        self.count = 0
        self.controlledSubsystems = controlledSubsystems
        self.battery_temp = 85.0
        self.battery_voltage = 11.5
        self.battery_heater = 0 
        self.low_power = 0
        self.low_power_threshold = 11.75
        self.payload_power = 1
        self.flag_power = 1
        self.adcs_power = 1
        self.radio1_power = 1
        self.radio2_power = 0


    def updateTlmData(self):

        self.count += 1

        if self.count*self.interval >= TIMEOUT:

            for subsystem in self.controlledSubsystems:
                subsystem.stop()

            return False

        if self.battery_heater:

            self.battery_temp += 1.5

        else:

            self.battery_temp -= .75


        if self.battery_temp > 90.0:

            self.battery_heater = 0

        elif self.battery_temp < 75.0:

            self.battery_heater = 1

        curve_value = math.sin(self.count/10)

        battery_voltage = self.battery_voltage + curve_value

        if battery_voltage < self.low_power_threshold and self.low_power == 0:
            self.low_power = 1

            self.flag_power = 0
            self.payload_power = 0

            for subsystem in self.controlledSubsystems:

                subsystem.disable()

        elif battery_voltage >= self.low_power_threshold and self.low_power == 1:
            self.low_power = 0
            self.flag_power = 1
            self.payload_power = 1
            for subsystem in self.controlledSubsystems:

                subsystem.enable()

        power_flags = (self.low_power << 7 | self.battery_heater << 6 | self.payload_power << 5 | self.flag_power << 4 |
                    self.adcs_power <<3 | self.radio1_power <<2 | self.radio2_power <<1 ) & 0xff

        battery_voltage_encoded = int((battery_voltage-10) * 100) & 0xff

        low_power_threshold_encoded = int((self.low_power_threshold-10) * 100) & 0xff
        battery_temp_encoded = int(self.battery_temp * 10)
        
        self.tlmData = struct.pack(">HHHB", battery_temp_encoded, battery_voltage_encoded, low_power_threshold_encoded, power_flags)

        # self.tlmData = b'\x00\x01\x02\x7f'

        return True

class flagTLM(tlmSender):

    def __init__(self, serversocket):


        super().__init__(FLAG_APID, FLAG_INTERVAL, serversocket)

        flag = os.getenv('FLAG', "FLAG{Placeholder}")

        flagbits = bitstring.BitArray()
        
        flagbytes = flag.encode()

        flagbytes += b'\x00'*(MAX_FLAG_LENGTH - len(flagbytes))

        for character in flagbytes:
            flagbits+=bitstring.pack('uint:7', character)

        self.tlmData = flagbits.tobytes()

def timeout_exit(signum, frame):

    logging("timed out")
    sys.exit(-1)


def quick_exit(signum, frame):

    sys.exit(0)


if __name__ == '__main__':


    TIMEOUT = int(os.getenv("TIMEOUT",15))

    HOST = os.getenv("SERVICE_HOST", '0.0.0.0')
    PORT = os.getenv("SERVICE_PORT", 8124)

    print("Telemetry Service running at {}:{}".format(HOST, PORT))
    sys.stdout.flush()

    signal.signal(signal.SIGALRM, timeout_exit)
    signal.signal(signal.SIGINT, quick_exit)
    signal.alarm(TIMEOUT)

    theSeed=os.getenv('SEED', 0)
    random.seed(theSeed)

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('0.0.0.0',8123))
    s.listen(5)

    while True:

        (clientsocket, address) = s.accept()

        sock = socketSender(clientsocket)

        # sys.stderr.write("creating the payload sender\n")
        payload = payloadTLM(sock)
        payload.enable()
        payload.start()

        # sys.stderr.write("creating Flag sender\n")
        t = flagTLM(sock)
        t.start()

        # sys.stderr.write("creating EPS sender\n")
        eps = epsTLM(sock, [payload, t])
        eps.enable()
        eps.start()
