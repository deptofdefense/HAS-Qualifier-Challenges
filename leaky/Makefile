CHAL_NAME ?= leaky
CHAL_PORT ?= 31368
CHAL_HOST ?= 172.17.0.1
SEED ?= 100

build: generator solver

.PHONY:  generator solver solve generate test_challenge

.PHONY:
generator:
	docker build generator -t ${CHAL_NAME}:generator

.PHONY:
solver:
	docker build solver -t ${CHAL_NAME}:solver

.PHONY:solve
solve:
	docker run --rm -it -v `pwd`/data:/data -e "HOST=${CHAL_HOST}" -e "PORT=${CHAL_PORT}" ${CHAL_NAME}:solver

.PHONY:generate
generate:
	docker run --rm -it -v `pwd`/data:/out -e "SEED=${SEED}" ${CHAL_NAME}:generator

.PHONY:test
test:
	mkdir -p test
	rm -f test/*.txt
	docker run --rm -v `pwd`/test:/out -e SEED=3472657338860861762 ${CHAL_NAME}:generator
	docker run --rm -it -e "DIR=/mnt" -v `pwd`/test:/mnt ${CHAL_NAME}:solver

