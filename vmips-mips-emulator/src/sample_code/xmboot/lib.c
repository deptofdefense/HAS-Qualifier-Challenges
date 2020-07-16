/* The little C library. */

#include <stdarg.h>
#include "lib.h"
#include "serial.h"

int errno;

static short modes;

FILE *stdin, *stdout, *stderr;

void
set_echo (int onoff)
{
  term_disable (ECHO);
  if (onoff)
    term_enable (ECHO);
}

void
term_enable (int mode)
{
  modes |= mode;
}

void
term_disable (int mode)
{
  modes &= ~mode;
}

int
getchar (void)
{
  char ch;
  int rv;

  rv = read (0, &ch, 1);
  if (rv != 1)
    {
      return -1;
    }
  else
    {
      if ((modes & ICRNL) && (ch == '\r'))
        ch = '\n';
      if (modes & ECHO)
        putchar (ch);
      return ch;
    }
}

int
putchar (int ch)
{
  unsigned char ch_uchar = (unsigned char) ch;
  if ((modes & ONLCR) && (ch_uchar == '\n'))
    putchar ('\r');
  return ((write (1, &ch_uchar, 1) < 1) ? -1 : 0);
}

int
fputc (int c, FILE *stream)
{
  putchar ((unsigned char) c);
  return c;
}

int
fputs (const char *s, FILE *stream)
{
  puts_nonl (s);
  return 0;
}

void
puts_nonl (const char *buf)
{
  while (*buf)
    {
      putchar (*buf++);
    }
}

char *
gets (char *buf)
{
  char ch;
  char *rv = buf;
  while (1)
    {
      if ((ch = getchar ()) < 0)
        return NULL;
      if (!(ch == '\n' || ch == '\r'))
        {
          *buf++ = ch;
        }
      else
        {
          break;
        }
    }
  *buf++ = '\0';
  return rv;
}

int
puts (const char *buf)
{
  puts_nonl (buf);
  putchar ('\n');
  return 0;
}

int
strcmp (const char *s1, const char *s2)
{
  const char *p = s1;
  const char *q = s2;

  while ((*p != '\0') || (*q != '\0'))
    {
      if (*p != *q)
        return (*p - *q);
      p++;
      q++;
    }
  return 0;
}

int
strncmp (const char *s1, const char *s2, size_t n)
{
  const char *p = s1;
  const char *q = s2;

  while ((*p != '\0') || (*q != '\0'))
    {
      if (*p != *q)
        return (*p - *q);
      p++;
      q++;
      n--;
      if (n == 0)
        {
          return 0;
        }
    }
  return 0;
}

size_t
strlen (const char *s)
{
  int length = 0;

  while (*s++)
    length++;
  return length;
}

char *
strcat (char *dest, const char *src)
{
  int i, start = strlen (dest);
  for (i = 0; i < strlen (src); ++i)
    {
      dest[start + i] = src[i];
    }
  dest[start + i] = '\0';
  return dest;
}

static int
char_to_digit (const char s)
{
  if (s >= '0' && s <= '9')
    {
      return s - '0';
    }
  if (s >= 'a' && s <= 'z')
    {
      return 10 + (s - 'a');
    }
  if (s >= 'A' && s <= 'Z')
    {
      return 10 + (s - 'A');
    }
  return 0;
}

int
toupper (int c)
{
  if (c >= 'a' && c <= 'z')
    {
      return (c - 'a') + 'A';
    }
  else
    return c;
}

int
tolower (int c)
{
  if (c >= 'A' && c <= 'Z')
    {
      return (c - 'A') + 'a';
    }
  else
    return c;
}

char
digit_to_char (unsigned int digit, unsigned int use_uppercase)
{
  const char lowercase_digits[] = "0123456789abcdefghijklmnopqrstuvwxyz";
  char c;

  c = lowercase_digits[digit];
  if (use_uppercase)
    c = toupper (c);
  return c;
}

int
isspace (int c)
{
  return (c == ' ') || (c == '\t') || (c == '\r') || (c == '\n');
}

int
isdigit (int c)
{
  return ((c >= '0') && (c <= '9'));
}

int
isprint (int c)
{
  /* this is really crude, but works for most of 7-bit ASCII */
  return ((c >= 32) && (c < 127));
}

