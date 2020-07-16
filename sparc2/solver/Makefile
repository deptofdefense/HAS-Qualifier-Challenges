TOOLS = "rtems5-tools:leon3-softfloat"
QEMU  = "qemu:sparc"

assemble: code.bin debug.bin

code.bin: code.s
	sparc-rtems5-as -o code.elf $< 
	sparc-rtems5-objcopy -O binary code.elf $@

debug.bin: debug.s
	sparc-rtems5-as -o debug.elf $<
	sparc-rtems5-objcopy -O binary debug.elf $@

.PHONY: shell
shell:
	docker run --rm -it -v `pwd`/:/src ${TOOLS} /bin/bash

.PHONY: clean
clean:
	rm -f *.hex *.bin *.elf
