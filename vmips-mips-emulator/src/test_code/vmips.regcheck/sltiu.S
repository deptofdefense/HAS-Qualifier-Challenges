
/* make sure sltiu sign-extends its immediate argument to 32 bits first
 * before doing the unsigned comparison. */

#include "asm_regnames.h"
.text
.globl __start
.ent __start
__start:
	li s0, 0x80239000
	sltiu v1, s0, -999    /* compare it  - should get v1 = 1*/
	break
.end __start

