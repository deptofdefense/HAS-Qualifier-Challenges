CHAL_NAME ?= phasor
CHAL_PORT ?= 31401
CHAL_HOST ?= 172.17.0.1

build: generator solver

.PHONY: generator
generator:
	docker build generator -t ${CHAL_NAME}:generator

.PHONY: solver
solver:
	docker build solver -t ${CHAL_NAME}:solver

.PHONY: generate
generate:
	docker run -it --rm -v `pwd`/data:/out -e "SEED=${SEED}" ${CHAL_NAME}:generator

.PHONY: test
test:
	rm -rf data/*
	docker run -it --rm -v `pwd`/data:/out -e "FLAG=flag{zulu49225delta:GEuHu-lkVHZUryVLA926sLeEqnjP4C6ELc4fglSzpy92FOaFnGwcwWRB-Y_zDPijwJJzub-e5qr79IsIfgv3BiU}" ${CHAL_NAME}:generator
	tar czf phasors.tar.gz data
	docker run -it --rm -v `pwd`/data:/data ${CHAL_NAME}:solver
