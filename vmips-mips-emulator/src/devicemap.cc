/* Base class for devices that are memory-mapped into the CPU's
   address space.
   Copyright 2001, 2003 Brian R. Gaeke.
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

/* Routines implementing memory mappings for devices which support
 * memory-mapped I/O. */

#include "accesstypes.h"
#include "range.h"
#include "devicemap.h"
#include "cpu.h"
#include "vmips.h"
#include "mapper.h"
#include <cstdlib>

uint16
DeviceMap::fetch_halfword(uint32 offset, DeviceExc *client)
{
    uint32 word_data = fetch_word(offset & ~0x03, DATALOAD, client);
    word_data = machine->physmem->host_to_mips_word(word_data);
    uint32 halfword_offset_in_word = ((offset & 0x02) >> 1);
    if (!machine->cpu->is_bigendian()) {
	halfword_offset_in_word = 1 - halfword_offset_in_word;
    }
    uint16 rv;
    switch (halfword_offset_in_word) {
	case 0: rv = (word_data >> 16) & 0xffff; break;
	case 1: rv = word_data & 0xffff; break;
	default: abort();
    }
    rv = machine->physmem->mips_to_host_halfword(rv);
    return rv;
}

uint8
DeviceMap::fetch_byte(uint32 offset, DeviceExc *client)
{
    uint32 word_data = fetch_word(offset & ~0x03, DATALOAD, client);
    word_data = machine->physmem->host_to_mips_word(word_data);
    uint32 byte_offset_in_word = (offset & 0x03);
    if (!machine->cpu->is_bigendian()) {
	byte_offset_in_word = 3 - byte_offset_in_word;
    }
    uint8 rv;
    switch (byte_offset_in_word) {
	case 0: rv = (word_data >> 24) & 0xff; break;
	case 1: rv = (word_data >> 16) & 0xff; break;
	case 2: rv = (word_data >> 8) & 0xff; break;
	case 3: rv = word_data & 0xff; break;
	default: abort();
    }
    return rv;
}

void
DeviceMap::store_halfword(uint32 offset, uint16 data, DeviceExc *client)
{
    const uint32 word_offset = offset & 0xfffffffc;
    uint32 halfword_offset_in_word = ((offset & 0x02) >> 1);
    uint32 word_data = 0;
    if (!machine->cpu->is_bigendian()) {
	halfword_offset_in_word = 1 - halfword_offset_in_word;
    }
    data = machine->physmem->host_to_mips_halfword(data);
    switch (halfword_offset_in_word) {
	case 0: word_data = (data << 16) & 0xffff0000; break;
	case 1: word_data = data & 0x0000ffff; break;
	default: abort();
    }
    word_data = machine->physmem->mips_to_host_word(word_data);
    store_word(word_offset, word_data, client);
}

void
DeviceMap::store_byte(uint32 offset, uint8 data, DeviceExc *client)
{
    const uint32 word_offset = offset & 0xfffffffc;
    uint32 byte_offset_in_word = (offset & 0x03);
    uint32 word_data = 0;
    if (!machine->cpu->is_bigendian()) {
	byte_offset_in_word = 3 - byte_offset_in_word;
    }
    switch (byte_offset_in_word) {
	case 0: word_data = (data << 24) & 0xff000000; break;
	case 1: word_data = (data << 16) & 0x00ff0000; break;
	case 2: word_data = (data << 8) & 0x0000ff00; break;
	case 3: word_data = data & 0x000000ff; break;
	default: abort();
    }
    word_data = machine->physmem->mips_to_host_word(word_data);
    store_word(word_offset, word_data, client);
}

bool
DeviceMap::canRead(uint32 offset)
{
    return true;
}

bool
DeviceMap::canWrite(uint32 offset)
{
    return true;
}
