#include "asm_regnames.h"
#include "spimconsreg.h"
#define MEM_ADDR 0xa0000000
#define SPIM_ADDR 0xa2000000
	.text
	.globl	__start
__start:
	/* Writing to device memory with sb requires us to be conscious
	 * of endianness. This will tell us what endianness we are, so
	 * we can write to the least significant byte of the register
	 * (as documented in the manual.) */
	li	t2, 1
	li	t3, MEM_ADDR
	sw	t2, 0(t3)
	lb	t2, 0(t3)
	beqz	t2, BE
LE:	li	t2, 0
	b	chkrdy
BE:	li	t2, 3
chkrdy:
	li	a0, SPIM_ADDR
	add	t2, t2, a0
	addiu	t2, t2, DISPLAY_1_DATA
wait:
	lw	t0, DISPLAY_1_CONTROL(a0)
	andi	t0, t0, CTL_RDY
	beqz	t0, wait
print:
	li	t1, 'Z'
	sb	t1, 0(t2)
done:
	break
	# Halt on user tlb exceptions
	.org	0x100
	break
	# Handle exceptions
	.org	0x180
	break
