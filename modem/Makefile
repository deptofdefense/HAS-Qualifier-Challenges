CHAL_NAME ?= modem
CHAL_PORT ?= 31337
CHAL_HOST ?= 172.17.0.1

build: challenge generator solver

.PHONY: solve
solve:
	docker run -it --rm -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)"  $(CHAL_NAME):solver



.PHONY:challenge
challenge:
	docker build -t $(CHAL_NAME):challenge -f challenge/Dockerfile .

.PHONY:generator
generator: 
	docker build -t $(CHAL_NAME):generator -f generator/Dockerfile .

.PHONY:solver
solver: 
	docker build -t $(CHAL_NAME):solver -f solver/Dockerfile .

.PHONY: generate
generate: 
	docker run --rm -it -v ${PWD}/test:/out $(CHAL_NAME):generator

.PHONY: test
test: 
	mkdir -p test
	rm -rf test/*
	docker run --rm -it -v ${PWD}/test:/out $(CHAL_NAME):generator
	socat -v tcp-listen:19020,reuseaddr exec:"docker run --rm -i -e FLAG=flag{zulu49225delta\:GG1EnNVMK3-hPvlNKAdEJxcujvp9WK4rEchuEdlDp3yv_Wh_uvB5ehGq-fyRowvwkWpdAMTKbidqhK4JhFsaz1k} modem\:challenge" > log 2>&1 &
	docker run -it --rm -e "HOST=$(CHAL_HOST)" -e "PORT=19020" -e DIR=/mnt -v `pwd`/test:/mnt $(CHAL_NAME):solver

.PHONY:generator-base
generator-base: 
	docker build generator-base -t generator-base:latest

.PHONY:run
run: challenge
	docker run --rm -it $(CHAL_NAME):challenge


.PHONY: challenge_shell
challenge_shell:
	docker run --rm -it $(CHAL_NAME):challenge /bin/bash

.PHONY: solver_shell
solver_shell:
	docker run --rm -it $(CHAL_NAME):solver /bin/bash

