FROM debian:buster-slim

RUN apt update ;\
    apt install -y --no-install-recommends gnuradio python python-bitstring

WORKDIR /solver
ADD solve.py /solver/

CMD ["python", "solve.py"]
