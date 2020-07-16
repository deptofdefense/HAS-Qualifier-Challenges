FROM python:3.7-slim

COPY --from=generator-base /upload/ /upload

RUN apt-get update; \
    apt-get install -y python2.7 gnuradio ffmpeg ruby

RUN gem install wavefile
RUN ldconfig
RUN python3 -m pip install scapy ntlm-auth

WORKDIR /generator
COPY ./src /generator

CMD ["/bin/bash", "-c" , "python run_generator.py | /upload/upload.sh"]
