CHAL_NAME ?= basic-service
CHAL_PORT ?= 12345
CHAL_HOST ?= 172.17.0.1

build: challenge solver



.PHONY:challenge
challenge:
	docker build challenge -t $(CHAL_NAME):challenge

.PHONY:solver
solver: 
	docker build solver -t $(CHAL_NAME):solver



.PHONY:test
test:
	docker run -it --rm -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)" -e "TICKET=ticket{zulu10571quebec:GKP9suZz2eyyEpgOpgn1fvN67EpR2MYxvtrAdVfdUtPjBA1w0QSGxD9cWz4grDWaOg}" $(CHAL_NAME):solver
	docker run -it --rm -e "HOST=$(CHAL_HOST)" -e "PORT=$(CHAL_PORT)" -e "TICKET=ticket{zulu49225delta:GOTiuy5qZHe9pz1v0x3r53PW_UNMDAxrgSDinuBHefq3TDMsX21k9G7Gn64pPdJEwA}" $(CHAL_NAME):solver

.PHONY:test-aws
	docker run -it --rm -e "HOST=$(EC2_QA)" -e "PORT=$(6001)" -e "TICKET=ticket{zulu10571quebec:GKP9suZz2eyyEpgOpgn1fvN67EpR2MYxvtrAdVfdUtPjBA1w0QSGxD9cWz4grDWaOg}" $(CHAL_NAME):solver
	docker run -it --rm -e "HOST=$(EC2_QA)" -e "PORT=$(6001)" -e "TICKET=ticket{zulu49225delta:GOTiuy5qZHe9pz1v0x3r53PW_UNMDAxrgSDinuBHefq3TDMsX21k9G7Gn64pPdJEwA}" $(CHAL_NAME):solver
