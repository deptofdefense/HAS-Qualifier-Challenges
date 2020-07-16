#!/bin/sh

# create the flag file
echo $FLAG > flag.txt

# create the challenge file
tar czf /tmp/flag.tar.gz flag.txt

# tell the uploader what files we want uploaded
echo "/tmp/flag.tar.gz"

