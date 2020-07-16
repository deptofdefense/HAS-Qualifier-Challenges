CHAL_NAME ?= verizon
CHAL_PORT ?= 31333
CHAL_HOST ?= 172.17.0.1
SEED ?= 1234

build: challenge solver

.PHONY:challenge
challenge:
	docker build challenge -t ${CHAL_NAME}:challenge

.PHONY:solver
solver:
	docker build solver -t ${CHAL_NAME}:solver

.PHONY:solve
solve:
	docker run -it --rm -e "HOST=${CHAL_HOST}" -e "PORT=${CHAL_PORT}"  ${CHAL_NAME}:solver

.PHONY:test
test: 
	socat -v tcp-listen:${CHAL_PORT},reuseaddr exec:"docker run --rm -i -p 31336\:8123 -e SEED=$(SEED) -e FLAG=flag{1234} -e SERVICE_HOST=${CHAL_HOST} -e SERVICE_PORT=31336 ${CHAL_NAME}\:challenge" > run.log 2>&1 &
	docker run -it --rm -e "HOST=${CHAL_HOST}" -e "PORT=${CHAL_PORT}" ${CHAL_NAME}:solver



