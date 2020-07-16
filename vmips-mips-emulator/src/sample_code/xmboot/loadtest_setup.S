/* loadtest_setup.S
 *
 * Starts a new program (loadtest.c) in RAM.
 */
#include "asm_regnames.h"

	.text
	.org 0x0
	break

	.globl __start
	.ent __start
__start:
	j realstart

	.org 0x080
	break
	.org 0x180
	break

	.org 0x200
realstart:
	/* Save return address and globals pointer on stack. */
	/* (2 extra words for arguments to main) */
	addiu sp, sp, -16
	sw ra, 12(sp)
	sw gp, 8(sp)

	/* Set up the globals pointer. */
	la gp, _gp

	/* Call the function. */
	jal MyMain

	/* Restore return address, globals pointer, and stack pointer. */
	lw ra, 12(sp)
	lw gp, 8(sp)
	addiu sp, sp, 16

	/* Return to caller (in ROM). */
	jr ra
	.end __start
