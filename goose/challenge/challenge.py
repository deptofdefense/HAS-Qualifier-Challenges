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
import datetime
import signal

FLAG_APID = 102
FLAG_INTERVAL = 4.0
EPS_APID = 103
EPS_INTERVAL = 2.0
PAYLOAD_APID = 105
PAYLOAD_INTERVAL = 2.0


MAX_FLAG_LENGTH = 5 + 22 + 73  # 'flag{' + 'november12345november:' + <remainder of flag>


def logging(message):

    sys.stderr.write(message + '\n')
    sys.stderr.flush()


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
        self.command_error_count = 0
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
        self._timer.daemon = True
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

        # logging("Length of whole frame = {}".format(len(wholepacket)))

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
        self.battery_heater_enable = 1
        self.battery_heater = 0 
        self.low_power = 0
        self.payload_power = 0
        self.flag_power = 0
        self.adcs_power = 1
        self.radio1_power = 1
        self.radio2_power = 1

        # setable parameters
        self.payload_enable = 1           # 0
        self.flag_enable = 0              # 2
        self.adcs_enable = 1              # 4
        self.radio1_enable = 1            # 5
        self.radio2_enable = 1            # 8
        self.low_power_threshold = 13.00  # 12

    def updateTlmData(self):

        self.count += 1

        logging("flag_enable = {}".format(self.flag_enable))
        logging("payload_enable = {}".format(self.payload_enable))

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

        elif self.battery_temp < 75.0 and self.battery_heater_enable == 1:

            self.battery_heater = 1
        else:
            self.battery_heater = 0


        curve_value = math.sin(self.count/10)

        battery_voltage = self.battery_voltage + curve_value

        logging("Battery voltage = {}".format(battery_voltage))

        if self.flag_enable == 0 and self.flag_power == 1:

            self.flag_power = 0
            self.controlledSubsystems[1].disable()

        if self.payload_enable == 0 and self.payload_power == 1:

            self.payload_power == 0
            self.controlledSubsystems[0].disable()

        if self.flag_enable == 1 and self.flag_power == 0 and self.low_power == 0:

            self.flag_power = 1
            self.controlledSubsystems[1].enable()

        if self.payload_enable == 1 and self.payload_power == 0 and self.low_power == 0:

            self.payload_power == 1
            self.controlledSubsystems[0].enable()

        if self.adcs_enable == 0:
            self.adcs_power = 0
        else:
            self.adcs_power = 1

        if self.radio1_enable == 1:
            self.radio1_power = 1
        else:
            self.radio1_power = 0

        if self.radio2_enable == 1:
            self.radio2_power = 1
        else:
            self.radio2_power = 0
        
        if battery_voltage < self.low_power_threshold and self.low_power == 0:

            logging("Low battery voltage")
            self.low_power = 1

            self.flag_power = 0
            self.payload_power = 0

            for subsystem in self.controlledSubsystems:

                subsystem.disable()

        elif battery_voltage >= self.low_power_threshold:
            self.low_power = 0

            logging("battery voltage nominal")
            if self.flag_enable == 1 and self.flag_power == 0:
                logging("Turning on flags")
                self.flag_power = 1
                self.controlledSubsystems[1].enable()

            if self.payload_enable == 1 and self.payload_power == 0:

                logging("Turning on payload")
                self.payload_power = 1
                self.controlledSubsystems[0].enable()


        power_flags = (self.low_power << 7 | self.battery_heater << 6 | self.payload_power << 5 | self.flag_power << 4 |
                    self.adcs_power <<3 | self.radio1_power <<2 | self.radio2_power <<1 ) & 0xff

        battery_voltage_encoded = int((battery_voltage-9) * 100)

        low_power_threshold_encoded = int((self.low_power_threshold-9.0) * 100) 
        battery_temp_encoded = int(self.battery_temp * 10)
        
        enable_flags = (self.payload_enable << 7 | self.flag_enable << 6 | self.adcs_enable << 5 | self.radio1_enable <<4 | self.radio2_enable <<3 ) & 0xff

        self.tlmData = struct.pack(">HHHBBI", battery_temp_encoded, battery_voltage_encoded, low_power_threshold_encoded, power_flags, enable_flags, self.command_error_count)

        # logging("Length of packet = {}".format(len(self.tlmData)))

        return True

    def changeConfig(self, commandpacket ):

        if len(commandpacket) < 8:
            self.command_error_count += 1
            return

        commandType = commandpacket[6]  # currently only one command type, set
        targetParam = commandpacket[7]  # use parameter numbers above


        logging("{}:{}".format( commandType, targetParam))

        if commandType != 0:

            self.command_error_count += 1
            return

        if targetParam == 0:

            value = commandpacket[8]  
            logging("payload_enable")
            if value == 1:
                self.payload_enable = 1
            elif value == 0:
                self.payload_enable = 0
            else:
                self.command_error_count += 1

        elif targetParam == 2:
            value = commandpacket[8]  
            logging("flag_enable")
            if value == 1:
                self.flag_enable = 1
            elif value == 0:
                self.flag_enable = 0
            else:
                self.command_error_count += 1

        elif targetParam == 4:
            value = commandpacket[8]  
            logging("adcs_enable")
            if value == 1:
                self.adcs_enable = 1
            elif value == 0:
                self.adcs_enable = 0
            else:
                self.command_error_count += 1

        elif targetParam == 5:
            value = commandpacket[8]  
            logging("radio1_enable")
            if value == 1:
                self.radio1_enable = 1
            elif value == 0 and self.radio2_enable == 1:
                self.radio1_enable = 0
            else:
                self.command_error_count += 1

        elif targetParam == 8:
            value = commandpacket[8]  
            logging("radio2_enable")
            if value == 1:
                self.radio2_enable = 1
            elif value == 0 and self.radio1_enable == 1:
                self.radio2_enable = 0
            else:
                self.command_error_count += 1

        elif targetParam == 12:

            value = struct.unpack(">H", commandpacket[8:])[0]  

            logging("setting low power threshold")
            logging("raw value = {}".format(value))

            try:
                numvalue = float(value)/100.0 + .9

            except:

                self.command_error_count += 1
                return

            logging("scaled value = {}".format(numvalue))

            if numvalue > 11.75 or numvalue < 9.90:

                self.command_error_count += 1

            else:

                self.low_power_threshold = numvalue

        else:

            logging("unknown parameter")
            self.command_error_count += 1


