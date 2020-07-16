FROM ubuntu:18.04 AS builder

RUN apt update ;\
    apt install -y gcc make

WORKDIR /src
COPY *.c *.h Makefile /src/
RUN make

FROM python:3.7-slim AS python_env

WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv python-dev build-essential
    
ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"

RUN python -m venv $VIRTUAL_ENV ;\
    pip install --upgrade pip ;\
    pip install --no-cache-dir numpy pycrypto

FROM python:3.7-slim

ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=python_env /opt/venv /opt/venv

WORKDIR /src
COPY --from=builder /src/chal.exe /src
COPY --from=generator-base /upload/ /upload
COPY *.py /src/

CMD ["/bin/bash", "-c", "python generate.py | /upload/upload.sh"]
