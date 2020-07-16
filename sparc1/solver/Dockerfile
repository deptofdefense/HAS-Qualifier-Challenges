FROM python:2.7-slim

RUN apt update; apt install -y gcc
RUN pip install crcmod pwntools
COPY . /solver
WORKDIR /solver

CMD ["python","solver.py"]
