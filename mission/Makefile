CHAL_NAME ?= mission
CHAL_PORT ?= 31344
CHAL_HOST ?= 172.17.0.1

build: challenge solver

.PHONY: solve
solve:
	docker run -it --rm -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)" -e "TICKET=${TICKET}" $(CHAL_NAME):solver



.PHONY:challenge
challenge:
	docker build challenge -t $(CHAL_NAME):challenge

.PHONY:solver
solver:
	docker build solver -t $(CHAL_NAME):solver

.PHONY: test
test:
	socat -v tcp-listen:${CHAL_PORT},reuseaddr exec:"docker run --rm -i -e SEED=$(SEED) -e FLAG=flag{1234}  ${CHAL_NAME}\:challenge" > run.log 2>&1 &
	docker run --rm -e HOST=${CHAL_HOST} -e PORT=${CHAL_PORT} ${CHAL_NAME}:solver

