CHAL_NAME ?= spacerace
CHAL_PORT ?= 31556
CHAL_HOST ?= 172.17.0.1

build: $(SUBDIRS) challenge solver generator static

.PHONY:challenge
challenge: kubos.tar.gz 
	docker build challenge -t ${CHAL_NAME}:challenge

.PHONY:solver
solver: 
	docker build solver -t ${CHAL_NAME}:solver

.PHONY:generator
generator: 
	docker build generator -t ${CHAL_NAME}:generator

.PHONY:solve
solve:
	docker run -it --rm -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)"  ${CHAL_NAME}:solver

.PHONY:static
static: 
	mkdir -p static
	docker run -it --rm -v `pwd`/static:/out ${CHAL_NAME}:generator

kubos.tar.gz: kubos
	tar -cf $@ $^
	cp $@ challenge


.PHONY:test
test:
	socat -v tcp-listen:19020,reuseaddr exec:"docker run --rm -i -e SEED=256 -e FLAG=flag{zulu49225delta\:GG1EnNVMK3-hPvlNKAdEJxcujvp9WK4rEchuEdlDp3yv_Wh_uvB5ehGq-fyRowvwkWpdAMTKbidqhK4JhFsaz1k} -e SERVICE_HOST=172.17.0.1 -e SERVICE_PORT=19021 spacerace\:challenge" & 
	docker run -it --rm -e "HOST=172.17.0.1" -e "PORT=19020" ${CHAL_NAME}:solver
