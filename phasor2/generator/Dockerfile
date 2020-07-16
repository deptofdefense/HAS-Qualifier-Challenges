FROM debian:buster-slim

RUN apt update ;\
    apt install -y --no-install-recommends python gnuradio

WORKDIR /generator
COPY --from=generator-base /upload/ /upload
ADD *.py /generator/

CMD ["/bin/bash", "-c", "python create_qpsk.py | /upload/upload.sh"]
