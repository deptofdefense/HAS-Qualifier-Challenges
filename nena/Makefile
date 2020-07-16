CHAL_NAME ?= nena
CHAL_PORT ?= 31337
CHAL_HOST ?= 172.17.0.1
SEED ?= 10
build: solver generator

.PHONY: solve
solve: 
	docker run -it --rm  -v `pwd`/data:/mnt -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)"  $(CHAL_NAME):solver

.PHONY:generator
generator:
	docker build generator -t $(CHAL_NAME):generator

.PHONY:solver
solver: 
	docker build solver -t $(CHAL_NAME):solver

.PHONY: test
test:
	mkdir -p data
	rm -rf data/*
	docker run --rm -it -v `pwd`/data:/out -e SEED=${SEED} -e FLAG="flag{zulu49225delta:GEuHu-lkVHZUryVLA926sLeEqnjP4C6ELc4fglSzpy92FOaFnGwcwWRB-Y_zDPijwJJzub-e5qr79IsIfgv3BiU}" $(CHAL_NAME):generator
	docker run -it --rm  -v `pwd`/data:/mnt -e DIR=/mnt $(CHAL_NAME):solver

.PHONY:generator-base
generator-base: 
	docker build generator-base -t generator-base:latest

.PHONY: solver_shell
solver_shell:
	docker run --rm -it $(CHAL_NAME):solver /bin/bash

clean:
	rm -f *.sig
	rm -f *.wav

