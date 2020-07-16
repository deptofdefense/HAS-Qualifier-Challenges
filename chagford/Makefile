CHAL_NAME ?= chagford
CHAL_PORT ?= 31341
CHAL_HOST ?= 172.17.0.1
SEED ?= 4122301585109055810
FLAG ?= flag{india10240bravo:GOEEAVDBhLEDg0UoZB3Zly76q3LBdr4nt8tYbRPTOWe9IB0NicpHMpLvaHiVYt3dv4EjW8kkbM2Wh0yuLJgQoBg}
TICKET ?= 

build:  challenge generator solver

.PHONY:challenge
challenge:
	docker build -f challenge/Dockerfile . -t ${CHAL_NAME}:challenge

.PHONY:solver
solver: 
	docker build solver -t ${CHAL_NAME}:solver

.PHONY:generator
generator: 
	docker build -f generator/Dockerfile . -t ${CHAL_NAME}:generator

.PHONY:solve
solve:
	docker run -it --rm -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)"  ${CHAL_NAME}:solver

.PHONY:generate
generate:
	docker run -it --rm -v `pwd`/data:/out -e "SEED=$(SEED)" ${CHAL_NAME}:generator

.PHONY:generate_shell
generate_shell:
	docker run -it --rm --name=chagford_test -v `pwd`/src:/src -v `pwd`/data:/out -e "FLAG=${FLAG}" -e "SEED=${SEED}" ${CHAL_NAME}:generator /bin/bash

.PHONY: test
test:
	rm -rf data/*
	docker run -it --rm -v `pwd`/data:/out -e "SEED=$(SEED)" ${CHAL_NAME}:generator > gen.log  2>&1 
	socat -v tcp-listen:19020,reuseaddr exec:"docker run --rm -i -e SERVICE_HOST=172.17.0.1 -e SERVICE_PORT=19021 -e SEED=$(SEED) -e FLAG=${FLAG} -p 19021\:8008 chagford\:challenge" > run.log 2>&1 & 
	docker run -it --rm -v `pwd`/data:/out -e "DIR=/out" -e "HOST=172.17.0.1" -e "PORT=19020" ${CHAL_NAME}:solver

.PHONY: attach
attach:
	docker run -it --rm -v `pwd`/data:/out -e "DIR=/out" -e "HOST=172.17.0.1" -e "PORT=19020" ${CHAL_NAME}:solver

.PHONY: test-final
test-final:
	docker run -it --rm -v `pwd`/final:/out -e "DIR=/out" -e "HOST=monkey.satellitesabove.me" -e "PORT=5044" -e TICKET=ticket{oscar72544juliet:GNNZ3ooJmvYweGtfkU3-_Uma7k8OAitFhVmccFMObENZwBLbvX5Lt-PeqobtKBb9kQ} ${CHAL_NAME}:solver

.PHONY: test-aws
test-aws:
	docker run -it --rm -v `pwd`/data:/out -e "DIR=/out" -e "HOST=$(EC2_QA)" -e "PORT=5044" -e TICKET=ticket{india10240bravo:GJsK4HYpxz25pmt5Cx8tvU0RKRxYUgBBKbzIhZQRwWJcBSWZcKYRaB7m_7iFhONFug} ${CHAL_NAME}:solver

