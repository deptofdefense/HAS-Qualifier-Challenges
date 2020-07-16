import os
import sys
import socket
import re


if __name__ == "__main__":
    # get host from environment
    host = os.getenv("HOST")
    if not host:
        print("No HOST supplied from environment")
        sys.exit(-1)

    # get port from environment
    port = int(os.getenv("PORT","0"))
    if port == 0:
        print("No PORT supplied from environment")
        sys.exit(-1)

    # get ticket from environment
    ticket = os.getenv("TICKET")

    # connect to service
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
   
    # pass ticket to ticket-taker
    if ticket:
        prompt = s.recv(128)  # "Ticket please:"
        s.send((ticket + "\n").encode("utf-8"))

    # receive math challenge
    challenge = s.recv(128)
    m = re.match(r"(\d+) \+ (\d+)", challenge.decode("utf-8"))
    x = int(m.group(1))
    y = int(m.group(2))
   
    # send math response
    print("%d + %d = %d" % (x, y, x + y))
    s.send(("%d\n" % (x + y)).encode("utf-8"))

    # get flag
    result = s.recv(256)
    print(result.decode("utf-8"))
