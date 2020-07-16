FROM python:3.7-slim AS python_env

WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv gcc build-essential

ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"
RUN python -m venv $VIRTUAL_ENV

RUN pip install --upgrade pip ;\
    pip install numpy pyquaternion pwntools

FROM python:3.7-slim

ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=python_env /opt/venv /opt/venv

WORKDIR /solver

ADD *.py /solver/

CMD python solve.py
