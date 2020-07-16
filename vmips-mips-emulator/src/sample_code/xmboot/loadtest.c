#include "lib.h"

int MyMain (int argc, char **argv)
{
  int i;
  printf ("Hello, world!\n");
  printf ("Argc is %d\n", argc);
  for (i = 0; i < argc; ++i) {
    printf ("Arg %d is %s\n", i, argv[i]);
  }
  printf ("Ok, goodbye.\n");
  return 0;
}

