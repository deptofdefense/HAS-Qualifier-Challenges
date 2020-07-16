#!/bin/bash

BYTES=`python -c "import random; random.seed(${SEED}); print(8*random.randint(1,4096))"`
sed -i "s/\[RANDOM_SIZE_PATCH\]/[${BYTES}]/" /src/apps/kit_to/fsw/src/pktmgr.c
/src/build.sh 2&>1 > /dev/null

echo "/src/build/exe/cpu1/cf/kit_to.so"
