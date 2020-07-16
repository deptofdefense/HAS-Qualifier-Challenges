/* Interrupt controller.
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
#include "intctrl.h"
#include <cassert>

uint32 IntCtrl::calculateIP()
{
	uint32 IP = 0;
	for (Devices::iterator i = devs.begin(); i != devs.end(); i++) {
		IP |= (*i)->lines_asserted;
	}
	return IP;
}

void IntCtrl::connectLine(uint32 line, DeviceInt *dev)
{
	assert(dev);

	dev->lines_connected |= line;
	
	for (Devices::iterator i = devs.begin(); i != devs.end(); i++) {
		if (dev == *i)
			return;
	}
	
	devs.push_back(dev);
}
