/* Common definitions for device registers.
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

#ifndef _DEVREG_H_
#define _DEVREG_H_

/* These constants represent bit values for Interrupt Enable and Ready
 * control lines in various VMIPS emulated devices. If you want your
 * device to be similar in its programming interface to the ones that
 * come with VMIPS, your device should use this interpretation for
 * (at least one of) its control register(s).
 */
#define CTL_IE    0x00000002
#define CTL_RDY   0x00000001

#endif /* _DEVREG_H_ */
