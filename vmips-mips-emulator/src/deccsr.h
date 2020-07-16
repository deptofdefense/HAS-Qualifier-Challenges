/* Headers for Control/Status Register emulation.
   Copyright 2003 Brian R. Gaeke.

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

/* Memory-mapped device representing the Control/Status Register
 * in the DEC 5000/200 (KN02).
 */

#ifndef _DECCSR_H_
#define _DECCSR_H_

#include "devicemap.h"
#include "deviceint.h"

static const unsigned char TURBOchannelSlot0CSRInt = (1 << 0);
static const unsigned char TURBOchannelSlot1CSRInt = (1 << 1);
static const unsigned char TURBOchannelSlot2CSRInt = (1 << 2);
static const unsigned char Reserved0CSRInt         = (1 << 3);
static const unsigned char Reserved1CSRInt         = (1 << 4);
static const unsigned char SCSIInterfaceCSRInt     = (1 << 5);
static const unsigned char EthernetInterfaceCSRInt = (1 << 6);
static const unsigned char SystemInterfaceCSRInt   = (1 << 7);

class DECCSRDevice : public DeviceMap, public DeviceInt {
	uint32 robits;
	uint32 rwbits;
	uint8 ioint;
	uint32 leds;
	uint32 irq;
	uint32 update_status_reg();
	void update_control_reg(uint32 data);
public:
    void assertInt (uint8 line);
    void deassertInt (uint8 line);
    DECCSRDevice (uint32 irq_) : irq (irq_) { extent = 0x80000; }
	uint32 fetch_word(uint32 offset, int mode, DeviceExc *client);
	void store_word(uint32 offset, uint32 data, DeviceExc *client);
	const char *descriptor_str() const { return "DECstation 5000/200 CSR"; }
};

#endif /* _DECCSR_H_ */
