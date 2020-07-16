#!/bin/bash
target/release/monitor-service -c local_config.toml 1>&2 &
target/release/telemetry-service -c local_config.toml 1>&2 &
./payloadApp.py 1>&2 &
./epsApp.py 1>&2 &
./space_race
