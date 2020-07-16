#!/bin/bash

filename=$(echo $SEED 45 | sha1sum | cut -d ' ' -f 1)
mkdir files/
python subset.py images/ files/
cp files/* /mnt
ls -d /mnt/*.jpg
