CHAL_NAME ?= patch
CHAL_PORT ?= 31370
CHAL_HOST ?= 172.17.0.1
SEED ?= 1

build: $(SUBDIRS) challenge generator solver static

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

.PHONY:test
test: 
	rm -rf data/*
	docker run -it --rm -v `pwd`/data:/out -e "SEED=${SEED}" ${CHAL_NAME}:generator
	socat -v tcp-listen:19020,reuseaddr exec:"docker run --rm -i -e SERVICE_HOST=${CHAL_HOST} -e SERVICE_PORT=19021 -e SEED=${SEED} -e FLAG=flag{zulu49225delta\:GG1EnNVMK3-hPvlNKAdEJxcujvp9WK4rEchuEdlDp3yv_Wh_uvB5ehGq-fyRowvwkWpdAMTKbidqhK4JhFsaz1k} -p 19021\:54321 ${CHAL_NAME}\:challenge" > log 2>&1 &
	docker run -it --rm -v `pwd`/data:/data -e "HOST=${CHAL_HOST}" -e "PORT=19020" -e "FILE=/data/kit_to.so" ${CHAL_NAME}:solver

.PHONY:generate
generate:
	docker run -it --rm -v `pwd`/data:/out -e "SEED=${SEED}" ${CHAL_NAME}:generator

static: cosmos.tar.gz
	mkdir -p static
	cp $^ static 

cosmos.tar.gz: cosmos
	tar -cf $@ $< 


