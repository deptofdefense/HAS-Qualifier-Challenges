CHAL_NAME ?= sparc1
CHAL_PORT ?= 31341
CHAL_HOST ?= 172.17.0.1
SEED ?= 1234

build: $(SUBDIRS) generator challenge solver

.PHONY:challenge
challenge: generator
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

.PHONY:test
test: 
	rm -rf data/*
	docker run -it --rm -v `pwd`/data:/out -e "SEED=${SEED}" ${CHAL_NAME}:generator
	socat -v tcp-listen:${CHAL_PORT},reuseaddr exec:"docker run --rm -i -e SEED=$(SEED) -e FLAG=flag{1234}  ${CHAL_NAME}\:challenge" > run.log 2>&1 &
	docker run -it --rm -v `pwd`/data:/data -e "HOST=${CHAL_HOST}" -e "PORT=${CHAL_PORT}" -e "FILE=/data/test.elf" ${CHAL_NAME}:solver

.PHONY:generate
generate:
	docker run -it --rm ${CHAL_NAME}:generator

.PHONY:tools
tools:
	docker run -it --rm -v `pwd`/data:/data rtems5:tools-sparc /bin/bash
