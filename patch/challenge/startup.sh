#!/bin/bash

echo "Starting up CFS UDP Forwarding Service on tcp:${SERVICE_HOST}:${SERVICE_PORT}"
echo "Booting..."
BYTES=`python -c "import random; random.seed(${SEED}); print(8*random.randint(1,4096))"`
sed -i "s/\[RANDOM_SIZE_PATCH\]/[${BYTES}]/" /src/apps/kit_to/fsw/src/pktmgr.c
cd /src
echo "Checking File System..."
./build.sh 2&>1 > /dev/null
echo "File System Check: Pass"
cp -r /src/build/exe/cpu1/* /challenge
cp /src/cfs-wrapper /challenge
cd /challenge

/challenge/core-cpu1 & 
/challenge/cfs-wrapper &

while read line
do
  echo $line > /dev/null
done < "${1:-/dev/stdin}"

exit 0
