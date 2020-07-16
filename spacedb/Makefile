CHAL_NAME ?= spacedb
CHAL_PORT ?= 19010
CHAL_HOST ?= 172.17.0.1

build: $(SUBDIRS) challenge solver

.PHONY:challenge
challenge: 
	docker build -f challenge/Dockerfile . -t ${CHAL_NAME}:challenge

.PHONY:solver
solver: 
	docker build solver -t ${CHAL_NAME}:solver

.PHONY:solve
solve:
	docker run -it --rm -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)"  ${CHAL_NAME}:solver


.PHONY: test
test:
	socat -v tcp-listen:$(CHAL_PORT),reuseaddr exec:"docker run --rm -i -e SEED=17071873883460436682 -e FLAG=flag{foobar\:baz_babe-1234} -e SERVICE_HOST=$(CHAL_HOST) -e SERVICE_PORT=19011 -p 19011\:8888 spacedb\:challenge" > log 2>&1 &  
	docker run -t --rm -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)"  ${CHAL_NAME}:solver

