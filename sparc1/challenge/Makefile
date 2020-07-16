
SRCPATH=./src/challenge
BUILDPATH=$(SRCPATH)/o-optimize
SRC=chal.c chal.s io.c crc.c
SRCS:=$(addprefix $(SRCPATH)/, $(SRC))
EXE=challenge.exe
CPU_CFLAGS += -msoft-float

TOOLS = "rtems5:tools-sparc"
QEMU  = "qemu:sparc"

$(EXE): $(SRCS)
	docker run --rm -it -v `pwd`/src:/src $(TOOLS) /usr/bin/make
	cp $(BUILDPATH)/$(EXE) .
	
build: 
	docker run --rm -it -v `pwd`/src:/src $(TOOLS) /usr/bin/make

.PHONY:clean
clean:
	docker run --rm -it -v `pwd`/src:/src $(TOOLS) /usr/bin/make clean
	rm -f $(EXE)

.PHONY:test
test: $(EXE)
	docker run --rm -it -v `pwd`/:/src $(QEMU) /src/run.sh ./$(EXE)

debug: $(EXE)
	docker run --rm -i -v `pwd`/:/src $(QEMU) /src/debug.sh ./$(EXE) 

debug-attach:
	docker run --rm -it -v `pwd`/:/src $(TOOLS) sparc-rtems5-gdb ./$(EXE) -ex 'tar remote 172.17.0.2:1234'
