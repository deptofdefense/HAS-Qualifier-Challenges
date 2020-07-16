/* Memory-mapped ROM module emulation.
   Copyright 2003 Brian R. Gaeke.

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

#include "rommodule.h"
#include "fileutils.h"
#include "mmapglue.h"
#include <cerrno>

ROMModule::ROMModule (FILE *fp) : Range (0, 0, 0, MEM_READ) {
  extent = get_file_size (fp);

  // Try to map the file into memory. We use PROT_READ to indicate
  // read-only access.
  address = mmap (0, extent, PROT_READ, MAP_PRIVATE, fileno (fp), ftell (fp));
  int errcode = errno;
  if (address == MAP_FAILED)
    throw errcode;
}

ROMModule::~ROMModule () {
  munmap (address, extent);
}
