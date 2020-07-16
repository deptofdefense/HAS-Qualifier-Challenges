#!/bin/bash
docker kill $(docker ps -q)
rm src.tar.gz
tar cvf src.tar.gz *
docker build -t monroe:challenge .
docker run --rm -e FLAG=flag{STORY_TRAIN} -it -p 8080:54321 monroe:challenge
