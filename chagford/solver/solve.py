from crccheck.crc import Crc32Mpeg2
import sys, os
from struct import pack,unpack
from binascii import hexlify, unhexlify
from pwnlib.tubes.remote import remote
import socket
from scapy.all import *

CMD_COMMAND = 0x20
CMD_LOWPOWER= 0x31
CMD_DEBUG   = 0x42
SHUTDOWN    = 0x88
WAKEUP      = 0x55

QUERY_COMMAND = 0x5A
FLAG = 0x66 

SET_COMMAND = 0x75
ENCRYPT_STATE = 0x94
ENCRYPT_ON = 0
ENCRYPT_OFF = 1


def xor_two_str(str1,str2):
    return bytes([a ^ b for (a,b) in zip(str1, str2)])

def createSetMessage(field, value, count=1):
    auth = 0xAABBCCDD
    payload = pack("<IIBBB", auth, count, SET_COMMAND, field, value)
    payload = pack("<I", Crc32Mpeg2.calc(payload)) + payload
    return payload

def createQueryMessage(field, count=1):
    auth = 0xAABBCCDD
    payload = pack("<IIBB", auth, count, QUERY_COMMAND, field)
    payload = pack("<I", Crc32Mpeg2.calc(payload)) + payload
    return payload

def createModeMessage(mode, count=1):
    auth = 0xAABBCCDD
    payload = pack("<IIB", auth, count, mode)
    payload = pack("<I", Crc32Mpeg2.calc(payload)) + payload
    return payload

if __name__ == "__main__":

    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31360))

    File = os.getenv("DIR", "/mnt") + os.sep + "capture.pcap"

    sockChal = remote(Host, Port)
    print("Connect to ", Host, Port)
    sys.stdout.flush()
    
    ticket = os.getenv("TICKET", "")
    if len(ticket):
        sockChal.recvline()
        sockChal.send(ticket + "\n")

    File = os.getenv("DIR", "/mnt") + os.sep + "capture.pcap"
    packets = rdpcap(File)
    

    sockChal.recvuntil(b'tcp:', drop=True)
    line = sockChal.recvline().strip()
    TlmHost,TlmPort = line.split(b":")
    TlmPort = int(TlmPort)
    print("Connecting to %s:%d" % (TlmHost, TlmPort))
    sys.stdout.flush()

    addr = (TlmHost, TlmPort)
    sockTlm = remote(TlmHost, TlmPort)

    # Do wakeup packet
    ii = 3
    payload = packets[ii]["Raw"].load
    print(hexlify(payload))
    sockTlm.send( payload )
    data = sockTlm.recv(128)
    print(hexlify(data))

    # Send packets until we get to the mode change
    ii = 0
    packets_to_send = []
    for packet in packets[4:]:
        # Ignore all packets not destined for the server
        if not packet.haslayer("TCP") or not packet["TCP"].dport == 8008:
            continue
        
        # Check if it's a PSH
        if not packet.haslayer("Raw"):
            continue 
        payload = packet["Raw"].load
        ii += 1

        if b"\x00\x00\x00\x55" in payload[-5:]:
            break
        print(hexlify(payload))
        sys.stdout.flush()
        
        packets_to_send.append(payload)

        #sockTlm.send( payload )
        #data = sockTlm.recv(128)

    targetPayload = packets_to_send[-1]
    for packet in packets_to_send[:-1]:
        sockTlm.send(packet)
        sockTlm.recv(128)

    ii -= 1
    print("Got to the target Payload, msgID %d" % ii)
    print(hexlify(targetPayload))
    sys.stdout.flush()

    original = createModeMessage(CMD_LOWPOWER, ii)
    goal = createModeMessage(CMD_DEBUG, ii)

    print("Original: ", hexlify(original))
    patch = xor_two_str(original, goal)
    msg = xor_two_str(patch, targetPayload)
    print("Modified: ", hexlify(msg))

    sockTlm.send(msg)
    print(hexlify(sockTlm.recv(128)))
    ii += 1

    msg = createSetMessage(ENCRYPT_STATE, ENCRYPT_OFF, ii)
    print("Turn off Encryption: ", hexlify(msg))
    sockTlm.send(msg)
    sockTlm.recv(64)
    ii += 1

    msg = createModeMessage(CMD_COMMAND, ii)
    print("Back to Command Mode: ", hexlify(msg))
    sockTlm.send(msg)
    sockTlm.recv(64)
    ii += 1

    msg = createQueryMessage(FLAG, ii)
    print("Get Flag: ", hexlify(msg))
    sockTlm.send(msg)
    ii += 1 

    import re

    for ii in range(0,10):
        data = sockTlm.recv(256,0.5)
        m = re.search(b"(flag{[a-zA-Z0-9]+:[a-zA-Z0-9\-_]+})", data)
        if m is not None:
            print(m.group(0).decode('utf-8'))
            break

    msg = createModeMessage(SHUTDOWN, ii)
    print("Shutdown: ", hexlify(msg))
    sockTlm.send(msg)
