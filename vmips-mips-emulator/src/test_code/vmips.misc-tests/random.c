/* Copyright (C) 1995, 1996, 1997, 1998, 2001 Free Software Foundation, Inc.
   This file is part of the GNU C Library and the VMIPS testsuite.
   Contributed by Ulrich Drepper <drepper@gnu.ai.mit.edu>, August 1995.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.  */

/* (brg) This file consists mostly of bits and pieces from the GNU C
   Library version 2.2.4. The pieces come from stdlib/drand48-iter.c,
   stdlib/stdlib.h, stdlib/nrand48_r.c, and stdlib/lrand48.c. */

typedef unsigned long long uint64_t;
typedef unsigned int uint32_t;

/* Data structure for communication with thread safe versions.  This
   type is to be regarded as opaque.  It's only exported because users
   have to allocate objects of this type.  */
struct drand48_data
  {
    unsigned short int __x[3];  /* Current state.  */
    unsigned short int __old_x[3]; /* Old state.  */
    unsigned short int __c; /* Additive const. in congruential formula.  */
    unsigned short int __init;  /* Flag for initializing.  */
    unsigned long long int __a; /* Factor in congruential formula.  */
  };

/* Global state for non-reentrant functions.  */
struct drand48_data __libc_drand48_data;

int
__drand48_iterate (xsubi, buffer)
     unsigned short int xsubi[3];
     struct drand48_data *buffer;
{
  uint64_t X;
  uint64_t result;

  /* Initialize buffer, if not yet done.  */
  if (!buffer->__init)
    {
      buffer->__a = 0x5deece66dull;
      buffer->__c = 0xb;
      buffer->__init = 1;
    }

  /* Do the real work.  We choose a data type which contains at least
     48 bits.  Because we compute the modulus it does not care how
     many bits really are computed.  */

  X = (uint64_t) xsubi[2] << 32 | (uint32_t) xsubi[1] << 16 | xsubi[0];

  result = X * buffer->__a + buffer->__c;

  xsubi[0] = result & 0xffff;
  xsubi[1] = (result >> 16) & 0xffff;
  xsubi[2] = (result >> 32) & 0xffff;

  return 0;
}

int
__nrand48_r (xsubi, buffer, result)
     unsigned short int xsubi[3];
     struct drand48_data *buffer;
     long int *result;
{
  /* Compute next state.  */
  if (__drand48_iterate (xsubi, buffer) < 0)
    return -1;

  /* Store the result.  */
  if (sizeof (unsigned short int) == 2)
    *result = xsubi[2] << 15 | xsubi[1] >> 1;
  else
    *result = xsubi[2] >> 1;

  return 0;
}

long int
lrand48 ()
{
  long int result;

  (void) __nrand48_r (__libc_drand48_data.__x, &__libc_drand48_data, &result);

  return result;
}
