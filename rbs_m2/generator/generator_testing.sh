#!/usr/bin/env bash

python3 -u /generator/generator.py --seed $SEED --tle-file /resources/active.txt --groundstation-file /resources/worldcities_agg.csv > /dev/null 2>&1 
ls -d /generator/signal*.bin | xargs -n 1 echo

