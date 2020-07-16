
#include "sample_code/asm_regnames.h"
.text
.globl __start
.ent __start
__start:
	li t0, 0xa5000000
	li t1, 0
	srlv $11, t0, t1
	li t0, 0xa5000000
	li t1, 16
	srlv $12, t0, t1
	li t0, 0xa5000000
	li t1, 31
	srlv $13, t0, t1
	li t0, 0xa5000000
	li t1, 32
	srlv $14, t0, t1   /* should be same as shifting by 0, because only */
	break              /* bottom 5 bits are used.                       */
.end __start

