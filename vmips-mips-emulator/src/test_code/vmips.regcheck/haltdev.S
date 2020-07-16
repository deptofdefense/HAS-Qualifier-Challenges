#include "asm_regnames.h"
#include "haltreg.h"

	.text
	.globl __start
__start:
	li a0, HALT_ADDR
    li a1, 1
	sw a1, HALT_CONTROL(a0)
	break

