FROM python:3.7

COPY --from=generator-base /upload/ /upload

RUN apt-get update -y &&\
    apt-get upgrade -y &&\
    apt-get install gnuradio -y
RUN pip install ipdb pycrypto construct reedsolo pillow

WORKDIR /generator
COPY . /generator
RUN cd utils && python setup.py install && cd ..
RUN chmod 777 /upload/upload.sh
CMD ["/bin/bash", "-c" , "python generate.py | /upload/upload.sh"]
