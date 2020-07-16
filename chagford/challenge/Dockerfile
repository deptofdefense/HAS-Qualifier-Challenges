
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

RUN make challenge


FROM python:3.7-slim
ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=python_env /opt/venv /opt/venv

WORKDIR /challenge

COPY --from=builder /src/challenge /challenge/
 
COPY shared/* /challenge/
CMD ["bash", "-c", "python makeHash.py && /challenge/challenge"]

EXPOSE 8008
EXPOSE 8008/udp
