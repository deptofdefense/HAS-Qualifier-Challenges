/* Declarations to support the SPIM-compatible console device.
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

#ifndef _FLAG_DEVICE_H_
#define _FLAG_DEVICE_H_

#include "deviceint.h"
#include "devicemap.h"
#include "task.h"
#include "terminalcontroller.h"
#include <new>

// Physical Base Address/
#define FLAG_DEVICE_BASE        0x02008000	// Physical address for the flag
#define FLAG_DEVICE_SIZE	0x1000

// Flag device -- used for the challenge to hold the flag string in memory somewhere
// Memory maps the flag to a location in memory
class FlagDevice : public DeviceMap, public DeviceInt
{
public:
	FlagDevice( uint8 *pFlagData, uint32 flagLength );

	virtual ~FlagDevice();

protected:

public:

	/* Fetch and store console control words. */
	virtual uint32 fetch_word(uint32 offset, int mode, DeviceExc *client);
	virtual void store_word(uint32 offset, uint32 data, DeviceExc *client);

	/* Return a description of this device. */
	virtual const char *descriptor_str() const;

protected:
	uint8 *m_pFlagData;
};

#endif // _FLAG_DEVICE_H_
