
#include "asm_regnames.h"

	.text
	.globl __start
__start:
	move t0, zero
	lui t0, 0x8000         /* t0 = most negative number */
	addiu t1, zero, 0xffff   /* t1 = -1 */
	add t0, t0, t1       /* cause an overflow trap. */

	.org 0x180
	break

