
SRCPATH=./src/challenge
BUILDPATH=$(SRCPATH)/o-optimize
SRC=chal.c s_malloc.c test.c io.c msglib.c mission.c
SRCS:=$(addprefix $(SRCPATH)/, $(SRC))
ELF=challenge.elf
EXE=challenge.exe

TOOLS = "rtems5:tools-sparc"
QEMU  = "qemu:sparc"

$(ELF): $(SRCS)
	docker run --rm -it -v `pwd`/src:/src $(TOOLS) /usr/bin/make
	cp $(BUILDPATH)/$(EXE) ./$(ELF)
	
build: 
	docker run --rm -it -v `pwd`/src:/src $(TOOLS) /usr/bin/make

.PHONY:test_malloc
test_malloc: test_malloc.exe
	docker run --rm -it -v `pwd`/:/src $(QEMU) /src/run.sh ./test_malloc.elf

test_malloc.exe: 
	docker run --rm -it -v `pwd`/src:/src $(TOOLS) /usr/bin/make
	cp ./src/space_malloc/o-optimize/test_malloc.exe ./test_malloc.elf

.PHONY:clean
clean:
	docker run --rm -it -v `pwd`/src:/src $(TOOLS) /usr/bin/make clean
	rm -f challenge.elf
	rm -f test_malloc.elf

.PHONY:test
test: 
	docker run --rm -it -v `pwd`/:/src $(QEMU) /src/run.sh ./$(ELF)

debug: 
	docker run --rm -i -v `pwd`/:/src $(QEMU) /src/debug.sh ./src/challenge/o-optimize/$(EXE) 

debug-attach:
	docker run --rm -it -v `pwd`/:/src $(TOOLS) sparc-rtems5-gdb ./src/challenge/o-optimize/$(EXE) -ex 'tar remote 172.17.0.2:1234' -ex 'dir src/challenge'

shell:
	docker run --rm -it -v `pwd`/:/src $(TOOLS) /bin/bash

qemu-shell:
	docker run --rm -it -v `pwd`/:/src $(QEMU) /src/serial.sh ./$(ELF)
