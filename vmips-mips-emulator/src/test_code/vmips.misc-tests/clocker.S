/* Clock interrupt test code - print a dot every second. */

#include "asm_regnames.h"
#include "spimconsreg.h"

#define MEM_BASE		0xa0000000
#define IOBASE			0xa2000000
#define MEM_SIZE		32768
#define INIT_STACK_BASE		MEM_BASE + (MEM_SIZE/2) - 4

	.text

	j __start                    /* Let's skip down to the boring stuff. */

	.org 0x180
intrp:
        mfc0 k0,EPC                /* Read the exception program counter. */

	li k1, IOBASE+CLOCK_CONTROL /* Get address of clock control reg. */
	lw k1, 0(k1)               /* Read it.  */
	andi k1, k1, CTL_RDY       /* Check the ready bit. */
	beq k1, zero, iret1           /* If not ready, ignore this interrupt. */

printadot:
	/* Poll for the display. */
	li k1, IOBASE+DISPLAY_1_CONTROL /* Get address of display ctrl reg. */
	lw k1, 0(k1)                   /* Read it. */
	andi k1, k1, CTL_RDY           /* Is the display ready? */
	beq k1, zero, printadot           /* If not, then loop. */
	li k1, IOBASE+DISPLAY_1_DATA    /* Get address of display data reg. */
	li t0, '.'                      /* Load a dot. */
	sw t0, 0(k1)                   /* Write it to the display. */

iret1:
	/* Check the keyboard (we didn't turn interrupts on, so we're 
	 * depending on taking clock interrupts. We'll test kybd/display ints
	 * later (no, really!)). */
	li k1, IOBASE+KEYBOARD_1_CONTROL
	lw k1, 0(k1)                   /* Read it. */
	andi k1, k1, CTL_RDY           /* Is the keyboard ready? */
	addu v0, k1, v0

iret:
	rfe                          /* Restore status bits on the way out. */
	jr k0                       /* "Our work here is done." */

	.globl __start
__start:
	/* Initialize the stack pointer. */
	li sp, INIT_STACK_BASE

	/* Turn interrupts on in the clock device. */
	li a1, IOBASE+CLOCK_CONTROL
	li a0, CTL_IE
	sw a0, 0(a1)

	/* Turn interrupts on in the CP0. */
	mfc0 a0, Status
	ori a0, a0, 0x0401		/* IM2 and IEc */
	mtc0 a0, Status

	/* Sit and stew until something happens. */
	move v0, zero 
loop:	beq v0, zero, loop
	break 0x0
