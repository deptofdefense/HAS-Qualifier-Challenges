/* Print a friendly message to the serial console. */

#include "spimconsreg.h"

#define IOBASE 0xa2000000
#define IS_READY(ctrl) (((*(ctrl)) & CTL_RDY) != 0)

void entry(void)
{
	char *p = "Hello, world!\n";
	volatile long *data_reg = (long *)(IOBASE+DISPLAY_1_DATA);
	volatile long *control_reg = (long *)(IOBASE+DISPLAY_1_CONTROL);

	while (*p != '\0') {
		do { 0; } while (! IS_READY(control_reg));
		*data_reg = (long) *p++;
	}
}
