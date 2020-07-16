
#include "lib.h"
#include "bootenv.h"

#define MAXENVVARS 64
#define MAXENVLEN 64
static char *initenv[MAXENVVARS] = {
  "boot=",
  "console=3",
  "haltaction=h",
  "testaction=q",
  "systype=0x82020101",
  NULL
};

static char bootenv[MAXENVVARS][MAXENVLEN];

void
initbootenv (void)
{
  char **p = initenv;
  int i = 0;
  while (*p != NULL)
    {
      strcpy (bootenv[i], *p);
      p++;
      i++;
    }
  for (; i < MAXENVVARS; ++i)
    {
      bootenv[i][0] = '\0';
    }
}

void
printenv (void)
{
  int i;
  for (i = 0; i < MAXENVVARS; ++i)
    {
      if (bootenv[i][0] == '\0')
        {
          return;
        }
      puts (bootenv[i]);
    }
}

char *
getenv (const char *name)
{
  int namelen = strlen (name);
  int i;
  for (i = 0; i < MAXENVVARS; ++i)
    {
      char *s = bootenv[i];
      if ((strncmp (s, name, namelen) == 0) && (s[namelen] == '='))
        {
          return &s[namelen + 1];
        }
    }
  return NULL;
}

void
setenv (const char *name, const char *value)
{
  int namelen = strlen (name);
  int valuelen = strlen (value);
  int i;
  if (namelen + valuelen + 1 > MAXENVLEN)
    {
      puts ("Variable/value too long.");
      return;
    }
  for (i = 0; i < MAXENVVARS; ++i)
    {
      char *s = bootenv[i];
      if (s[0] == '\0')
        {
          break;
        }
      if ((strncmp (s, name, namelen) == 0) && (s[namelen] == '='))
        {
          strncpy (&s[namelen + 1], value, MAXENVLEN - namelen - 1);
          return;
        }
    }
  /* if we got here, it's a new variable; put it at position i
   * if i is not greater than MAXENVVARS-1
   */
  if (i < MAXENVVARS)
    {
      char *s = bootenv[i];
      strncpy (s, name, MAXENVLEN - 1);
      s[namelen] = '=';
      strncpy (&s[namelen + 1], value, MAXENVLEN - namelen - 1);
    }
  else
    {
      puts ("Out of environment space.");
    }
}

void
unsetenv (const char *name)
{
  int namelen = strlen (name);
  int i, j;
  for (i = 0; i < MAXENVVARS; ++i)
    {
      char *s = bootenv[i];
      if ((strncmp (s, name, namelen) == 0) && (s[namelen] == '='))
        {
          /* move the rest of the environment up */
          for (j = i + 1; j < MAXENVVARS; ++j)
            {
              strcpy (bootenv[j - 1], bootenv[j]);
              if (bootenv[j][0] == '\0')
                {
                  return;
                }
            }
        }
    }
  puts ("Variable not found.");
  return;
}