long
strtol (const char *s, char **endptr, int radix)
{
  int num = 0, length, i = 0, negate = 0;

  while (isspace (*s))
    s++;

  if (radix == 0)
    {
      if (s[0] == '0')
        {
          if (s[1] == 'x')
            {
              s += 2;
              radix = 16;
            }
          else if (s[1] == '\0')
            {
              return 0;
            }
          else
            {
              s += 1;
              radix = 8;
            }
        }
      else if (isdigit (s[0]) || s[0] == '-')
        {
          radix = 10;
        }
      else
        {
          return 0;
        }
    }
  if (s[0] == '-')
    {
      negate = 1;
      s++;
    }
  length = strlen (s);
  do
    {
      num *= radix;
      num += char_to_digit (s[i]);
      i++;
    }
  while (i < length);
  if (negate)
    num = -num;
  return num;
}

static int
print_int (int i, unsigned int radix, unsigned int use_uppercase)
{
  char digit = digit_to_char (i % radix, use_uppercase);
  int remains = (i / radix);

  if (i < 0)
    {
      putchar ('-');
      return 1 + print_int (-i, radix, use_uppercase);
    }
  else if (remains > 0)
    {
      int nprinted = print_int (remains, radix, use_uppercase);
      putchar (digit);
      return 1 + nprinted;
    }
  else
    {
      putchar (digit);
      return 1;
    }
}

static int
print_unsigned_int (unsigned int i, unsigned int radix,
                    unsigned int use_uppercase)
{
  char digit = digit_to_char (i % radix, use_uppercase);
  int remains = (i / radix);

  if (remains > 0)
    {
      int nprinted = print_unsigned_int (remains, radix, use_uppercase);
      putchar (digit);
      return 1 + nprinted;
    }
  else
    {
      putchar (digit);
      return 1;
    }
}

int
printf (const char *fmt, ...)
{
  va_list ap;
  int rc;
  va_start (ap, fmt);
  rc = vfprintf (stdout, fmt, ap);
  va_end (ap);
  return rc;
}

int
vprintf (const char *fmt, va_list ap)
{
  return vfprintf (stdout, fmt, ap);
}

int
fprintf (FILE *fp, const char *fmt, ...)
{
  va_list ap;
  int rc;
  va_start (ap, fmt);
  rc = vfprintf (fp, fmt, ap);
  va_end (ap);
  return rc;
}

int
vfprintf (FILE *fp, const char *fmt, va_list ap)
{
  const char *f = fmt;
  int count = 0;
  int nextarg_is_long = 0;
  int i;
  unsigned int u;
  char c;
  char *s;

  while (f[0])
    {
      if (f[0] != '%')
        {
          putchar (*f);
          count += 1;
          f += 1;
        }
      else
        {
          while (isdigit(f[1])) f++;
          if (f[1] == 'l')
            {
              nextarg_is_long++;
              f++;
            }
          switch (f[1])
            {
            case 'c':
              c = (char) va_arg (ap, int);
              putchar (c);
              count += 1;
              break;
            case 'd':
            case 'i':
              i = va_arg (ap, int);
              count += print_int (i, 10, 0);
              break;
            case 'o':
              u = (unsigned int) va_arg (ap, int);
              count += print_unsigned_int (u, 8, 0);
              break;
            case 'u':
              u = (unsigned int) va_arg (ap, int);
              count += print_unsigned_int (u, 10, 0);
              break;
            case 'x':
              u = (unsigned int) va_arg (ap, int);
              count += print_unsigned_int (u, 16, 0);
              break;
            case 'X':
              u = (unsigned int) va_arg (ap, int);
              count += print_unsigned_int (u, 16, 1);
              break;
            case 's':
              s = (char *) va_arg (ap, char *);
              while (*s)
                {
                  putchar (*s++);
                  count++;
                }
              break;
            default:
              putchar (f[1]);
              count += 1;
              break;
            }
          f += 2;
          nextarg_is_long = 0;
        }
    }
  return count;
}

char *
strcpy (char *dest, const char *src)
{
  char *rv = dest;

  do
    {
      *dest++ = *src++;
    }
  while (*src);
  *dest++ = '\0';
  return rv;
}

char *
strncpy (char *dest, const char *src, size_t n)
{
  char *rv = dest;

  do
    {
      *dest++ = *src++;
      n--;
    }
  while (*src && n);
  *dest++ = '\0';
  return rv;
}

