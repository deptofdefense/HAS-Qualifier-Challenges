FROM ubuntu:18.04 as builder

RUN apt update ;\
    apt install -y --no-install-recommends build-essential gcc-mips-linux-gnu make g++-mips-linux-gnu

WORKDIR /src

ADD src /src
RUN make -C lib ;\
    make -C lib_cpp ;\
    make  ;\
    make rom

FROM vsim


#
# define the service name used throughout the rest of the dockerfile
#
ENV service RFblackmagic

#
# add the service user
RUN adduser --force-badname --disabled-password ${service}

#
# Create /home directory
#
RUN chown root.root /home
RUN chmod 755 /home

#
# Create service home directory
#
RUN chown root.${service} /home/${service}
RUN chmod 750 /home/${service}

#
# COPY in service executable (source from build container above)
#
COPY --from=builder /src/a.out.rom /challenge/challenge.rom
COPY --from=builder /src/a.out.rom /home/${service}/${service}.rom
COPY challenge/wrapper /home/${service}/wrapper

#
# home binaries
#
RUN chown root.root /home/${service}/*
#RUN chmod 755 /home/${service}/${service}.emulator
RUN chmod 744 /home/${service}/${service}.rom
RUN chmod +x /home/${service}/wrapper

#
# user and starting directory
#
USER ${service}
WORKDIR /home/${service}

#CMD ["sh", "-c", "vmips -o memsize=2097152 ${service}.rom 2>/dev/null"]
CMD ["sh", "-c", "./wrapper ${service}.rom"]
