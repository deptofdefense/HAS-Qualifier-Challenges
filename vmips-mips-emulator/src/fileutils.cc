/* Various file utility functions.
   Copyright 2004 Brian R. Gaeke.

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

#include "fileutils.h"
#include <cassert>

bool can_read_file (char *filename) {
	assert (filename && "Null pointer passed to can_read_file ()");
	FILE *f = fopen (filename, "r");
	if (!f)
		return false;
	fclose (f);
	return true;
}

uint32 get_file_size (FILE *fp) {
	long orig_pos, here, there; 

	assert (fp && "Null pointer passed to get_file_size ()");
	orig_pos = ftell (fp);
	fseek (fp, 0, SEEK_SET);
	here = ftell (fp);
	fseek (fp, 0, SEEK_END);
	there = ftell (fp);
	fseek (fp, orig_pos, SEEK_SET);
	return there - here;
}	  

