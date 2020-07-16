/* store to uncached memory, read from cached memory */

#include "asm_regnames.h"

		.text

		.globl entry
		.ent entry
entry:
		li	t0, 0xa0001000	/* get ubase into t0 */
		li	t1, 0x20000000	/* get kseg0->kseg1 diff into t1 */
		subu	t1, t0, t1

		li	t2, 0xdeadbeef

		sw	t2, 0(t0)	/* store deadbeef to ubase */
		lw	t3, 0(t1)	/* read word back from base-should miss */
		lw	t4, 0(t1)	/* read word back from base-should hit */

		addiu	t0, t0, 4
		addiu	t1, t1, 4
		li	t2, 0xdfacb0ec
		sw	t2, 0(t0)	/* store dfacb0ec to ubase */
		lhu	t5, 0(t1)	/* read halfword back from base-should miss */
		lhu	t6, 2(t1)	/* read halfword back from base-should hit  */
		lhu	t7, 0(t1)	/* read halfword back from base-should hit  */

		addiu	t0, t0, 4
		addiu	t1, t1, 4
		li	t2, 0xddabb2ed
		sw	t2, 0(t0)	/* store ddabb2ed to ubase */
		lbu	s0, 0(t1)	/* read byte back from base-should miss */
		lbu	s1, 1(t1)	/* read byte back from base-should hit  */
		lbu	s2, 2(t1)	/* read byte back from base-should hit  */
		lbu	s3, 3(t1)	/* read byte back from base-should hit  */

		jr	ra
		.end entry

