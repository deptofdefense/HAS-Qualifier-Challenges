FROM python:3.7

RUN apt-get update -y &&\
    apt-get upgrade -y &&\
    apt-get install gnuradio -y

RUN apt update; \
    apt install -y python-pip python-dev git libssl-dev libffi-dev build-essential;\
    pip install --upgrade pip;\
    pip install pwntools;\
    pip install construct reedsolo pycrypto
WORKDIR /solver
COPY ./ /solver

RUN cd utils && python setup.py install && cd ..

CMD ["/bin/bash", "-c" , "python solve.py"]
