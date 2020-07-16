/* Constants describing types of memory accesses.
   Copyright 2001, 2003 Brian R. Gaeke.

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

#ifndef _ACCESSTYPES_H_
#define _ACCESSTYPES_H_

/* Three kinds of memory accesses are possible.
 * There are two kinds of load and one kind of store:
 * INSTFETCH is a memory access due to an instruction fetch.
 * DATALOAD is a memory access due to a load instruction,
 * e.g., lw, lh, lb.
 * DATASTORE is a memory access due to a store instruction,
 * e.g., sw, sh, sb.
 *
 * ANY is a catch-all used in exception prioritizing which
 * implies that none of the kinds of memory accesses applies,
 * or that the type of memory access otherwise doesn't matter.
 */
#define INSTFETCH 0
#define DATALOAD 1
#define DATASTORE 2
#define ANY 3

/* add_core_mapping and friends maintain a set of protection
 * bits which define allowable access to memory. These do
 * not have anything to do with the virtual memory privilege
 * bits that a kernel would maintain; they are used to
 * distinguish between, for example, ROM and RAM, and between
 * readable and unreadable words of a memory-mapped device.
 */
#define MEM_READ       0x01
#define MEM_WRITE      0x02
#define MEM_READ_WRITE 0x03

#endif /* _ACCESSTYPES_H_ */
