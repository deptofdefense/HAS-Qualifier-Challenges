CHAL_NAME ?= myspace
CHAL_PORT ?= 31318
CHAL_HOST ?= 172.17.0.1

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
	docker run -it --rm ${CHAL_NAME}:generator

.PHONY:test
test:
	mkdir -p test
	rm -f test/*.txt
	docker run --rm -v $(PWD)/test:/out -e SEED=1465500232115169100 ${CHAL_NAME}:generator
	socat -v tcp-listen:19010,reuseaddr exec:"docker run --rm -i -e SEED=1465500232115169100 -e FLAG=flag{foobar\:baz_babe-1234} spacebook\:challenge" > log 2>&1 & 
	docker run --rm -e HOST=${CHAL_HOST} -e PORT=19010 -e DIR=/mnt -v $(PWD)/test:/mnt  ${CHAL_NAME}:solver

