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


WORKDIR /challenge
COPY src/randomize_challenge.py challenge/timeout.py challenge/challenge.py src/active.txt src/worldcities_agg.csv /challenge/

CMD ["python", "-u", "challenge.py", "--tle-file", "active.txt", "--groundstation-file", "worldcities_agg.csv"]
