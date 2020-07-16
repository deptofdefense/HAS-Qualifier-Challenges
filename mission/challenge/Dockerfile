FROM python:3.7-slim AS python_env
WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv python-dev build-essential
ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"
RUN python -m venv $VIRTUAL_ENV ;\
    pip install --upgrade pip
COPY requirements.txt /src
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.7-slim
ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=python_env /opt/venv /opt/venv
WORKDIR /challenge
COPY *.py deltat.data deltat.preds Leap_Second.dat de421.bsp instructions.txt winMessage.txt /challenge/
CMD python run.py
