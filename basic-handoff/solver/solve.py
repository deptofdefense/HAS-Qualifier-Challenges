import os
import sys
import socket
import re
import urllib.request


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

    # receive connection string
    prompt = s.recv(256)
    m = re.search(r"(http://[a-zA-Z0-9.\-]+:\d+/)", prompt.decode("utf-8"))
    if not m:
        print("Did not receive expected prompt from service")
        sys.exit(-1)
    url = m.group(1)
    print(url)
   
    # get flag from webpage
    f = urllib.request.urlopen(url + "flag.html")
    print(f.read())
