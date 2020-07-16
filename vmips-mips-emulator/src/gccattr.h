/* GCC attributes.
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

#ifndef _GCCATTR_H_
#define _GCCATTR_H_

/* First of all, pull in answers from autoconfiguration system. */
#include "config.h"

/* Check whether we can use __attribute__. */
#if HAVE_ATTRIBUTE_FORMAT
# define __ATTRIBUTE_FORMAT__(archetype, string_index, first_to_check) \
    __attribute__((format(archetype, string_index, first_to_check)))
#else
# define __ATTRIBUTE_FORMAT__(archetype, string_index, first_to_check)
#endif
#if HAVE_ATTRIBUTE_NORETURN
# define __ATTRIBUTE_NORETURN__ __attribute__((noreturn))
#else
# define __ATTRIBUTE_NORETURN__
#endif

#endif /* _GCCATTR_H_ */
