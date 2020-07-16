/* Base class for devices that can generate hardware interrupts.
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

#include "deviceint.h"
#include "options.h"
#include "vmips.h"

extern vmips *machine;

/* Given a value (LINE) representing one of the bits of the
   Cause register (IRQ7 .. IRQ0 in deviceint.h), return
   a string that describes the corresponding interrupt line.
   The string is returned in a static buffer, so the next call
   to strlineno will overwrite the result. */
char *DeviceInt::strlineno(uint32 line)
{
	static char buff[50];

	if (line == IRQ7) { sprintf(buff, "IRQ7"); }
	else if (line == IRQ6) { sprintf(buff, "IRQ6"); }
	else if (line == IRQ5) { sprintf(buff, "IRQ5"); }
	else if (line == IRQ4) { sprintf(buff, "IRQ4"); }
	else if (line == IRQ3) { sprintf(buff, "IRQ3"); }
	else if (line == IRQ2) { sprintf(buff, "IRQ2"); }
	else if (line == IRQ1) { sprintf(buff, "IRQ1"); }
	else if (line == IRQ0) { sprintf(buff, "IRQ0"); }
	else { sprintf(buff, "something strange (0x%08x)", line); }
	return buff;
}

uint32 DeviceInt::num2irq(uint32 num)
{
	switch (num) {
	case 0:
		return IRQ0;
	case 1:
		return IRQ1;
	case 2:
		return IRQ2;
	case 3:
		return IRQ3;
	case 4:
		return IRQ4;
	case 5:
		return IRQ5;
	case 6:
		return IRQ6;
	case 7:
		return IRQ7;
	default:
		return 0;
	}
}

/* If the `reportirq' option is set, print a message to stderr 
   noting that LINE was asserted. */
void DeviceInt::reportAssert(uint32 line)
{
	if (opt_reportirq)
		fprintf(stderr, "%s asserted %s\n", descriptor_str(), strlineno(line));
}

/* If the `reportirq' option is set, print a message to stderr 
   noting that LINE was asserted even though it was disconnected. */
void DeviceInt::reportAssertDisconnected(uint32 line)
{
	if (opt_reportirq)
		fprintf(stderr, "%s asserted %s but it wasn't connected\n",
			descriptor_str(), strlineno(line));
}

/* If the `reportirq' option is set, print a message to stderr 
   noting that LINE was deasserted. */
void DeviceInt::reportDeassert(uint32 line)
{
	if (opt_reportirq)
		fprintf(stderr, "%s deasserted %s\n", descriptor_str(),
			strlineno(line));
}

/* If the `reportirq' option is set, print a message to stderr 
   noting that LINE was deasserted even though it was disconnected. */
void DeviceInt::reportDeassertDisconnected(uint32 line)
{
	if (opt_reportirq)
		fprintf(stderr, "%s deasserted %s but it wasn't connected\n",
			descriptor_str(), strlineno(line));
}

/* Assert an interrupt request on interrupt line LINE, which must be one
   of the IRQ7 .. IRQ0 constants in deviceint.h. An interrupt thus asserted
   remains asserted until it is explicitly deasserted. */
void DeviceInt::assertInt(uint32 line)
{
	if (line & lines_connected) {
		if (! (line & lines_asserted)) reportAssert(line);
		lines_asserted |= line;
	} else {
		reportAssertDisconnected(line);
	}
}

/* Deassert an interrupt request on interrupt line LINE, which must be one
   of the IRQ7 .. IRQ0 constants in deviceint.h. Note that if one device
   deasserts the interrupt request, that doesn't necessarily mean that
   the interrupt line will go to zero; another device may be sharing the
   same interrupt line. */
void DeviceInt::deassertInt(uint32 line)
{
	if (line & lines_connected) {
		if (line & lines_asserted) reportDeassert(line);
		lines_asserted &= ~line;
	} else {
		reportDeassertDisconnected(line);
	}
}

/* Constructor. */
DeviceInt::DeviceInt()
	: lines_connected(0), lines_asserted(0)
{
	opt_reportirq = machine->opt->option("reportirq")->flag;
}

