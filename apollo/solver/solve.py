import struct
import os, sys 
import time
import socket
import threading
import re


numLookup = {
    0 : " ",
    3 : "1",
    15: "4",
    19: "7",
    21: "0",
    25: "2",
    27: "3",
    28: "6",
    29: "8",
    30: "5",
    31: "9"
}
keys = {
    '0': 16,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    'e': 28,
    'v': 17,
    'n': 31,
    'c': 30,
}


def FormIoPacket(chan, val):
    if (chan < 0 or chan > 0x1ff):
        return None
    if (val < 0 or val > 0x7fff):
        return None
    
    
    return struct.pack("BBBB", 
            0xFF & ( chan >> 3),
            0xFF & ( 0x40 | ((chan << 3) & 0x38) | ((val >> 12) & 0x7) ),
            0xFF & ( 0x80 | ((val >> 6) & 0x3F)),
            0xFF & ( 0xc0 | (val & 0x3F) )
    )

def ParseIoPacket(bs):
    channel = ((bs[0] & 0x1F) << 3) | ((bs[1] >> 3) & 7)
    value = ((bs[1] << 12) & 0x7000) | ((bs[2] << 6) & 0xFC0) | (bs[3] & 0x3F)
    ubit = (0x20 & bs[0])
    return channel,value,ubit


def SendKeyTest(keyCode):
    keyCode = keyCode & 0o37
    keyCode |= ((keyCode << 10) | ((keyCode ^ 0o37) << 5))
    print(keyCode)
    return FormIoPacket(0o173, keyCode)

def SendKey(keyCode):
    return FormIoPacket(0o15, keyCode)

Verb = [0] * 2
Noun = [0] * 2
R1   = [0] * 5
R2   = [0] * 5
R3   = [0] * 5


def formatNums(nums):
    out = ""
    for num in nums:
        out += numLookup[num]
    return out

def doLeft(digit, vL):
    if vL == 0:
        pass
    #if digit == 0x5000:
    #    Verb[0] = vL
        
    #elif digit == 0x4800:
    #    Noun[0] = vL
        
    elif digit == 0x3800:
        R1[1] = vL
        
    elif digit == 0x3000:
        R1[3] = vL
        
    #elif digit == 0x2800:
    #    R2[0] = vL
        
    #elif digit == 0x2000:
    #    R2[2] = vL
        
    #elif digit == 0x1800:
    #    R2[4] = vL
        
    elif digit == 0x1000:
        R3[1] = vL
        
    elif digit == 0x800:
        R3[3] = vL
        
def doRight(digit, vR):
    if vR == 0:
        pass
    #if digit == 0x5000:
    #    Verb[1] = vR
        
    #elif digit == 0x4800:
    #    Noun[1] = vR
        
    elif digit == 0x4000:
        R1[0] = vR

    elif digit == 0x3800:
        R1[2] = vR
        
    elif digit == 0x3000:
        R1[4] = vR

    #elif digit == 0x2800:
    #    R2[1] = vR

    #elif digit == 0x2000:
    #    R2[3] = vR

    elif digit == 0x1800:
        R3[0] = vR

    elif digit == 0x1000:
        R3[2] = vR

    elif digit == 0x800:
        R3[4] = vR

def HandlePacket(bs):
    while len(bs) > 4:
        chan, val, ubit = ParseIoPacket(bs[:4])
        bs = bs[4:]
        if (chan != 0o10):
            continue

        digit = 0x7800 & val
        vL = (val >> 5) & 0x1F
        vR = val & 0x1F
        
        doLeft(digit, vL)
        doRight(digit, vR)


    return bs

running = True
def readLoop(sock, lock):
    bs = b""
    lastR1 = '     '

    while running:
        time.sleep(0.01)
        bs += sock.recv(1024)
        lock.acquire()
        HandlePacket(bs)
        lock.release()

if __name__ == "__main__":
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31450))
    Ticket = os.getenv("TICKET", "")

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    
    if len(Ticket):
        sock.recv(128)
        sock.send((Ticket + "\n").encode("utf-8"))

    for line in sock.recv(2048).split(b'\n'):
        if b"listening" in line:
            Host2,Port2 = line.decode('utf-8').split(" ")[-1].split(":")
        print(line.decode('utf-8'))
    time.sleep(5)
    Port2 = int(Port2)
    print("Connecting to:",Host2,Port2)
    
    sock2 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock2.connect((Host2, Port2))


    lock = threading.Lock()
    reader = threading.Thread(target=readLoop, args=(sock2,lock))
    reader.start()

    for b in "v27n02":
        sock2.send(SendKey(keys[b]))
        time.sleep(0.1)
    time.sleep(1)
    # Start Seach
    startCount = 45
    nums = []
    for ii in range(0,20):
        sock2.send(SendKey(keys['e']))
        time.sleep(0.9)

        command = "573" + oct(startCount + ii)[2:]
        for idx,b in enumerate(command):
            sock2.send(SendKey(keys[b]))
            while True:
                time.sleep(0.5)
                lock.acquire()
                get = R3[idx]
                lock.release()
                if numLookup[get] == b:
                    break
            
        sock2.send(SendKey(keys['e']))
        time.sleep(0.9)
        while True:
            try: 
                lock.acquire()
                num = (int(formatNums(R1),8))
                lock.release()
            except:
                continue
            break

        if num == 0o37777:
            break
        else:
            nums.append(num)
    
    running = False
    hi,lo = nums[-2:]

    print(oct(hi), oct(lo))
    reader.join()


    hi_b = bin(hi)[2:]
    hi_b = '0' * ( 14-len(hi_b) ) + hi_b

    lo_b = bin(lo)[2:]
    lo_b = '0' * ( 14-len(lo_b) ) + lo_b

    bits = hi_b + lo_b

    value = 0.0
    for idx, bit in enumerate(bits):
        if bit == '1':
            value += 2.0**(-1 - idx)
        
    sock.send(bytes("{:1.09f}\n".format(value * 16), 'utf-8'))
    for line in sock.recv(1024).split(b'\n'):
        print(line.decode('utf-8'))

    sys.stdout.flush()
    sock.close()
    sock2.close()

