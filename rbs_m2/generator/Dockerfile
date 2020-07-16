# We need this version of ubuntu to install the correct gnuradio version (3.8.1)
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update ;\
    apt-get -y install --no-install-recommends python3.7 gnuradio zip 


WORKDIR /src
RUN apt update ;\
    apt install -y --no-install-recommends python3-virtualenv python3-pip  ;\
    pip3 install --upgrade pip ;\
    pip3 install --no-cache-dir skyfield attrs

WORKDIR /generator

ADD src/orbit.py src/antenna_control.py src/hacksat_servokit.py src/hacksat_servo.py src/randomize_challenge.py /generator/
ADD generator/generator_testing.sh generator/generator.py generator/generator.sh generator/signal_generator.py /generator/
ADD src/active.txt src/worldcities_agg.csv /resources/

RUN chmod +x generator.sh
RUN chmod +x generator_testing.sh

COPY --from=generator-base /upload/ /upload
CMD ["/bin/bash", "-c", "/generator/generator.sh | /upload/upload.sh"]
