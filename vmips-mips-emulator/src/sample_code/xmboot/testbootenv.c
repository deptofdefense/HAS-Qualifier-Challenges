#include "lib.h"
#include "bootenv.h"

void testgetenv (const char *str)
{
	printf ("getenv (\"%s\") == %s\n", str, getenv(str) ? getenv(str) : "NULL");
}

void testprintenv (void)
{
	printf ("printenv () produces:\n");
	printenv ();
}

void testsetenv (const char *name, const char *value)
{
	printf ("setenv (\"%s\", \"%s\"):\n", name, value);
	setenv (name, value);
	testprintenv ();
}

void testunsetenv (const char *name)
{
	printf ("unsetenv (\"%s\"):\n", name);
	unsetenv (name);
	testprintenv ();
}

int main (int argc, char **argv) {
    initbootenv ();
	testprintenv ();
	testgetenv ("systype");
	testgetenv ("crap");
	testsetenv ("crap", "50");
	testsetenv ("haltaction", "cheese");
	testunsetenv ("console");
	testunsetenv ("crap2");
	return 0;
}
