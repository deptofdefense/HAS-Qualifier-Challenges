/* Basic types that we use.
   Copyright 2004 Brian R. Gaeke.

This file is part of VMIPS.

VMIPS is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

VMIPS is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along
with VMIPS; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */

#ifndef _TYPES_H_
#define _TYPES_H_

/* First of all, pull in answers from autoconfiguration system. */
#include "config.h"

/* Find me a 64-bit type (the only one that's not strictly necessary.....) */
#if SIZEOF_INT == 8
typedef unsigned int uint64;
typedef int int64;
#define HAVE_LONG_LONG 1
#elif SIZEOF_LONG == 8
typedef unsigned long uint64;
typedef long int64;
#define HAVE_LONG_LONG 1
#elif SIZEOF_LONG_LONG == 8
typedef unsigned long long uint64;
typedef long long int64;
#define HAVE_LONG_LONG 1
#endif

/* Normal-sized types. */
#if SIZEOF_INT == 4
typedef unsigned int uint32;
typedef int int32;
#elif SIZEOF_LONG == 4
typedef unsigned long uint32;
typedef long int32;
#else
#error "Can't find a 32-bit type, and I need one."
#endif

#if SIZEOF_SHORT == 2
typedef unsigned short uint16;
typedef short int16;
#else
#error "Can't find a 16-bit type, and I need one."
#endif

#if SIZEOF_CHAR == 1
typedef unsigned char uint8;
typedef char int8;
#else
#error "Can't find an 8-bit type, and I need one."
#endif

#endif /* _TYPES_H_ */
