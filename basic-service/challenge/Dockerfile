FROM ubuntu:18.04 as builder

RUN apt update; \
    apt install -y gcc make

WORKDIR /src
ADD Makefile *.c /src/

RUN make


FROM ubuntu:18.04
WORKDIR /challenge
COPY --from=builder /src/challenge /challenge

CMD ["/challenge/challenge"]
