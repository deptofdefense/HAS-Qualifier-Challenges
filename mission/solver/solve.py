import os
import sys
import socket

if __name__ == "__main__":
    Host = os.getenv("HOST", "localhost")
    Port = int(os.getenv("PORT", 31337))

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((Host, Port))
    fsock = sock.makefile('rw')

    ticket = os.getenv("TICKET", "")
    if len(ticket):
        print(fsock.readline().strip())
        fsock.write(ticket + '\n')
        fsock.flush()
        print("Sent Ticket: ", ticket)

    plan = """
2020-04-22T00:00:00Z sun_point
2020-04-22T09:28:00Z imaging
2020-04-22T09:35:00Z sun_point
2020-04-22T10:47:00Z data_downlink
2020-04-22T10:51:00Z sun_point
2020-04-22T20:51:00Z wheel_desaturate
2020-04-22T22:21:00Z sun_point
2020-04-23T03:00:00Z wheel_desaturate
2020-04-23T04:30:00Z sun_point
2020-04-23T09:51:00Z imaging
2020-04-23T09:58:00Z sun_point
2020-04-23T11:10:00Z data_downlink
2020-04-23T11:13:00Z sun_point
run
"""
    for line in plan:
        fsock.write(line)
    fsock.flush()
    while True:
        line = fsock.readline()
        if len(line) == 0:
            break
        print(line.strip())
        sys.stdout.flush()

        if "flag" in line:
            break
        if "Mission Failed" in line:
            break
