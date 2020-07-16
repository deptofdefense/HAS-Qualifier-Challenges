/*  ../vmips -o haltdumpcpu -o haltbreak load.rom */
/*  tests instructions: lw lh lb lhu lbu */

#include "asm_regnames.h"


		.text

		.globl __start
		.ent __start
__start:
		la	t0, loser
		lw	t1, 0(t0)
		la	t0, hoser
		lh	t2, 0(t0)
		lhu	t4, 0(t0)
		la	t0, booger
		lb	t3, 0(t0)
		lbu	t5, 0(t0)
		break
		.end __start

loser:	.word	0xDEADBEEF
hoser:	.word	0xE234BEEF
booger:	.word	0xE23456EF
