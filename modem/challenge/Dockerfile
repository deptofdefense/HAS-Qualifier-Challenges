FROM python:3.7-slim

RUN apt-get update; \
    apt-get install -y iputils-ping

# TODO - pip and this line are only needed for debug
#RUN python3 -m pip install ipdb

WORKDIR /challenge
COPY ./src /challenge
COPY ./challenge/wrapper /challenge/
RUN python -m compileall /challenge -r 10

# TODO - Might only be necessary for testing
RUN mkdir /data
#CMD ["bash", "-c", "python3 run_challenge.py"]
CMD ["./wrapper"]
