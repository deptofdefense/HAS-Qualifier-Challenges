FROM ubuntu:18.04
WORKDIR /generator

RUN apt update ;\
    apt install -y --no-install-recommends build-essential

COPY --from=generator-base /upload/ /upload
COPY --from=rfmagic:challenge /challenge/challenge.rom /generator/
COPY --from=vsim:latest /usr/local/bin/vmips /generator/

RUN strip -S /generator/vmips

CMD ["/bin/bash", "-c", "ls -d /generator/* | xargs -n 1 echo | /upload/upload.sh"]

