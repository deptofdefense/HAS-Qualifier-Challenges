/* Definitions to support devices that are memory-mapped into the CPU's
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

#ifndef _DEVICEMAP_H_
#define _DEVICEMAP_H_

#include "range.h"

/* Physical memory map for a device supporting memory-mapped I/O. This is
 * an abstract class.
 */
class DeviceMap : public Range {
protected:
    DeviceMap() : Range(0, 0, 0, 0) { }
    DeviceMap(uint32 _extent) : Range(0, _extent, 0, 0) { }

public:
    /* Fetch word at byte offset OFFSET as part of load type MODE, which
       can be either DATALOAD or INSTFETCH (defined in accesstypes.h).
       CLIENT is responsible for handling any exceptions the fetch
       may generate. */
    virtual uint32 fetch_word(uint32 offset, int mode, DeviceExc *client) = 0;
    
    /* Fetch halfword at byte offset OFFSET as part of a DATALOAD. CLIENT
       is responsible for handling any exceptions the fetch may generate.
       By default, calls fetch_word() and masks off the result. */
    virtual uint16 fetch_halfword(uint32 offset, DeviceExc *client);

    /* Fetch byte at byte offset OFFSET as part of a DATALOAD. CLIENT is
       responsible for handling any exceptions the fetch may generate. By
       default, calls fetch_word() and masks off the result. */
    virtual uint8 fetch_byte(uint32 offset, DeviceExc *client);

    /* Store word DATA at byte offset OFFSET as part of a DATASTORE.
       CLIENT is responsible for handling any exceptions the store may
       generate. */
    virtual void store_word(uint32 offset,uint32 data,DeviceExc *client) = 0;

    /* Store halfword DATA at byte offset OFFSET as part of a DATASTORE.
       Client is responsible for handling any exceptions the store may
       generate. By default, calls store_word() with a zeroed data word
       with DATA in the appropriate halfword. */
    virtual void store_halfword(uint32 offset, uint16 data, DeviceExc *client);

    /* Store byte DATA at byte offset OFFSET as part of a DATASTORE.
       Client is responsible for handing any exceptions the store may
       generate. By default, calls store_word() with a zeroed data word
       with DATA in the appropriate byte. */
    virtual void store_byte(uint32 offset, uint8 data, DeviceExc *client);

    /* It should not ordinarily be necessary for DeviceMap ranges to
       override these functions, except in the case where a device's mapped
       memory is properly conceived of as being either totally or
       partially read-only. See the definitions in class Range for details.  */
    virtual bool canRead(uint32 offset);
    virtual bool canWrite(uint32 offset);
};

#endif /* _DEVICEMAP_H_ */
