FROM python:3.7-slim

RUN apt update; \
    apt install -y --no-install-recommends octave octave-quaternion octave-statistics

WORKDIR /challenge/src
ADD src.tar.gz /challenge/
COPY *.py /challenge/

CMD python /challenge/run.py
