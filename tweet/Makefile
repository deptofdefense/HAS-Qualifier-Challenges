CHAL_NAME ?= tweet
CHAL_PORT ?= 31323
CHAL_HOST ?= 172.17.0.1

build: challenge solver generator 

.PHONY: challenge 
challenge:
	docker build challenge -t ${CHAL_NAME}:challenge

.PHONY: solver
solver:
	docker build solver -t ${CHAL_NAME}:solver

.PHONY: generator
generator:
	docker build generator -t ${CHAL_NAME}:generator

.PHONY:solve
solve:
	docker run -it --rm -e "HOST=${CHAL_HOST}" -e "PORT=${CHAL_PORT}"  ${CHAL_NAME}:solver

.PHONY:generate
generate:
	docker run -it --rm ${CHAL_NAME}:generator

.PHONY: test
test:
	mkdir -p test
	rm -f test/*.tar.gz
	rm -rf test/files
	docker run --rm -v $(PWD)/test:/out -e SEED=3472657338860861762 ${CHAL_NAME}:generator
	docker run --rm -e "HOST=${CHAL_HOST}" -e "PORT=${CHAL_PORT}" -v `pwd`/test:/mnt -e TICKET=ticket{zulu10571quebec:GKP9suZz2eyyEpgOpgn1fvN67EpR2MYxvtrAdVfdUtPjBA1w0QSGxD9cWz4grDWaOg} ${CHAL_NAME}:solver

.PHONY: test-final
test-final:
	docker run --rm -e "HOST=ec2-3-21-171-142.us-east-2.compute.amazonaws.com" -e "PORT=5022" -v `pwd`/final:/mnt -e DIR=/mnt -e TICKET=ticket{india20165papa:GOaNzaROuTIsniCdfeLbn2P6fbfpTLnNpSTwiCzqsLTIALO1VKK7jYjWfLdh7lNAfw} ${CHAL_NAME}:solver

.PHONY: test-aws
test-aws:
	mkdir -p test
	rm -f test/*.jpg
	docker run --rm -v $(PWD)/test:/out -e SEED=3472657338860861762 ${CHAL_NAME}:generator
	tar czf tweet_zulu10571quebec.tar.gz test
	docker run --rm -e "HOST=${EC2_QA}" -e "PORT=5016" -v `pwd`/test:/mnt -e DIR=/mnt -e TICKET=ticket{zulu10571quebec:GKP9suZz2eyyEpgOpgn1fvN67EpR2MYxvtrAdVfdUtPjBA1w0QSGxD9cWz4grDWaOg} ${CHAL_NAME}:solver
	rm -f test/*.jpg
	docker run --rm -v $(PWD)/test:/out -e SEED=3832945309050501442 ${CHAL_NAME}:generator
	tar czf tweet_zulu49225delta.tar.gz test
	docker run --rm -e "HOST=${EC2_QA}" -e "PORT=5016" -v `pwd`/test:/mnt -e DIR=/mnt -e TICKET=ticket{zulu49225delta:GOTiuy5qZHe9pz1v0x3r53PW_UNMDAxrgSDinuBHefq3TDMsX21k9G7Gn64pPdJEwA} ${CHAL_NAME}:solver
