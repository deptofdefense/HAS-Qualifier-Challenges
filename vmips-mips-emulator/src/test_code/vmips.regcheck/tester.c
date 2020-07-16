#ifdef TESTING
#include <stdio.h>
#endif

#ifdef TESTING
void tester(void)
#else
int entry(void)
#endif
{
	register int a, b, c;

	a = 120923429;
	b = 30030;
	do {
		c = a % b; a = b; b = c;
	} while (c);
#ifdef TESTING
	printf("%d\n",a);
#endif
	return a;
}

#ifdef TESTING
int main(int argc, char **argv)
{
	tester();
	return 0;
}
#else /* TESTING */

#endif
