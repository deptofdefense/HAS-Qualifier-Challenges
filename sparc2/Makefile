CHAL_NAME ?= sparc2
CHAL_PORT ?= 31348
CHAL_HOST ?= 172.17.0.1
SEED=1234

build: generator challenge solver static

.PHONY:challenge
challenge: generator
	docker build -f challenge/Dockerfile . -t $(CHAL_NAME):challenge

.PHONY:generator
generator:
	docker build -f generator/Dockerfile . -t $(CHAL_NAME):generator

.PHONY:solver
solver: 
	docker build solver -t $(CHAL_NAME):solver

.PHONY: solve
solve: 
	docker run -it --rm -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)"  $(CHAL_NAME):solver

.PHONY: static
static:
	mkdir -p static
	docker run --rm -it -v `pwd`/static:/out $(CHAL_NAME):generator

.PHONY:test
test: 
	rm -rf data/*
	docker run -it --rm -v `pwd`/data:/out -e "SEED=${SEED}" ${CHAL_NAME}:generator
	socat -v tcp-listen:${CHAL_PORT},reuseaddr exec:"docker run --rm -i -e SEED=$(SEED) -e FLAG=flag{1234}  ${CHAL_NAME}\:challenge" > run.log 2>&1 &
	docker run -it --rm -e HOST=${CHAL_HOST} -e PORT=${CHAL_PORT} -e FILE=/mnt/test.elf -v $(PWD)/data:/mnt ${CHAL_NAME}:solver

