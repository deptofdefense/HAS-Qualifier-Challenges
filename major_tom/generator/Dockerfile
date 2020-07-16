FROM python:3.7

RUN apt-get update -y &&\
    apt-get install gnuradio -y

RUN pip install construct

# RUN pip install pillow

COPY --from=generator-base /upload/ /upload

WORKDIR /generator
COPY . /generator

RUN cd utils && python setup.py install && cd ..



RUN chmod 777 /upload/upload.sh

CMD ["/bin/bash", "-c" , "python generate.py | /upload/upload.sh"]