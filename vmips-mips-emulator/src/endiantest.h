/* Host endianness self-testing object.  -*- C++ -*-
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

#ifndef _ENDIANTEST_H_
#define _ENDIANTEST_H_

#include "types.h"
#include <string>

class EndianSelfTester {
  bool host_bigendian;
public:
  EndianSelfTester () {
    uint32 x;
    char *p = (char *) &x;
    p[0] = 0;
    p[1] = 1;
    p[2] = 2;
    p[3] = 3;
    if (x == 0x03020100) {
      host_bigendian = false;
    } else if (x == 0x00010203) {
      host_bigendian = true;
    } else {
      throw std::string ("Unknown processor endianness.");
    }
  }

  bool host_is_big_endian () const { return host_bigendian; }
};

#endif // _ENDIANTEST_H_
