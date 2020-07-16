FROM python:3.7-slim AS python_env

WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv

ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"
RUN python -m venv $VIRTUAL_ENV

RUN pip install --upgrade pip ;\
    pip install numpy skyfield 

FROM ubuntu:18.04 AS builder

WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends make g++

ADD correlate_tool /src
RUN make

FROM python:3.7-slim

ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=python_env /opt/venv /opt/venv

WORKDIR /solver
COPY --from=builder /src/rx_wav /solver

ADD *.py /solver/

CMD python solve.py
