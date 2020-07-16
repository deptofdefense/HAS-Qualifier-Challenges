FROM debian:latest

RUN apt update -y && apt install -y gnuradio

COPY challenge/* /

CMD ["/test.sh"]
