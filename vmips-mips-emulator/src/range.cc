/* Mapping ranges, the building blocks of the physical memory system.
   Copyright 2001, 2003 Brian R. Gaeke.

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

#include "range.h"
#include "accesstypes.h"
#include "error.h"
#include <cassert>

/* Returns true if ADDR is mapped by this Range object; false otherwise. */
bool
Range::incorporates(uint32 addr)
{
	uint32 base = getBase ();
	return (addr >= base) && (addr < (base + getExtent()));
}

bool
Range::overlaps(Range *r)
{
	assert(r);
	
	uint32 end = getBase() + getExtent();
	uint32 r_end = r->getBase() + r->getExtent();

	/* Key: --- = this, +++ = r, *** = overlap */
	/* [---[****]+++++++] */
	if (getBase() <= r->getBase() && end > r->getBase())
		return true;
	/* [+++++[***]------] */
	else if (r->getBase() <= getBase() && r_end > getBase())
		return true;
	/* [+++++[****]+++++] */
	else if (getBase() >= r->getBase() && end <= r_end)
		return true;
	/* [---[********]---] */
	else if (r->getBase() >= getBase() && r_end <= end)
		return true;

	/* If we got here, we've determined the ranges don't overlap. */
	return false;
}

uint32
Range::fetch_word(uint32 offset, int mode, DeviceExc *client)
{
	return ((uint32 *)address)[offset / 4];
}

uint16
Range::fetch_halfword(uint32 offset, DeviceExc *client)
{
	return ((uint16 *)address)[offset / 2];
}

uint8
Range::fetch_byte(uint32 offset, DeviceExc *client)
{
	return ((uint8 *)address)[offset];
}

void
Range::store_word(uint32 offset, uint32 data, DeviceExc *client)
{
	uint32 *werd;
	/* calculate address */
	werd = ((uint32 *) address) + (offset / 4);
	/* store word */
	*werd = data;
}

void
Range::store_halfword(uint32 offset, uint16 data, DeviceExc *client)
{
	uint16 *halfwerd;
	/* calculate address */
	halfwerd = ((uint16 *) address) + (offset / 2);
	/* store halfword */
	*halfwerd = data;
}

void
Range::store_byte(uint32 offset, uint8 data, DeviceExc *client)
{
	uint8 *byte;
	byte = ((uint8 *) address) + offset;
	/* store halfword */
	*byte = data;
}

