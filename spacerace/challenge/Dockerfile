FROM python:3.7-slim AS builder

WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv python-dev build-essential \
                        gcc curl libssl-dev sqlite libsqlite3-dev make ca-certificates pkg-config
ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y  ;\
    eval `cat ~/.cargo/env` ;\
    rustup default 1.40.0 
    
ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"

RUN python -m venv $VIRTUAL_ENV ;\
    pip install --upgrade pip ;\
    pip install wheel 

ADD kubos.tar.gz /src/


RUN pip install --no-cache-dir -r /src/kubos/requirements.txt ;\
    pip install --no-cache-dir -r /src/kubos/libs/kubos-service/requirements.txt

WORKDIR /src/kubos
RUN cargo build --release --bin kubos-app-service ;\
    cargo build --release --bin monitor-service ;\
    cargo build --release --bin telemetry-service 
    # cargo build --release --bin scheduler-service ;\
    # cargo build --release --bin tel-service ;\
    # cargo build --release --bin sch-service 

RUN pip install apis/app-api/python 

ADD src/ /src/
COPY Cargo.toml /

WORKDIR /
RUN cargo build --release --bin space_race;\
    strip target/release/space_race
# RUN strip target/release/space_race

FROM python:3.7-slim

ENV PATH="~/.cargo/bin:${PATH}"
ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=builder /opt/venv /opt/venv

WORKDIR /challenge
COPY --from=builder /src/kubos/ /challenge/
COPY --from=builder /target/release/space_race /challenge/
COPY local_config.toml comms-service.toml *.py *.sh /challenge/

CMD ./startup.sh

