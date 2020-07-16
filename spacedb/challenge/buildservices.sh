#!/bin/bash

cargo build --release --bin kubos-app-service

cargo build --release --bin monitor-service

cargo build --release --bin telemetry-service

cargo build --release --bin scheduler-service

cargo build --release --bin tel-service