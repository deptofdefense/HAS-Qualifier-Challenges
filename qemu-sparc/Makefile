shell:
	docker run --rm -it -v ~/work/sparc/share:/share qemu:sparc /bin/bash

.PHONY: qemu_sparc
qemu_sparc:
	docker build . -t qemu:sparc

.PHONY: test
test:
	docker run --rm -it -v ~/work/sparc/share:/share qemu:sparc qemu-system-sparc -no-reboot -nographic -M leon3_generic -m 64M -kernel /share/capture.exe

.PHONY: docker_export
docker_export:
	docker image save qemu:sparc > qemu_sparc.docker

.PHONY: docker_import
docker_import: 
	docker image load < qemu_sparc.docker
