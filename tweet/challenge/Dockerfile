from python:3.7

RUN pip install --upgrade pip ; pip install numpy

WORKDIR /challenge
ADD images.tar /challenge/
COPY *.py /challenge/
RUN python -m compileall .

CMD ["python", "challenge.py"]
