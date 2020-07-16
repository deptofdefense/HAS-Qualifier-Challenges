/* Test case for #505637: expect R02=00000001 and R08=00000001,
 * because we want the entire interrupt handler to be executed exactly once.
 * Based on clocker.S.
 */
#include "asm_regnames.h"
#include "spimconsreg.h"
#define IOBASE			0xa2000000
	.text
	.globl __start
__start:
	/* Turn interrupts on in the clock device. */
	li a1, IOBASE+CLOCK_CONTROL
	li a0, CTL_IE
	sw a0, 0(a1)
	/* Turn interrupts on in the CP0. */
	.set noreorder
	mfc0 a0, Status
	nop
	ori a0, a0, 0x0401		/* IM2 and IEc */
	mtc0 a0, Status
	nop
	nop
	.set reorder
	/* Sit and stew until something happens. */
	move v0, zero 
	move t0, zero 
loop:
	beq v0, zero, loop
	break 0x0

	.org 0x180
intrp:
	addiu t0, t0, 1				/* Must execute this line ONLY ONCE. */

    mfc0 k0,EPC                 /* Read the exception program counter. */
	li k1, IOBASE+CLOCK_CONTROL /* Get address of clock control reg. */
	lw k1, 0(k1)                /* Read it.  */
	andi k1, k1, CTL_RDY        /* Check the ready bit. */
	beq k1, zero, iret          /* If not ready, ignore this interrupt. */
	addiu v0, v0, 1				/* Set the flag that tells us to halt. */
iret:
	rfe                         /* Restore status bits on the way out. */
	jr k0                       /* "Our work here is done." */
