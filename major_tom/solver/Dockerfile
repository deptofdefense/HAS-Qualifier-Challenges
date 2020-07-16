FROM python:3.7

RUN apt-get update -y &&\
    apt-get install gnuradio python-bitstring -y

RUN pip install construct bitstring

WORKDIR /solver
COPY ./ /solver

RUN cd utils && python setup.py install && cd ..

CMD ["/bin/bash", "-c" , "python solve.py"]
