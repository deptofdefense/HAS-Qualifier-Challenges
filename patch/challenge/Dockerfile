FROM ubuntu:18.04 as builder

WORKDIR /src
RUN dpkg --add-architecture i386
RUN apt update ; \
    apt install -y cmake gcc build-essential curl default-jre libssl-dev libyaml-dev libffi-dev \
    libreadline6-dev zlib1g-dev python-dev xxd gcc-multilib libssl-dev:i386
    #apt install -y cmake curl default-jre xfce4-terminal gcc libssl-dev libyaml-dev libffi-dev \
    #libreadline6-dev zlib1g-dev  \
    #freeglut3 freeglut3-dev qt4-default qt4-dev-tools libqt4-dev libsmokeqt4-dev libcanberra-gtk* dos2unix python-dev
    #libgdbm3 libgdbm-dev libncurses5-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
COPY cfs /src/
RUN /src/build.sh

WORKDIR /challenge

ENV SERVICE_HOST=172.17.0.1
ENV SERVICE_PORT=54321
ADD challenge/startup.sh /challenge/

CMD ["./startup.sh"]
