CHAL_NAME ?= major_tom
CHAL_PORT ?= 31337
CHAL_HOST ?= 172.17.0.1
SEED ?= 1
build: solver generator

.PHONY:generator
generator:
	docker build generator -t $(CHAL_NAME):generator

.PHONY:solver
solver: 
	docker build solver -t $(CHAL_NAME):solver

.PHONY: test
test:
	rm -f data/*
	docker run --rm -it -v `pwd`/data:/out -e SEED=${SEED} -e FLAG="flag{zulu49225delta:GEuHu-lkVHZUryVLA926sLeEqnjP4C6ELc4fglSzpy92FOaFnGwcwWRB-Y_zDPijwJJzub-e5qr79IsIfgv3BiU}" $(CHAL_NAME):generator
	docker run -it --rm  -v `pwd`/data:/mnt  $(CHAL_NAME):solver


