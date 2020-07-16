FROM python:3.7-slim AS builder

WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv python-dev build-essential \
                        gcc curl libssl-dev sqlite libsqlite3-dev make ca-certificates pkg-config

ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"

RUN python -m venv $VIRTUAL_ENV ;\
    pip install --upgrade pip ;\
    pip install wheel 

COPY kubos /src/kubos
RUN pip install --no-cache-dir -r /src/kubos/requirements.txt ;\
    pip install --no-cache-dir -r /src/kubos/libs/kubos-service/requirements.txt

ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y  ;\
    eval `cat ~/.cargo/env` ;\
    rustup default 1.32.0 

WORKDIR /src/kubos
ADD challenge/buildservices.sh /src/kubos
RUN ./buildservices.sh

RUN pip install apis/app-api/python 

FROM python:3.7-slim
RUN apt update; \
    apt install -y --no-install-recommends nginx lsof tini

ENV PATH="~/.cargo/bin:${PATH}"
ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=builder /opt/venv /opt/venv

COPY challenge/nginx/* /challenge/
WORKDIR /challenge

ADD mission-apps /challenge/mission-apps
COPY --from=builder /src/kubos/target /challenge/target
COPY challenge/local_config.toml /challenge
ADD challenge/startserver.sh /challenge

ENV SERVICE_HOST="127.0.0.1"
ENV SERVICE_PORT="8888"
# CMD /challenge/startserver.sh
ENTRYPOINT [ "/usr/bin/tini", "--", "/challenge/startserver.sh" ]
