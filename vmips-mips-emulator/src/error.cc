/* Implementation of error and warning reporting utilities.
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

#include <cstdio>
#include <cstdarg>
#include <cassert>
#include <cstdlib>
#include "error.h"

/* Print PRE literally (if non-NULL), then FMT with printf style
 * substitutions from AP and then POST literally (if non-NULL) to file
 * FILE. Then flush the file.
 */
static void format_help(FILE *file, const char *pre, const char *post,
	const char *fmt, va_list ap)
{
	assert(file);
	assert(fmt);

	if (pre)
		fputs(pre, file);
	
	vfprintf(file, fmt, ap);

	if (post)
		fputs(post, file);

	fflush(file);
}

void error(const char *msg, ...)
{
	va_list ap;
	va_start(ap, msg);
	format_help(stderr, "Error: ", "\n", msg, ap);
	va_end(ap);
}

void error_exit(const char *msg, ...)
{
	va_list ap;
	va_start(ap, msg);
	format_help(stderr, "Error: ", "\n", msg, ap);
	va_end(ap);

    exit(1);
}

void fatal_error(const char *msg, ...)
{
	va_list ap;
	va_start(ap, msg);
	format_help(stderr, "Fatal Error: ", "\n", msg, ap);
	va_end(ap);

	abort();
}

void warning(const char *msg, ...)
{
	va_list ap;
	va_start(ap, msg);
	format_help(stderr, "Warning: ", "\n", msg, ap);
	va_end(ap);
}
