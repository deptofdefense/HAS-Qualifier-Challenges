FROM debian:buster-slim

WORKDIR /src
ENV PATH="/opt/rtems/5/bin:${PATH}"
RUN apt update ; \
    apt upgrade ; \
    apt install -y gcc-multilib autoconf automake bison diffutils flex gawk git gperf help2man make patch texinfo wget \
      'g++' python-dev xz-utils libtool-bin libncurses-dev zip unzip bzip2 zlib1g-dev

RUN git clone git://git.rtems.org/rtems-source-builder.git rsb ;\
    cd /src/rsb ;\
    git checkout d48abf4 ;\
    cd /src/rsb/rtems ;\
    /src/rsb/source-builder/sb-set-builder --prefix=/opt/rtems/5 5/rtems-sparc

RUN git clone git://git.rtems.org/rtems.git ;\
    cd /src/rtems; \ 
    git checkout 362cf319d4 ;\
    ./bootstrap -c ;\ 
    /src/rsb/source-builder/sb-bootstrap

ENV RTEMS_MAKEFILE_PATH=/opt/rtems/5/sparc-rtems5/leon3
ADD leon3_custom.cfg /src/rtems/bsps/sparc/leon3/config/leon3.cfg
RUN mkdir -p /src/kernel/leon3 ;\
    cd /src/kernel/leon3 ;\
    /src/rtems/configure --prefix=/opt/rtems/5 --target=sparc-rtems5 --enable-rtemsbsp=leon3 \
        --enable-posix --enable-networking  ;\
    make -j4; \
    make install

ENV PATH="/opt/rtems/5/bin:${PATH}"

cmd ["/bin/bash"]
