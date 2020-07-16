/*  ../vmips -o haltdumpcpu -o haltbreak mthi_lo.rom */
/*  should end with:  R09=7ffffffe R10=80000001  R12=ffffffff  R13=80000001 */
/*  tests instructions: mult multu */

#include "asm_regnames.h"
	.text
	.globl __start
__start:
	li t0, 0xffffffff
	li t3, 0x7fffffff
	multu t0, t3
	mfhi t1
	mflo t2
	mult t0, t3
	mfhi t4
	mflo t5
	break
