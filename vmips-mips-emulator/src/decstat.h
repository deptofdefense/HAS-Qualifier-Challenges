/* Headers for DEC 5000/200 error status registers emulation.
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

/* Memory-mapped device representing the Error Address Status Register
 * and ECC Check/Syndrome Status Register in the DEC 5000/200 (KN02).
 */

#ifndef _DECSTAT_H_
#define _DECSTAT_H_

#include "devicemap.h"

#define DECSTAT_BASE 0x1fd00000

class DECStatDevice : public DeviceMap {
  uint32 chksyn_reg;
  uint32 erradr_reg;
  bool interrupt;
public:
  DECStatDevice ();
  uint32 fetch_word (uint32 offset, int mode, DeviceExc *client);
  void store_word (uint32 offset, uint32 data, DeviceExc *client);
  const char *descriptor_str () const {
    return "DECstation 5000/200 CHKSYN & ERRADR";
  }
};

#endif /* _DECSTAT_H_ */
