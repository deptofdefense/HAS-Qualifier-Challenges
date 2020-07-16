/* Definitions to support the physical memory system.
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

#ifndef _MAPPER_H_
#define _MAPPER_H_

#include "range.h"
#include <cstdio>
#include <vector>
class DeviceExc;

class Cache {
public:
        Cache(unsigned int bits_);
        ~Cache();

        struct Entry {
                bool valid;
                uint32 tag;
                uint32 data;
        };

        uint32 bits;
        uint32 size;
        uint32 mask;
        Entry *entries;
};

class Mapper {
public:
	struct BusErrorInfo {
		bool valid;
		DeviceExc *client;
		int32 mode;
		uint32 addr;
		int32 width;
		uint32 data;
	};

private:
	/* We keep lists of ranges in a vector of pointers to range
	   objects. */
	typedef std::vector<Range *> Ranges;

	/* Information about the last bus error triggered, if any. */
	BusErrorInfo last_berr_info;

	/* A pointer to the last mapping that was successfully returned by
	   find_mapping_range. */
	Range *last_used_mapping;

	/* A list of all currently mapped ranges. */
	Ranges ranges;

	/* Saved option values. */
	bool opt_bigendian;
	bool byteswapped;

	/* Add range R to the mapping. R must not overlap with any existing
	   ranges in the mapping. Return 0 if R added sucessfully or -1 if
	   R overlapped with an existing range. The Mapper takes ownership
	   of R. */
	int add_range (Range *r);

	/* Record information about a bad access that caused a bus error,
	   and then signal the exception to CLIENT. */
	void bus_error (DeviceExc *client, int32 mode, uint32 addr, int32 width,
		uint32 data = 0xffffffff);

	/* Cache configuration. */
	bool caches_isolated;
	bool caches_swapped;

	/* Cache objects. */
	Cache *icache;
	Cache *dcache;

	/* Cache implementation. */
	bool cache_use_entry(const Cache::Entry *const entry, uint32 tag,
		int32 mode) const;

	bool cache_hit(bool cacheable, int32 mode, uint32 &tag, uint32 &addr,
		Cache::Entry *&entry);

	uint32 cache_get_data_from_entry(const Cache::Entry *const entry,
			int size, uint32 addr);

	void cache_set_data_into_entry(Cache::Entry *const entry,
			int size, uint32 addr, uint32 data);

	uint32 cache_do_fill(Cache::Entry *const entry, uint32 tag,
			Range *l, uint32 offset, int32 mode, DeviceExc *client,
			int32 size, uint32 addr);

	void cache_write(int size, uint32 addr, uint32 data, Range *l,
		DeviceExc *client);

public:
	Mapper();
	~Mapper();

	/* Add range R to the mapping, as with add_range(), but first set its
	   base address to PA. The Mapper takes ownership of R. */
	int map_at_physical_address (Range *r, uint32 pa) {
		r->setBase (pa); return add_range (r);
	}

	/* Byte-swapping routines. The mips_to_host and host_to_mips routines
	   act according to the current setting of the 'bigendian' option.  */
	static uint32 swap_word(uint32 w);
	static uint16 swap_halfword(uint16 h);
	uint32 mips_to_host_word(uint32 w);
	uint32 host_to_mips_word(uint32 w);
	uint16 mips_to_host_halfword(uint16 h);
	uint16 host_to_mips_halfword(uint16 h);

	/* Fetch and store methods for word (32-bit), half-word (16-bit),
	   and byte (8-bit) widths. ADDR specifies a physical address, which
	   must be at the correct alignment, otherwise an address error
	   exception will be generated. The 32-bit fetches take an extra
	   MODE argument which tags the fetch as a instruction (INSTFETCH)
	   or data (DATALOAD) fetch. The CACHEABLE parameter is currently
	   not used, but represents the TLB's information about whether
	   the access should be cacheable. CLIENT receives any exceptions
	   which may be generated. */
	uint32 fetch_word(uint32 addr, int32 mode, bool cacheable,
		DeviceExc *client);
	uint16 fetch_halfword(uint32 addr, bool cacheable, DeviceExc *client);
	uint8 fetch_byte(uint32 addr, bool cacheable, DeviceExc *client);
	void store_word(uint32 addr, uint32 data, bool cacheable,
		DeviceExc *client);
	void store_halfword(uint32 addr, uint16 data, bool cacheable,
		DeviceExc *client);
	void store_byte(uint32 addr, uint8 data, bool cacheable,
		DeviceExc *client);

	/* Returns the Range object which would be used for a fetch or store to
	   physical address P. Ordinarily, you shouldn't mess with these. */
	Range *find_mapping_range(uint32 p);

	/* Print out a hex dump to file pointer F of the first 8 words of
	   stack starting at the physical stack pointer STACKPHYS.  An error
	   message is printed instead if STACKPHYS would lead to a bus
	   error or something which is not RAM (e.g. device I/O space). */
	void dump_stack(FILE *f, uint32 stackphys);

        /* Print a hex dump of the first word of memory at physical address
           ADDR to the filehandle pointed to by F. */
	void dump_mem(FILE *f, uint32 phys);

	/* Copy information about the most recent bus error to INFO. */
	void get_last_berr_info (BusErrorInfo &info) { info = last_berr_info; }

	/* Set the cache control bits to the given values. */
	void cache_set_control_bits(bool isolated, bool swapped);

};

#endif /* _MAPPER_H_ */
