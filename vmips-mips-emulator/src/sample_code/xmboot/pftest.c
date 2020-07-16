/* A program to test printf under vmips. */
#include "lib.h"

int main (int argc, char **argv)
{
	char c = 'x';

	printf("This is a test\n");
	printf("This is a char: [%c]\n", c);
	printf("This is an int: [%d]\n", -12345);
	printf("This is an int: [%i]\n", 12345);
	printf("This is an octal int: [0%o]\n", 01234567);
	printf("This is an unsigned int: [%u]\n", -1);
	printf("This is a hex int: [0x%x]\n", 0xdead);
	printf("This is a HEX int: [0X%X]\n", 0xBEEF);
	printf("This is a string: [%s]\n", "Cheese");
	return 0;
}
