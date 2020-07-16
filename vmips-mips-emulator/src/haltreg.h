/* Macros for accessing the VMIPS halt device.
   Copyright 2002 Paul Twohey.

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

#ifndef _HALTREG_H_
#define _HALTREG_H_

/* Default physical address for the halt device. */
#define HALT_BASE 0x01010024

/* Default (KSEG0) address for the halt device. */
#define HALT_ADDR 0xa1010024

/* Control register. */
#define HALT_CONTROL 0x00

#endif /* _HALTREG_H_ */
