FROM ubuntu:18.04 AS builder 
RUN apt-get update ;\
    apt-get install -y --no-install-recommends wget ca-certificates ;\
    wget -qO - http://www.dotdeb.org/dotdeb.gpg | apt-key add - ;\
    apt-get install -y apt-utils ;\
    apt-get install -y --no-install-recommends software-properties-common ;\
    add-apt-repository -y ppa:allegro/5.2
RUN apt-get update ;\
    apt-get install -y gcc g++ gdb make python git libsdl-dev liballegro4-dev ;\
    apt-get install -y --no-install-recommends net-tools netcat libncurses5 libncurses5-dev \
			libgtk2.0-0 libgtk2.0-common libwxgtk3.0-dev
ADD virtualagc.tar.gz /src/

WORKDIR /src/virtualagc
RUN make

FROM python:3.7-slim

WORKDIR /challenge
COPY --from=builder /src/virtualagc/VirtualAGC/temp/lVirtualAGC /challenge/
ADD patch.sh timeout.py challenge.py /challenge/

EXPOSE 19697
EXPOSE 19698
CMD python challenge.py
