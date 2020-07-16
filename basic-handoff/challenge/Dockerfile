FROM ubuntu:18.04

RUN apt-get update -y; \
    apt-get install -y apache2

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY index.html /var/www/html/index.html
COPY 404.html /var/www/html/404.html

WORKDIR /challenge
COPY challenge.sh /challenge/challenge.sh

# suppress error output
RUN echo "ServerName basic-file.mydomain.com" >> /etc/apache2/apache2.conf

CMD ["/bin/bash", "/challenge/challenge.sh"]
