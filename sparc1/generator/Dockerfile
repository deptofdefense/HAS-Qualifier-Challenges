FROM rtems5:tools-sparc AS builder

ADD src /src
WORKDIR /src
RUN make

FROM python:3.7-slim
WORKDIR /generator
COPY --from=generator-base /upload/ /upload
COPY --from=builder /src/challenge/o-optimize/challenge.exe /generator/challenge.elf
ADD generator/*.py /generator

CMD ["/bin/bash", "-c", "python generate.py | /upload/upload.sh"]

