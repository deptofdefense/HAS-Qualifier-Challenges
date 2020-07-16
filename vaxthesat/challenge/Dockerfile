FROM ubuntu:18.04 AS builder

ENV DEBIAN_FRONTEND noninteractive
ENV PIP_NO_INPUT 1

# Install tools required for project
RUN apt-get update ;\
    apt-get install -y --no-install-recommends \
              build-essential \
              libxml2-dev \
              libxslt-dev \
              libxslt-dev \
              libhdf5-dev \
              libpq-dev \
              libssl-dev \
              libffi-dev \
              libpcre3-dev \
              libpcap-dev \  
              vde2 \
              uml-utilities \
              make \
              net-tools \
              libvdeplug2-dev \
              rename \
              python3-pip \
              ftp-upload \
              genisoimage \
              wget ;\
 apt-get -y autoremove && apt-get -y clean ; \
 apt-get -y autoclean ; \
 rm -rf /var/cache/apt/archives/lists/*

#install simh
WORKDIR /src
RUN wget https://github.com/simh/simh/archive/v3.9-0.tar.gz ;\
    tar xf v3.9-0.tar.gz ;\
    cd simh-3.9-0 ;\
    mkdir BIN ;\
    make USE_NETWORK=1 BIN/vax

FROM python:3.7-slim 

COPY --from=builder /src/simh-3.9-0/BIN/* /usr/bin/


ARG OPERATINGSYSTEM=openbsd
# setup vax emulator
ADD challenge/files/${OPERATINGSYSTEM}/vax.tar.gz /
COPY challenge/files/*.sh /
COPY challenge/files/${OPERATINGSYSTEM}/vax_server.ini /vax/server/vax_server.ini
COPY challenge/files/${OPERATINGSYSTEM}/vax_client.ini /vax/client/vax_client.ini

RUN mkdir /assets
COPY assets/config.yml assets/*.json /assets/
COPY assets/server_disassembly /assets/server_disassembly
COPY assets/server_application /assets/server_application
COPY assets/client /assets/client

COPY python/vax_common/ /tmp/vax_common
COPY python/vax_challenge/ /tmp/vax_challenge
RUN cd /tmp/vax_common ;\
    pip3 install . ;\
    cd /tmp/vax_challenge ;\
    pip3 install . ;\
    rm -rf /tmp/*

RUN apt update ;\
    apt install -y --no-install-recommends libpcap0.8 libvdeplug2 genisoimage

CMD ["/start.sh"]
