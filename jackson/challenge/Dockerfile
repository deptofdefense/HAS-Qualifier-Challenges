FROM python:3.7-slim AS python_env

WORKDIR /src

RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv

ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"
RUN python -m venv $VIRTUAL_ENV

COPY requirements.txt .

RUN pip install --upgrade pip ;\
    pip install --no-cache-dir -r requirements.txt

FROM python:3.7-slim

ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"

COPY --from=python_env /opt/venv /opt/venv

WORKDIR /challenge

COPY stations.txt deltat.data deltat.preds Leap_Second.dat challenge.py /challenge/
RUN python -m compileall . 


CMD ["python3", "challenge.py"]
