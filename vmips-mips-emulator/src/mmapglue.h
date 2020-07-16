/* mmap(2) glue.
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

#ifndef _MMAPGLUE_H_
#define _MMAPGLUE_H_

#include <sys/mman.h>
/* We need this for mmap(2). */
#if !defined(MAP_FAILED)
# define MAP_FAILED ((caddr_t)-1L)
#endif

#endif /* _MMAPGLUE_H_ */
