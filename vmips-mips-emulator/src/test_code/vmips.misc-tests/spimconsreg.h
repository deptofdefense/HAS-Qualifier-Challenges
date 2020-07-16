/* Register offsets and default address for the SPIM-compatible console
   device.
   Copyright 2001 Brian R. Gaeke.
   Copyright 2002, 2003 Paul Twohey.

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

#ifndef _SPIMCONSREG_H_
#define _SPIMCONSREG_H_

#include "devreg.h"

/* default physical spim base address */
#define SPIM_BASE           0x02000000

/* default virtual (KSEG0) spim address */
#define SPIM_ADDR           0xa2000000

/* register offsets */
#define KEYBOARD_1_CONTROL  0x00
#define KEYBOARD_1_DATA     0x04
#define DISPLAY_1_CONTROL   0x08
#define DISPLAY_1_DATA      0x0C
#define KEYBOARD_2_CONTROL  0x10
#define KEYBOARD_2_DATA     0x14
#define DISPLAY_2_CONTROL   0x18
#define DISPLAY_2_DATA      0x1C
#define CLOCK_CONTROL       0x20

#endif /* _SPIMCONSREG_H_ */
