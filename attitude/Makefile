CHAL_NAME ?= attitude
CHAL_PORT ?= 31312
CHAL_HOST ?= 172.17.0.1
SEED ?= 3472657338860861762 
build: challenge solver generator

.PHONY:challenge
challenge:
	docker build challenge -t ${CHAL_NAME}:challenge

.PHONY:solver
solver:
	docker build solver -t ${CHAL_NAME}:solver

.PHONY:generator
generator:
	docker build generator -t ${CHAL_NAME}:generator

.PHONY:solve
solve:
	docker run -it --rm -e "HOST=${CHAL_HOST}" -e "PORT=${CHAL_PORT}"  ${CHAL_NAME}:solver

.PHONY:generate
generate:
	mkdir -p test
	rm -rf test/*
	docker run --rm -v $(PWD)/test:/out -e SEED=3472657338860861762 ${CHAL_NAME}:generator

.PHONY:test-final
test-final:
	docker run -it --rm -v $(PWD)/final:/mnt -e DIR=/mnt -e HOST=attitude.satellitesabove.me -e PORT=5012 -e TICKET=ticket{whiskey964hotel:GNHO42vNpjNyDdaWBP6yS_VjKUwtNI67tHocd6G1HS_jTnAMv7eziwRr8TdpOCi5uA} ${CHAL_NAME}:solver

.PHONY:test
test:
	mkdir -p test
	rm -rf test/*
	docker run --rm -v $(PWD)/test:/out -e SEED=$(SEED) ${CHAL_NAME}:generator
	socat -v tcp-listen:${CHAL_PORT},reuseaddr exec:"docker run --rm -i -e SEED=$(SEED) -e FLAG=flag{1234}  ${CHAL_NAME}\:challenge" > run.log 2>&1 &
	docker run --rm -e HOST=${CHAL_HOST} -e PORT=${CHAL_PORT} -e DIR=/mnt -v $(PWD)/test:/mnt  ${CHAL_NAME}:solver

