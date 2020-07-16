#include "asm_regnames.h"
	.text
	.globl __start
__start:
	addu v0, v1, a0
	subu a1, a2, a3
	multu t0, t1
	break
