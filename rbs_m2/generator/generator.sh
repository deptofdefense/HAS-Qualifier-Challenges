#!/usr/bin/env bash

python3 -u /generator/generator.py --seed $SEED --tle-file /resources/active.txt --groundstation-file /resources/worldcities_agg.csv 1>&2
ls -d /generator/signal_*.bin | xargs -n 1 echo
