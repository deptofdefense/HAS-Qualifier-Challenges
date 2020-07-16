CHAL_NAME ?= rogue
CHAL_PORT ?= 31328
CHAL_HOST ?= 172.17.0.1
SEED ?= 3617054001913428290

build: generator challenge solver

.PHONY: challenge
challenge:
	docker build challenge -t ${CHAL_NAME}:challenge --build-arg DEFAULT_SEED=${SEED}

.PHONY: generator
generator:
	docker build generator -t ${CHAL_NAME}:generator --build-arg DEFAULT_SEED=${SEED}

.PHONY: solver
solver:
	docker build solver -t ${CHAL_NAME}:solver

.PHONY: solve
solve:
	docker run -it --rm -v `pwd`/data:/data -e "DIR=/data" ${CHAL_NAME}:solver

.PHONY: generate
generate:
	docker run -it --rm -v `pwd`/data:/out -e "SEED=${SEED}" ${CHAL_NAME}:generator

.PHONY: test
test:
	rm -rf data/*
	docker run -i --rm -v `pwd`/data:/out -e "SEED=${SEED}" ${CHAL_NAME}:generator
	socat -v tcp-listen:19006,reuseaddr exec:"docker run --rm -i -e SEED=${SEED} -e FLAG=flag{foobar_baz_babe-1234} rogue\:challenge" > log 2>&1 &
	docker run -i --rm -v `pwd`/data:/data -e "HOST=${CHAL_HOST}" -e "PORT=19006" -e "DIR=/data"  ${CHAL_NAME}:solver

.PHONY: test-final
test-final:
	docker run -it --rm -v `pwd`/final:/data -e "HOST=ec2-18-222-195-54.us-east-2.compute.amazonaws.com" -e "PORT=5025" -e "DIR=/data" -e "TICKET=ticket{india29741alpha:GOxsP-E4UYdk-w1dT9UHpMVYddXndpMz2ywbuMCgEvjzgGGikhxP9cXix_rRm7yvtw}" ${CHAL_NAME}:solver



.PHONY: test-aws
test-aws:
	rm -rf data/*
	docker run -it --rm -v `pwd`/data:/out -e "SEED=3617054001913428290" ${CHAL_NAME}:generator
	docker run -it --rm -v `pwd`/data:/data -e "HOST=${EC2_QA}" -e "PORT=5015" -e "DIR=/data" -e "TICKET=ticket{xray96162uniform:GG8HCiliWkeIoc4ad59QnRE_H3Icnt4QTvraZ1Tq-zK4-gcp4eP-5g3umU21fP9mHA}" ${CHAL_NAME}:solver
	docker run -it --rm -v `pwd`/data:/out -e "SEED=3833226784027212098" ${CHAL_NAME}:generator
	docker run -it --rm -v `pwd`/data:/data -e "HOST=${EC2_QA}" -e "PORT=5015" -e "DIR=/data" -e "TICKET=ticket{delta3521charlie:GM6Q0JHgjQHu50lJGjjnzRasZQ3PvF0pmvqOdXMLJO6Q5QKWZuSbwuo1JoyFCz_jnQ}" ${CHAL_NAME}:solver
