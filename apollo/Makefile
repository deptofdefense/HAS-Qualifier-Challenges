CHAL_NAME ?= apollo
CHAL_PORT ?= 19008
CHAL_HOST ?= 172.17.0.1
SEED ?= 1234
build: challenge solver

.PHONY: challenge
challenge:
	docker build challenge -t ${CHAL_NAME}:challenge

.PHONY: solver
solver:
	docker build solver -t ${CHAL_NAME}:solver

.PHONY: test
test:
	socat -v tcp-listen:${CHAL_PORT},reuseaddr exec:"docker run --rm -i -e SERVICE_HOST=${CHAL_HOST} -e SERVICE_PORT=${CHAL_PORT} -p ${CHAL_PORT}\:19697 -e SEED=$(SEED) -e FLAG=flag{zulu\:GG1EnNVMK3} apollo\:challenge" > log 2>&1 &
	docker run -it --rm -e "HOST=${CHAL_HOST}" -e "PORT=${CHAL_PORT}" ${CHAL_NAME}:solver

