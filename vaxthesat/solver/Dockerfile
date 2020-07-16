FROM python:3.6-slim AS solver_base
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv python-dev build-essential
ENV VIRTUAL_ENV="/opt/venv"
ENV PATH="/opt/venv/bin:$PATH"
RUN python -m venv $VIRTUAL_ENV ;\
    pip install --upgrade pip
COPY python/vax_common/ /tmp/vax_common
COPY python/vax_solver/ /tmp/vax_solver
RUN cd /tmp/vax_common \
 && pip install . \
 && cd /tmp/vax_solver \
 && pip install . \
 && rm -rf /tmp/*

FROM python:3.6-slim
ENV PATH="/opt/venv/bin:$PATH"
ENV VIRTUAL_ENV="/opt/venv"
COPY --from=solver_base /opt/venv /opt/venv

WORKDIR /assets
COPY assets/config.yml assets/*.json /assets/
CMD ["python", "-m", "vax_solver"]
