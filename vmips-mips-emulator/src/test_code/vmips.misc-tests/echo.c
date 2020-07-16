/* Print a friendly message to the serial console. */

#include "spimconsreg.h"

#define IOBASE 0xa2000000
#define IS_READY(ctrl) (((*(ctrl)) & CTL_RDY) != 0)

volatile long *display_data_reg = (long *)(IOBASE+DISPLAY_1_DATA);
volatile long *display_control_reg = (long *)(IOBASE+DISPLAY_1_CONTROL);
volatile long *keyboard_data_reg = (long *)(IOBASE+KEYBOARD_1_DATA);
volatile long *keyboard_control_reg = (long *)(IOBASE+KEYBOARD_1_CONTROL);

char getchar(void)
{
	do { 0; } while (! IS_READY(keyboard_control_reg));
	return (char) *keyboard_data_reg;
}

void putchar(char out)
{
	do { 0; } while (! IS_READY(display_control_reg));
	*display_data_reg = (long) out;
}

void entry(void)
{
	char inpchar;

	putchar('?');
	putchar(' ');
	while (1) {
		inpchar = getchar();
		if (inpchar == 0x04) {
			putchar('\n');
			putchar('!');
			putchar('\n');
			return;
		} else if (inpchar == 0x0A) {
			putchar('\n');
			putchar('?');
			putchar(' ');
		} else {
			putchar('[');
			putchar(inpchar);
			putchar(']');
		}
	}
}
