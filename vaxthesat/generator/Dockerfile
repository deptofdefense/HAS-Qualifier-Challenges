FROM python:3.7-slim

RUN mkdir /assets
COPY assets/config.yml /assets/
COPY assets/*.json /assets/
COPY assets/server_disassembly /assets/server_disassembly

COPY python/vax_common/ /tmp/vax_common
RUN cd /tmp/vax_common && pip install .

COPY python/vax_generator/ /tmp/vax_generator
RUN cd /tmp/vax_generator && pip install .

RUN rm -rf /tmp/*

COPY --from=generator-base /upload/ /upload
CMD ["/bin/bash", "-c", "python -m vax_generator | /upload/upload.sh"]
