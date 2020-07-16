CHAL_NAME ?= filter
CHAL_PORT ?= 31316
CHAL_HOST ?= 172.17.0.1
SEED ?= 12345

build: challenge solver generator 

.PHONY: solve
solve: 
	docker run -it --rm -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)" -e "TICKET=${TICKET}" $(CHAL_NAME):solver

.PHONY:challenge
challenge: src.tar.gz
	cp src.tar.gz challenge
	docker build challenge -t $(CHAL_NAME):challenge

.PHONY:generator
generator: src.tar.gz
	cp src.tar.gz generator
	docker build generator -t $(CHAL_NAME):generator

.PHONY:solver
solver: 
	docker build solver -t $(CHAL_NAME):solver

.PHONY: static
static: 
	mkdir -p static
	docker run -it --rm -v `pwd`/static:/out -e "SEED=${SEED}" ${CHAL_NAME}:generator

.PHONY:test
test: 
	socat -v tcp-listen:19020,reuseaddr exec:"docker run --rm -i -e FLAG=flag{zulu49225delta\:GG1EnNVMK3-hPvlNKAdEJxcujvp9WK4rEchuEdlDp3yv_Wh_uvB5ehGq-fyRowvwkWpdAMTKbidqhK4JhFsaz1k} -e SEED=${SEED} ${CHAL_NAME}\:challenge" > log 2>&1 & 
	docker run --rm -it -e HOST=${CHAL_HOST} -e PORT=19020 ${CHAL_NAME}:solver


src.tar.gz: 
	tar -cf src.tar.gz --exclude=my_filter.m src
