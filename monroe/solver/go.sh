#!/bin/bash
docker kill $(docker ps -q)
#cd ../challenge
#rm src.tar.gz
#tar cvf src.tar.gz *
#docker build -t "monroe:challenge" .
#cd ../solver
sudo docker build -t "monroe:solver" .
sudo service xinetd restart
sudo docker run --rm -e HOST=172.17.0.1 -e PORT=31339 -it "monroe:solver"
