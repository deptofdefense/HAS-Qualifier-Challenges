#!/bin/bash

# echo "Debug: Starting services."

sed -i "s/127.0.0.1:8888/${SERVICE_HOST}:${SERVICE_PORT}/g" /challenge/mission-apps/instructions.html

echo "### Welcome to kubOS ###"
echo "Initializing System ..."

cd /challenge/target/release/

./kubos-app-service -c /challenge/local_config.toml -l "error" &

./monitor-service -c /challenge/local_config.toml -l "error" &

./telemetry-service -c /challenge/local_config.toml -l "error" &

./scheduler-service -c /challenge/local_config.toml -l "error" &

sleep 3     # DB will be locked if telemetry-service hasn't completed started up yet

./tel-service -c /challenge/local_config.toml -l "error" &    

cp /challenge/crit.conf /etc/nginx/conf.d/active.conf

service nginx start > /dev/null

sleep 5     # Need to make sure everything is up and running before we begin the challenge

# echo "Debug: Starting challenge."

cd /challenge/mission-apps/stage_one/start_stage_one/
./begin_one.py

while read line
do
  echo $line > /dev/null
done < "${1:-/dev/stdin}" 