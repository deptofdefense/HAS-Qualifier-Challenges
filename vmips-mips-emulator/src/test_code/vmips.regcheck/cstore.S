/* Store bytes/halfwords/words to cached memory. Make sure they load
   back correctly from uncached memory. */

#include "asm_regnames.h"

		.text

		.globl entry
		.ent entry
entry:
		li	t0, 0xa0001000	/* get ubase into t0 */
		li	t1, 0x20000000	/* get kseg0->kseg1 diff into t1 */
		subu	t1, t0, t1

		li	t2, 0x12345678

		sw	t2, 0(t1)	/* store 12345678 to base */
		lw	t3, 0(t0)	/* read word back from ubase-should hit */

		addiu	t0, t0, 4
		addiu	t1, t1, 4
		li	t2, 0x9abc
		sh	t2, 0(t1)	/* store 9abc to base */
		li	t2, 0xdef0
		sh	t2, 2(t1)	/* store def0 to base */
		lhu	t4, 0(t0)	/* read halfword back from ubase-should hit */
		lhu	t5, 2(t0)	/* read halfword back from ubase-should hit */
		lw	t6, 0(t0)	/* read word back from ubase    -should hit */

		addiu	t0, t0, 4
		addiu	t1, t1, 4
		li	t2, 0xa1
		sb	t2, 0(t1)	/* store a1 to base */
		li	t2, 0xb2
		sb	t2, 1(t1)	/* store b2 to base */
		li	t2, 0xc3
		sb	t2, 2(t1)	/* store c3 to base */
		li	t2, 0xd4
		sb	t2, 3(t1)	/* store d4 to base */
		lbu	s0, 0(t1)	/* read byte back from ubase-should hit */
		lbu	s1, 1(t1)	/* read byte back from ubase-should hit */
		lbu	s2, 2(t1)	/* read byte back from ubase-should hit */
		lbu	s3, 3(t1)	/* read byte back from ubase-should hit */
		lw	s4, 0(t1)	/* read word back from ubase-should hit */

		jr	ra
		.end entry

