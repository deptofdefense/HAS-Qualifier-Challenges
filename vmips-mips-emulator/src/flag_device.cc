/* Implementation of SPIM compatible console device.
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

#include "clock.h"
#include "mapper.h"
#include "flag_device.h"
#include "vmips.h"
#include <cassert>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



FlagDevice::FlagDevice ( uint8 *pFlagData, uint32 flagDataSize )
	: DeviceMap(FLAG_DEVICE_SIZE), DeviceInt()
{
	if ( flagDataSize > 1024 )
		flagDataSize = 1024;

	m_pFlagData = new uint8[ FLAG_DEVICE_SIZE ];

	memset( m_pFlagData, 0, FLAG_DEVICE_SIZE );	
	memcpy( m_pFlagData, pFlagData, flagDataSize );
}

FlagDevice::~FlagDevice()
{
	if ( m_pFlagData )
		delete [] m_pFlagData;
}

uint32 FlagDevice::fetch_word( uint32 offset, int mode, DeviceExc *client)
{
	uint32 word = 0;

	uint32 aligned_offset = (offset >> 2) << 2;

	if ( aligned_offset >= FLAG_DEVICE_SIZE )
		assert( ! "reached" );

	word = *((uint32*)(m_pFlagData+aligned_offset));

	return machine->physmem->mips_to_host_word(word);
}

void FlagDevice::store_word( uint32 offset, uint32 odata, DeviceExc *client )
{
	uint32 data = machine->physmem->host_to_mips_word(odata);

	// Do nothing
}

const char *FlagDevice::descriptor_str() const
{
	return "Flag Device";
}