class flagTLM(tlmSender):

    def __init__(self, serversocket):


        super().__init__(FLAG_APID, FLAG_INTERVAL, serversocket)

        flag = os.getenv('FLAG', 'flag{aaaaaaaaaaaaaaAAAAAA}')


        flagbits = bitstring.BitArray()
        
        flagbytes = flag.encode()

        flagbytes += b'\x00'*(MAX_FLAG_LENGTH - len(flagbytes))

        for character in flagbytes:
            flagbits+=bitstring.pack('uint:7', character)

        self.tlmData = flagbits.tobytes()

def readSpacePacket(s):



    bytes_to_read = 6

    packet_header = b''

    while len(packet_header) < bytes_to_read:

        buffer = s.recv( bytes_to_read - len(packet_header))

        if buffer == b'':
            logging("out of data on read")
            return None

        packet_header += buffer



    if len(packet_header) < 6:
        logging("didn't read enough bytes {}".format(len(packet_header)))
        return None

    packet_header_bitstring = bitstring.BitArray(packet_header)

    try:
        packet_version, packet_type, \
        sec_header_flag, \
        APID, \
        sequence_flags, \
        sequence_count, \
        data_length = packet_header_bitstring.unpack('uint:3, uint:1, uint:1, uint:11, uint:2, uint:14, uint:16')

    except:
        logging("Unable to parse space packet header")
        return None

    if packet_version != 0 or packet_type != 1 or sequence_flags != 3:
        logging("Space packet failed initial validation")
        return None

    logging("version = {}, type={}, sec_header={}, APID={}, data_length={}".format(packet_version, packet_type, sec_header_flag, APID, data_length))

    total_read = 0
    bytes_to_read = data_length+1

    packet_data = b''

    while len(packet_data) < bytes_to_read:

        buffer = s.recv( bytes_to_read - len(packet_data))

        if buffer == b'':
            logging("out of data on read")
            return None

        packet_data += buffer


    return packet_header + packet_data


def timeout_exit(signum, frame):

    logging("timed out")
    sys.exit(-1)


def quick_exit(signum, frame):

    sys.exit(0)


if __name__ == '__main__':

    TIMEOUT = int(os.getenv("TIMEOUT",60))

    HOST = os.getenv("SERVICE_HOST", '0.0.0.0')
    PORT = os.getenv("SERVICE_PORT", 8125)

    signal.signal(signal.SIGALRM, timeout_exit)
    signal.signal(signal.SIGINT, quick_exit)
    signal.alarm(TIMEOUT)

    theSeed=os.getenv('SEED', 0)
    random.seed(theSeed)

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(('0.0.0.0',8123))
    s.listen(5)
    print("Telemetry Service running at {}:{}".format(HOST,PORT))
    sys.stdout.flush()

    while True:

        (clientsocket, address) = s.accept()

        sock = socketSender(clientsocket)

        if not sock:
            sys.exit(-1)

        logging("creating the payload sender\n")
        payload = payloadTLM(sock)
        payload.enable()
        payload.start()

        logging("creating Flag sender\n")
        t = flagTLM(sock)
        t.start()

        logging("creating EPS sender\n")
        eps = epsTLM(sock, [payload, t])
        eps.enable()
        eps.start()

        while True:

            try:
                packet = readSpacePacket(clientsocket)

            except Exception as e:

                packet = None

            if packet is None:
                logging("got a bad read for space packet")
                break

            try:
                packet_header_bitstring = bitstring.BitArray(packet)
                packet_version, packet_type, \
                sec_header_flag, \
                APID, \
                sequence_flags, \
                sequence_count, \
                data_length = packet_header_bitstring.unpack('uint:3, uint:1, uint:1, uint:11, uint:2, uint:14, uint:16')

            except:
                logging("Unable to parse space packet")

            if APID == EPS_APID:

                eps.changeConfig(packet)

            else:
                logging("Got a bad APID for command")


        payload.stop()
        eps.stop()
        t.stop()
