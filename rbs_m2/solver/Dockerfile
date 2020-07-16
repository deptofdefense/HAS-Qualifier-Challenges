FROM python:3.7-slim AS python_env

WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv python-dev build-essential
    
ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"

RUN python -m venv $VIRTUAL_ENV ;\
    pip install --upgrade pip ;\
    pip install --no-cache-dir skyfield attrs


FROM python:3.7-slim
ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=python_env /opt/venv /opt/venv

RUN apt update ;\
    apt install -y zip

WORKDIR /solver
ADD src/hacksat_servokit.py src/hacksat_servo.py src/antenna_control.py src/orbit.py src/randomize_challenge.py /solver/
COPY solver/solver.py  src/active.txt solver/solver_testing.sh /solver/


CMD ["python", "-u", "/solver/solver.py", "--tle-file", "/solver/active.txt", "--motor-data", \
    "signal_0.bin", "--motor-data", "signal_1.bin" , "--motor-data", "signal_2.bin"]
