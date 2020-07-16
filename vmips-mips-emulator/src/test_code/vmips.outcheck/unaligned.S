#include "asm_regnames.h"

.text
.globl __start
__start:
li a1, 0xa0000000
lw a0, 2(a1)   /* should produce address error exception */
break

.org 0x180
break


