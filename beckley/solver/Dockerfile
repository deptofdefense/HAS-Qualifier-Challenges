FROM ubuntu:18.04
#Install Apache, Python, Curl. Enable CGI. Install PIP, use PIP to install skyfield
RUN apt-get update -y; \
    apt-get install -y python curl python-dev git libssl-dev libffi-dev build-essential; \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py; \
    python get-pip.py; \
    pip install skyfield;\
    pip install --upgrade pwntools

WORKDIR /solver

# Upload all files to cgi-bin directory
COPY solver.py deltat.* *.dat /solver/
# RUN
CMD ["python", "solver.py"]
