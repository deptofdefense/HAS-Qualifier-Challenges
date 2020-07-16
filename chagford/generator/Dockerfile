FROM python:3.7-slim AS python_env

WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv python-dev build-essential
    
ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"

RUN python -m venv $VIRTUAL_ENV ;\
    pip install --upgrade pip ;\
    pip install --no-cache-dir skyfield


FROM ubuntu:18.04 as builder

RUN apt-get update -y; \
        apt-get install -y --no-install-recommends gcc make build-essential

WORKDIR /src
ADD src/ /src/

RUN make challenge ;\
    make client ;\
    make autoClient 

FROM python:3.7-slim

RUN apt update;\
    apt install -y --no-install-recommends tcpdump

ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=python_env /opt/venv /opt/venv

WORKDIR /generator
COPY --from=generator-base /upload/ /upload
COPY --from=builder /src/challenge /src/autoClient /generator/
COPY generator/run.sh shared/* /generator/

CMD /bin/bash -c ./run.sh | /upload/upload.sh

EXPOSE 8008
EXPOSE 8008/udp
