FROM python:3.7-slim

RUN apt-get update; \
    apt-get install -y python3-pip python3-dev git libssl-dev libffi-dev build-essential ffmpeg gnuradio
RUN pip install --upgrade pip
RUN pip install pwntools ntlm-auth scapy ipdb

WORKDIR /solver
COPY ./src /solver
RUN python -m compileall /solver -r 10

CMD ["python3", "run_solver.py"]
