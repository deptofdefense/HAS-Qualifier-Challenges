CHAL_NAME ?= basic-file

build: generator solver



.PHONY:generator
generator:
	docker build generator -t $(CHAL_NAME):generator

.PHONY:solver
solver: 
	docker build solver -t $(CHAL_NAME):solver



.PHONY:test
test:
	rm -rf data/*
	docker run -it --rm -v $(PWD)/data:/out -e "FLAG=flag{zulu49225delta:GEuHu-lkVHZUryVLA926sLeEqnjP4C6ELc4fglSzpy92FOaFnGwcwWRB-Y_zDPijwJJzub-e5qr79IsIfgv3BiU}" $(CHAL_NAME):generator
	docker run -it --rm -v $(PWD)/data:/mnt -e "DIR=/mnt" $(CHAL_NAME):solver
