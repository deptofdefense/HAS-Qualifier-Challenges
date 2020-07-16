FROM rtems5:tools-sparc AS builder

WORKDIR /src
ADD src /src
RUN make ;\
    cp challenge/o-optimize/challenge.exe challenge/o-optimize/challenge.elf ;\
    sparc-rtems5-strip challenge/o-optimize/challenge.elf

FROM ubuntu:18.04
WORKDIR /generator
COPY --from=generator-base /upload/ /upload
COPY --from=builder /src/challenge/o-optimize/challenge.elf /generator/challenge.elf
ADD generator/generate.sh /generator/

CMD ["/bin/bash", "-c" , "/generator/generate.sh | /upload/upload.sh"]
