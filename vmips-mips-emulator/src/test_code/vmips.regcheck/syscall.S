/*  ../vmips -o haltbreak -o haltdumpcpu syscall.rom */
/*  should end with R10=00000000 */
/*  tests instructions: syscall mfc0 rfe jr */

#include "asm_regnames.h"

	.text
	.globl __start
__start:
	li t2, 0			/* count of errors */
	li v0, 4			/* make the syscall */
	syscall
	break				/* we're done */

	.org 0x180
	mfc0 k0, EPC		/* in interrupt handler - save EPC */
	mfc0 k1, Cause		/* save exception Cause */
	li a1, 4
	beq v0, a1, 1f		/* check parameter */
	addiu t2, t2, 1
1:	andi k1, k1, 0x007c	/* get exception code from Cause */
	srl k1, k1, 2		/* shift it to the bottom of the register */
	li a1, Sys
	beq a1, k1, 2f		/* check exception code */
	addiu t2, t2, 1
2:	li v0, -1			/* set return code */
	li a3, 0			/* clear failure flag */
	addiu k0, k0, 4		/* set PC to insn after the syscall */
	rfe					/* come back from exception */
	jr k0				/* return */
