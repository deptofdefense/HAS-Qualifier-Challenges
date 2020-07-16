FROM python:3.7-slim AS python_env

WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv

ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"
RUN python -m venv $VIRTUAL_ENV

RUN pip install --upgrade pip ;\
    pip install numpy skyfield scipy

FROM python:3.7-slim

ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=python_env /opt/venv /opt/venv

WORKDIR /challenge
ADD *.py /challenge/

ARG DEFAULT_SEED=0
ENV SEED=$DEFAULT_SEED

CMD python challenge.py
