/* Definitions to support devices that can generate interrupts.
   Copyright 2001, 2002 Brian R. Gaeke.
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

#ifndef _DEVICEINT_H_
#define _DEVICEINT_H_

#include "intctrl.h"

/* Interrupt lines that DeviceInts can use.
   These constants correspond to the bits of the Interrupt Pending (IP)
   field of the Cause register of CP0, and to the bits of the Interrupt Mask
   (IM) field of the Status register of CP0. See cpzeroreg.h.  */
#define IRQ7 0x00008000
#define IRQ6 0x00004000
#define IRQ5 0x00002000
#define IRQ4 0x00001000
#define IRQ3 0x00000800
#define IRQ2 0x00000400

/* These are for use by software only, NOT hardware! */
#define IRQ1 0x00000200
#define IRQ0 0x00000100

/* A class which describes a device that can trigger hardware interrupts
   in the processor. DeviceInts can be connected to an IntCtrl
   (interrupt controller). */
class DeviceInt {
public:
	/* Given a value (LINE) representing one of the bits of the
	   Cause register (IRQ7 .. IRQ0 in deviceint.h), return a string
	   that describes the corresponding interrupt line.  The string is
	   returned in a static buffer, so the next call to strlineno will
	   overwrite the result. */
	static char *strlineno(uint32 line);

	/* Return the bit of the CP0 Status and Cause registers corresponding
	   to interrupt line number NUM, or 0 if no such interrupt line exists. */
	static uint32 num2irq(uint32 num);

    virtual ~DeviceInt() { }

protected:
	/* Assert an interrupt request on interrupt line LINE, which
	   must be one of the IRQ7 .. IRQ0 constants in deviceint.h. An
	   interrupt thus asserted remains asserted until it is explicitly
	   deasserted. */
	void assertInt(uint32 line);

	/* Deassert an interrupt request on interrupt line LINE, which
	   must be one of the IRQ7 .. IRQ0 constants in deviceint.h. Note
	   that if one device deasserts the interrupt request, that doesn't
	   necessarily mean that the interrupt line will go to zero;
	   another device may be sharing the same interrupt line. */
	void deassertInt(uint32 line);

	/* This method, in derived classes, should return a string describing
	   the device. */
	virtual const char *descriptor_str(void) const = 0;

	DeviceInt();

private:
	void reportAssert(uint32 line);
	void reportAssertDisconnected(uint32 line);
	void reportDeassert(uint32 line);
	void reportDeassertDisconnected(uint32 line);

	friend class IntCtrl;

	uint32 lines_connected;
	uint32 lines_asserted;
	bool opt_reportirq;
};

#endif /* _DEVICEINT_H_ */
