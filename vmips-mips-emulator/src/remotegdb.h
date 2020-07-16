/* remotegdb.h - GNU Debugger glue for the VMIPS external debugger
    interface, based on
   gdb/serial.h - Remote serial support interface definitions for GDB,
    the GNU Debugger.
   Copyright 1992, 1993 Free Software Foundation, Inc.
   Copyright 2001, 2002, 2003 Brian R. Gaeke.

This file is part of GDB and VMIPS.

VMIPS is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

VMIPS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */

/* (brg) This file consists almost entirely of code taken from the GNU
 * debugger (gdb) version 4.17, from file gdb/serial.h.  Additions by me
 * (brg) have been tagged with my initials.
 */

#ifndef _REMOTEGDB_H_
#define _REMOTEGDB_H_

/* brg - added glue code */
#include "types.h"
#define ULONGEST uint64
#if defined(PARAMS)
# undef PARAMS
#endif
#define PARAMS(x) x
typedef int serial_t;
/* brg - end added glue code */

/* brg - added prototypes */
int fromhex (int a);
int tohex (int nib);
int hexnumlen (ULONGEST num);
int readchar (int timeout);
void remote_send (char *buf);
int putpkt (char *buf);
int read_frame (char *buf);
void getpkt (char *buf, int forever);
/* brg - end added prototypes */

/* Having this larger than 400 causes us to be incompatible with m68k-stub.c
   and i386-stub.c.  Normally, no one would notice because it only matters
   for writing large chunks of memory (e.g. in downloads).  Also, this needs
   to be more than 400 if required to hold the registers (see below, where
   we round it up based on REGISTER_BYTES).  */
/* brg - adjusted this to be 8 * 91 (90 regs in gdb) and moved it from
   remotegdb.cc to here */
#define PBUFSIZ 728

/* ... */

/* Read one char from the serial device with TIMEOUT seconds to wait
   or -1 to wait forever.  Use timeout of 0 to effect a poll. Returns
   char if ok, else one of the following codes.  Note that all error
   codes are guaranteed to be < 0.  */

#define SERIAL_ERROR -1		/* General error, see errno for details */
#define SERIAL_TIMEOUT -2
#define SERIAL_EOF -3

extern int serial_readchar PARAMS ((serial_t scb, int timeout));

#define SERIAL_READCHAR(SERIAL_T, TIMEOUT)  serial_readchar (SERIAL_T, TIMEOUT)

/* ... */

/* Write LEN chars from STRING to the port SERIAL_T.  Returns 0 for
   success, non-zero for failure.  */

extern int serial_write PARAMS ((serial_t scb, const char *str, int len));

#define SERIAL_WRITE(SERIAL_T, STRING,LEN)  serial_write (SERIAL_T, STRING, LEN)

/* brg - added glue code */
#if defined(PARAMS)
# undef PARAMS
#endif
/* brg - end added glue code */

#endif /* _REMOTEGDB_H_ */
