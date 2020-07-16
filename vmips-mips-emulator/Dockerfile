FROM ubuntu:18.04 AS builder

RUN apt update ;\
    apt install -y make gcc build-essential

WORKDIR /src
COPY src /src

RUN ./configure ;\
    make ;\ 
    make install


FROM ubuntu:18.04

COPY --from=builder /usr/local/ /usr/local
CMD /bin/bash

#
# Build complete -- Now create running container
#
#FROM ubuntu:18.04

#
# define the service name used throughout the rest of the dockerfile
#
#ENV service RFblackmagic

#
# add the service user
#RUN adduser --force-badname --disabled-password ${service}

#
# Create /home directory
#
#RUN chown root.root /home
#RUN chmod 755 /home

#
# Create service home directory
#
#RUN chown root.${service} /home/${service}
#RUN chmod 750 /home/${service}

#
# COPY in service executable (source from build container above)
#
#COPY --from=0 /src/vmips /home/${service}/${service}.emulator
#COPY rom/challenge.rom /home/${service}/${service}.rom

#
# home binaries
#
#RUN chown root.root /home/${service}/*
#RUN chmod 755 /home/${service}/${service}.emulator
#RUN chmod 744 /home/${service}/${service}.rom

#
# /lib
#
#RUN chown -R root.root /lib
#RUN chmod -R 755 /lib
#RUN chown -R root.root /lib64
#RUN chmod -R 755 /lib64

#
# user and starting directory
#
#USER ${service}
#WORKDIR /home/${service}

#
# binary to run
#
#CMD ["/home/RFblackmagic/RFblackmagic"]
#CMD ["sh", "-c", "/home/${service}/${service}.emulator -o memsize=2097152 /home/${service}/${service}.rom 2> /tmp/errors.txt"]
#CMD ["sh", "-c", "/home/${service}/${service}.emulator -o memsize=2097152 /home/${service}/${service}.rom"]
