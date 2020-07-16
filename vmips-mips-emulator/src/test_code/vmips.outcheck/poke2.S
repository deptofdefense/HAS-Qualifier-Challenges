
/* Bug ID 504092: writing to console line 2 crashes vmips */

#include "spimconsreg.h"
#define IOBASE 0xa2000000

.globl __start
.ent __start
__start:
	/* Wait for console 2 to be ready */
    lw    $2, IOBASE+DISPLAY_2_CONTROL
    andi  $2, $2, CTL_RDY
    beq   $2, $0, __start

	/* Write an 'x' to it */
    li    $2, 'x'
    sw    $2, IOBASE+DISPLAY_2_DATA

	/* Halt. */
    break
.end __start

