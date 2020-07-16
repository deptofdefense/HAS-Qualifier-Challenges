CHAL_NAME ?= rfmagic
CHAL_PORT ?= 31331
CHAL_HOST ?= 172.17.0.1

SEED := $(shell python -S -c "import random; print(random.randrange(1,99999999999999999999))")

build: challenge generator solver static

.PHONY: challenge
challenge:
	docker build -t ${CHAL_NAME}:challenge -f challenge/Dockerfile . 

.PHONY:solver
solver: 
	docker build solver -t ${CHAL_NAME}:solver

.PHONY:generator
generator: challenge 
	docker build -f generator/Dockerfile . -t ${CHAL_NAME}:generator

.PHONY:static
static: 
	mkdir -p static 
	docker run -it --rm -v ${PWD}/static:/out ${CHAL_NAME}:generator

.PHONY: test
test:
	socat -v tcp-listen:19020,reuseaddr exec:'docker run --rm -i -e "FLAG=flag{zulu49225delta\:GG1EnNVMK3-hPvlNKAdEJxcujvp9WK4rEchuEdlDp3yv_Wh_uvB5ehGq-fyRowvwkWpdAMTKbidqhK4JhFsaz1k}" ${CHAL_NAME}\:challenge' > log 2>&1 &
	docker run -it --rm -e HOST=${CHAL_HOST} -e PORT=19020 ${CHAL_NAME}:solver

