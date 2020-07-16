#!/bin/bash

echo "Starting up CFS UDP Forwarding Service on tcp:${SERVICE_HOST}:${SERVICE_PORT}"
echo "Booting..."
./build.sh 2&>1 > /dev/null
cp -r /src/build/exe/cpu1/* /challenge
cp /src/cfs-wrapper /challenge
cd /challenge
echo "Checking File System..."

/challenge/core-cpu1 & 
/challenge/cfs-wrapper &

while read line
do
  echo $line > /dev/null
done < "${1:-/dev/stdin}"

exit 0
