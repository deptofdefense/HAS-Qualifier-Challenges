/* Definitions to support mapping ranges.
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

#ifndef _RANGE_H_
#define _RANGE_H_

#include "accesstypes.h"
#include "types.h"
#include <sys/types.h>
class DeviceExc;

/* Base class for managing a range of mapped memory. Memory-mapped
 * devices (class DeviceMap) derive from this.
 */
class Range { 
protected:
	uint32 base;        // first physical address represented
	uint32 extent;      // number of bytes of memory provided
	void *address;      // host machine pointer to start of memory
	int perms;          // MEM_READ, MEM_WRITE, ... in accesstypes.h

public:
	Range(uint32 _base, uint32 _extent, caddr_t _address, int _perms) :
		base(_base), extent(_extent), address(_address), perms(_perms) { }
	virtual ~Range() { }
	
	bool incorporates(uint32 addr);
	bool overlaps(Range *r);
	uint32 getBase () const { return base; }
	uint32 getExtent () const { return extent; }
	void *getAddress () const { return address; }
	int getPerms () const { return perms; }
	void setBase (uint32 newBase) { base = newBase; }
	void setPerms (int newPerms) { perms = newPerms; }

	virtual bool canRead (uint32 offset) { return perms & MEM_READ; }
	virtual bool canWrite (uint32 offset) { return perms & MEM_WRITE; }

	virtual uint32 fetch_word(uint32 offset, int mode, DeviceExc *client);
	virtual uint16 fetch_halfword(uint32 offset, DeviceExc *client);
	virtual uint8 fetch_byte(uint32 offset, DeviceExc *client);
	virtual void store_word(uint32 offset, uint32 data, DeviceExc *client);
	virtual void store_halfword(uint32 offset, uint16 data,
		DeviceExc *client);
	virtual void store_byte(uint32 offset, uint8 data, DeviceExc *client);
};


#endif /* _RANGE_H_ */
