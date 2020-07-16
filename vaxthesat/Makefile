CHAL_NAME = vaxthesat
SEED ?= 3832945923050501442 

build: generator solver challenge


.PHONY:challenge
challenge:
	docker build -f challenge/Dockerfile . -t $(CHAL_NAME):challenge

.PHONY: challenge_shell
challenge_shell:
	docker run --rm -it $(CHAL_NAME):challenge

.PHONY:generator
generator:
	docker build -f generator/Dockerfile . -t $(CHAL_NAME):generator

.PHONY: generate
generate:
	docker run --rm -it -v `pwd`:/tmp $(CHAL_NAME):generator

.PHONY:solver
solver: solver
	docker build -f solver/Dockerfile . -t $(CHAL_NAME):solver

.PHONY: solve
solve:
	docker run --rm -it --net=host $(CHAL_NAME):solver

.PHONY: test
test: 
	socat -v tcp-listen:19006,reuseaddr exec:"docker run --rm -i -e SEED=$(SEED) -e FLAG=flag{zulu49225delta\:GG1EnNVMK3-hPvlNKAdEJxcujvp9WK4rEchuEdlDp3yv_Wh_uvB5ehGq-fyRowvwkWpdAMTKbidqhK4JhFsaz1k} vaxthesat\:challenge" > log 2>&1 &
	docker run --rm -it -e PORT=19006 -e HOST=172.17.0.1 -e SEED=$(SEED) vaxthesat:solver

