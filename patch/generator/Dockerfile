FROM ubuntu:18.04 as builder

WORKDIR /src
RUN dpkg --add-architecture i386
RUN apt update ; \
    apt install -y cmake gcc build-essential curl default-jre libssl-dev libyaml-dev libffi-dev \
    libreadline6-dev zlib1g-dev python-dev xxd gcc-multilib libssl-dev:i386


COPY --from=patch:challenge /src/ /src
RUN rm /src/build/exe/cpu1/cf/kit_to.so

COPY --from=generator-base /upload/ /upload

COPY generator/entry.sh /src/

CMD ["/bin/bash", "-c", "./entry.sh | /upload/upload.sh"]
