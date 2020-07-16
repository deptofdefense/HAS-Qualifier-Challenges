CHAL_NAME ?= beckley
CHAL_PORT ?= 19020
CHAL_HOST ?= 172.17.0.1
SEED ?= 1000

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
	socat -v tcp-listen:${CHAL_PORT},reuseaddr exec:"docker run --rm -i -e SERVICE_HOST=${CHAL_HOST} -e SERVICE_PORT=19021 -e SEED=${SEED} -e FLAG=flag{zulu49225delta\:GG1EnNVMK3-hPvlNKAdEJxcujvp9WK4rEchuEdlDp3yv_Wh_uvB5ehGq-fyRowvwkWpdAMTKbidqhK4JhFsaz1k} -p 19021\:80 ${CHAL_NAME}\:challenge" > log 2>&1 &
	docker run -it --rm -e "HOST=${CHAL_HOST}" -e "PORT=${CHAL_PORT}" ${CHAL_NAME}:solver

