#SEED := $(shell python -S -c "import random; print(random.randrange(1,99999999999999999999))")
CHAL_NAME ?= rbs_m2
SEED ?= 3379492334

build: generator solver challenge

.PHONY: challenge solver generator generate test
challenge:
	docker build -t ${CHAL_NAME}:challenge -f challenge/Dockerfile .

solver:
	docker build -t ${CHAL_NAME}:solver -f solver/Dockerfile .

generator:
	docker build -t ${CHAL_NAME}:generator -f generator/Dockerfile .

test:
	mkdir -p data
	rm -rf data/*
	docker run -e SEED=${SEED}  -it --rm -v ${PWD}/data:/out ${CHAL_NAME}:generator > gen.log 2>&1 
	socat -v tcp-listen:19020,reuseaddr exec:"docker run --rm -i -e FLAG=flag{zulu49225delta\:GG1EnNVMK3-hPvlNKAdEJxcujvp9WK4rEchuEdlDp3yv_Wh_uvB5ehGq-fyRowvwkWpdAMTKbidqhK4JhFsaz1k} -e SEED=${SEED} ${CHAL_NAME}\:challenge" > run.log 2>&1 &
	docker run -it --rm -v ${PWD}/data:/data -e DIR=/data -e HOST=172.17.0.1 -e PORT=19020 ${CHAL_NAME}:solver

