FROM qemu:sparc AS runtime
WORKDIR /challenge

RUN apt update; \
    apt install -y python

COPY --from=sparc1:generator /generator/challenge.elf /challenge
ADD challenge/*.py /challenge/

CMD ["python", "challenge.py"]

