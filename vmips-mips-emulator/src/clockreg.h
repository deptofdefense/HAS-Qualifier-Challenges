/* Registers, offsets, and default address for the clock device.
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

#ifndef _CLOCKREG_H_
#define _CLOCKREG_H_

#include "devreg.h"

/* Use this as a mask to check when the clock device has interrupts enabled.
   This is deprecated in favor of using CTL_IE. */
#define CDC_INTERRUPTS_ENABLED CTL_IE

/* Default base address in physical memory clock device address */
#define CLOCK_BASE 0x01010000

/* Default virtual (KSEG0) clock device address */
#define CLOCK_ADDR 0xa1010000

/* Register offsets */
#define REAL_SECONDS     0x00
#define REAL_MICRO       0x04
#define SIM_SECONDS      0x08
#define SIM_MICRO        0x0C
#define CLOCKDEV_CONTROL 0x10

#endif /* _CLOCKREG_H_ */
