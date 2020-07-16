FROM ubuntu:16.04
#Install Apache, Python, Curl. Enable CGI. Install PIP, use PIP to install skyfield
RUN apt-get update -y; \
    apt-get install -y apache2 python curl; \
    a2enmod cgi; \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py; \
    python get-pip.py; \
    pip install skyfield;

COPY errors /etc/apache2/sites-enabled/000-default.conf 
COPY custom_50x.html /var/www/html/custom_50x.html

WORKDIR /usr/lib/cgi-bin

# Upload all files to cgi-bin directory
COPY *.py ./
COPY entrypoint.sh ./
COPY deltat.* ./
COPY Leap_Second.dat ./
RUN chmod +x challenge.py 
# Suppress error output
RUN echo "ServerName beckley.mydomain.com" >> /etc/apache2/apache2.conf
#ENV FLAG=flag{Hungry_For_Apples}
# RUN
ENTRYPOINT ./entrypoint.sh 
