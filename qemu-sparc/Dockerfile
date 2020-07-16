FROM ubuntu:18.04 AS builder

WORKDIR /src
ADD qemu.tar.gz /src
RUN apt update ; \
    apt upgrade ; \
    apt install -y git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev \
          git-email libaio-dev libbluetooth-dev libbrlapi-dev libbz2-dev libcap-dev libcap-ng-dev libcurl4-gnutls-dev \
          libgtk-3-dev libibverbs-dev libjpeg8-dev libncurses5-dev libnuma-dev librbd-dev librdmacm-dev libsasl2-dev \
          libsdl1.2-dev libseccomp-dev libsnappy-dev libssh2-1-dev libvde-dev libvdeplug-dev libxen-dev \
          liblzo2-dev valgrind xfslibs-dev libnfs-dev libiscsi-dev ;\
    cd /src/qemu ; \
    ./configure --target-list=sparc-softmmu --enable-debug ; \
    make -j4 ;\ 
    make install ;\
    rm -rf /src/*

CMD ["/bin/bash"]
