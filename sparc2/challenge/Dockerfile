FROM qemu:sparc AS runtime
WORKDIR /challenge
RUN apt update ;\
    apt install -y python


COPY  --from=sparc2:generator /generator/challenge.elf /challenge/challenge.elf
COPY challenge/*.py /challenge/

CMD ["python", "challenge.py"]

