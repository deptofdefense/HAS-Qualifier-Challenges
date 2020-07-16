/* Store bytes/halfwords/words to cached memory. Make sure they load
   back correctly from *cached* memory.  (This test loads from
   cached memory, which is what makes it different from cstore.S.) */

#include "asm_regnames.h"

		.text

		.globl entry
		.ent entry
entry:
		li	t0, 0x80001000	/* get base into t0 */

		li	t2, 0x12345678

		sw	t2, 0(t0)	/* store 12345678 to base */
		lw	t3, 0(t0)	/* read word back from base-should hit */

		addiu	t0, t0, 4
		li	t2, 0x9abc
		sh	t2, 0(t0)	/* store 9abc to base */
		li	t2, 0xdef0
		sh	t2, 2(t0)	/* store def0 to base */
		lhu	t4, 0(t0)	/* read halfword back from base-should hit */
		lhu	t5, 2(t0)	/* read halfword back from base-should hit */
		lw	t6, 0(t0)	/* read word back from base    -should hit */

		addiu	t0, t0, 4
		li	t2, 0xa1
		sb	t2, 0(t0)	/* store a1 to base */
		li	t2, 0xb2
		sb	t2, 1(t0)	/* store b2 to base */
		li	t2, 0xc3
		sb	t2, 2(t0)	/* store c3 to base */
		li	t2, 0xd4
		sb	t2, 3(t0)	/* store d4 to base */
		lbu	s0, 0(t0)	/* read byte back from base-should hit */
		lbu	s1, 1(t0)	/* read byte back from base-should hit */
		lbu	s2, 2(t0)	/* read byte back from base-should hit */
		lbu	s3, 3(t0)	/* read byte back from base-should hit */
		lw	s4, 0(t0)	/* read word back from base-should hit */

		jr	ra
		.end entry