void *
memcpy (void *dest, const void *src, size_t n)
{
  void *rv = dest;
  unsigned char *dest_c = (unsigned char *) dest;
  unsigned char *src_c = (unsigned char *) src;

  while (n--)
    {
      *dest_c++ = *src_c++;
    }
  return rv;
}

void *
memmove_aligned_4 (void *dest, const void *src, size_t n)
{
  void *rv = dest;
  unsigned int *dest_c = (unsigned int *) dest;
  unsigned int *src_c = (unsigned int *) src;

  n /= 4;

  if (dest_c - src_c < 0)
    {
      /* Copy forwards. */
      while (n--)
        {
          *dest_c++ = *src_c++;
        }
    }
  else if (dest_c - src_c > 0)
    {
      /* Copy backwards. */
      dest_c += n;
      src_c += n;
      while (n--)
        {
          *--dest_c = *--src_c;
        }
    }
  return rv;
}


void *
memmove (void *dest, const void *src, size_t n)
{
  void *rv = dest;
  unsigned char *dest_c = (unsigned char *) dest;
  unsigned char *src_c = (unsigned char *) src;

  if (((((int)dest) & 0x03) == 0)
     && ((((int)src) & 0x03) == 0)
     && ((n & 0x03) == 0))
    return memmove_aligned_4 (dest, src, n);

  if (dest_c - src_c < 0)
    {
      /* Copy forwards. */
      while (n--)
        {
          *dest_c++ = *src_c++;
        }
    }
  else if (dest_c - src_c > 0)
    {
      /* Copy backwards. */
      dest_c += n;
      src_c += n;
      while (n--)
        {
          *--dest_c = *--src_c;
        }
    }
  return rv;
}

void *
memset_aligned_4 (void *s, int c, size_t n)
{
  int *dest_c = (int *) s;
  void *rv = s;
  unsigned char c_c = (c & 0x0ff);
  int c4;

  n /= 4;
  c4 = (c_c << 24) | (c_c << 16) | (c_c << 8) | c_c;

  while (n--)
    {
      *dest_c++ = c4;
    }
  return rv;
}

void *
memset (void *s, int c, size_t n)
{
  unsigned char *dest_c = s;
  void *rv = s;
  unsigned char c_c = c;

  if (((((int)s) & 0x03) == 0) 
     && ((n & 0x03) == 0))
    return memset_aligned_4 (s, c, n);

  while (n--)
    {
      *dest_c++ = c_c;
    }
  return rv;
}

int
atoi (const char *nptr)
{
  return strtol (nptr, (char **) NULL, 10);
}

/* The following is an incredibly dumb memory allocator, for
   use only when the alternatives are too horrible to contemplate.
   You cannot free memory with it! */

extern char *_end, *_data; /* provided by linker */
static char *mem_brk = 0;
const int data_size_limit = 0x100000;

/* If process would exceed max data size, return -1.
   Otherwise, set the mem_brk and return 0. */
int
brk (void *end_data_segment)
{
  if (!mem_brk)
    mem_brk = (char *) &_end;

  if (mem_brk - ((char *) &_data) > data_size_limit) {
    return -1;
  } else {
    mem_brk = end_data_segment;
    return 0;
  }
}

void *
sbrk (ptrdiff_t increment)
{
  if (!mem_brk)
    mem_brk = (char *) &_end;
  if (brk (mem_brk + increment) == 0)
    return (void *) mem_brk;
  else
    return (void *) -1;
}

void *
malloc (size_t alloc_size)
{
  static char *next_alloc = 0;
  char *cur_brk;
  char *rv;
  if (!next_alloc)
    next_alloc = (char *)&_end;
  alloc_size += 4; /* Add space for length word. */
  alloc_size = (alloc_size + 3) & ~3;
  cur_brk = (char *) sbrk (0);
  if (next_alloc + alloc_size > cur_brk)
    sbrk ((next_alloc + alloc_size) - cur_brk);
  rv = next_alloc + 4;
  ((size_t *)next_alloc)[0] = alloc_size; /* Save length of this block. */
  next_alloc += alloc_size;
  return rv;
}

void *
calloc (size_t obj_size, size_t obj_count)
{
  char *ptr;
  size_t real_size;
  real_size = obj_size * obj_count;
  ptr = malloc (real_size);
  memset (ptr, 0, real_size);
  return ptr;
}

void
free (void *ptr)
{
  /* Do nothing */
}
