FROM python:3.7-slim AS python_env

WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv ;\
    apt install -y --no-install-recommends python-dev git libssl-dev libffi-dev build-essential

ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"
RUN python -m venv $VIRTUAL_ENV

RUN pip install --upgrade pip ;\
    pip install pwntools

FROM rtems5:tools-sparc AS builder

WORKDIR /src
ADD *.s Makefile /src/
RUN make assemble

FROM python:3.7-slim
ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=python_env /opt/venv /opt/venv

WORKDIR /solver
COPY --from=builder /src/*.bin /solver/
ADD solve.py /solver

CMD ["python", "/solver/solve.py"]
