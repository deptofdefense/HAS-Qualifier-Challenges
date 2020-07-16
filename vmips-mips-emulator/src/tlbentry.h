/* Definitions to support the MIPS TLB entry wrapper class.
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

#ifndef _TLBENTRY_H_
#define _TLBENTRY_H_

/* Class representing a TLB entry for CP0.
 * 
 * The TLB entry is 64 bits wide and contains 7 fields, which may be
 * accessed using the accessor functions implemented here; they are
 * merely a convenience, as the entryHi and entryLo fields are public.
 */

#include "config.h"
#include "cpzeroreg.h"
#include "types.h"
#include <cstdlib>

class TLBEntry {
public:
	uint32 entryHi;
	uint32 entryLo;
	TLBEntry () {
#ifdef INTENTIONAL_CONFUSION
		entryHi = random ();
		entryLo = random ();
#endif
	}
	uint32 vpn() const { return (entryHi & EntryHi_VPN_MASK); }
	uint16 asid() const { return (entryHi & EntryHi_ASID_MASK); }
	uint32 pfn() const { return (entryLo & EntryLo_PFN_MASK); }
	bool noncacheable() const { return (entryLo & EntryLo_N_MASK); }
	bool dirty() const { return (entryLo & EntryLo_D_MASK); }
	bool valid() const { return (entryLo & EntryLo_V_MASK); }
	bool global() const { return (entryLo & EntryLo_G_MASK); }
};

#endif /* _TLBENTRY_H_ */
