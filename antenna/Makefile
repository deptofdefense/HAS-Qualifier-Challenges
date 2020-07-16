CHAL_NAME ?= antenna
CHAL_PORT ?= 31331
CHAL_HOST ?= 172.17.0.1

SEED := 1234

build: challenge solver

.PHONY:challenge
challenge:
	docker build -t ${CHAL_NAME}:challenge -f challenge-Dockerfile .

.PHONY:solver
solver:
	docker build -t ${CHAL_NAME}:solver -f solver-Dockerfile .

.PHONY:test
test:
	socat -v tcp-listen:${CHAL_PORT},reuseaddr exec:"docker run --rm -i -e SEED=$(SEED) -e FLAG=flag{1234}  ${CHAL_NAME}\:challenge" > run.log 2>&1 &
	docker run --rm -e HOST=${CHAL_HOST} -e PORT=${CHAL_PORT} ${CHAL_NAME}:solver

