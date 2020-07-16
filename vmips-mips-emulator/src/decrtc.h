/* Headers for DS1287-based DEC 5000/200 real-time clock chip emulation.
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

/* Dallas Semiconductor DS1287 real-time clock chip, as implemented
 * as a memory-mapped device in the DEC 5000/200 (KN02).
 */

#ifndef _DECRTC_H_
#define _DECRTC_H_

#include <ctime>
#include "deviceint.h"
#include "devicemap.h"
#include "task.h"
class Clock;
class DeviceExc;

class DECRTCDevice : public DeviceMap, public DeviceInt {
protected:
  /* Utility class to trigger interrupts to the RTC. */
  class ClockTrigger : public CancelableTask
  {
  public:
    ClockTrigger (DECRTCDevice *rtc);
    virtual ~ClockTrigger ();
  protected:
    virtual void real_task ();
    DECRTCDevice *rtc;
  };
public:
  DECRTCDevice (Clock *_clock, uint32 _irq);
  virtual ~DECRTCDevice ();
  uint32 fetch_word (uint32 offset, int mode, DeviceExc *client);
  void store_word (uint32 offset, uint32 data, DeviceExc *client);
  const char *descriptor_str () const { return "DECstation 5000/200 RTC"; }
  void ready_clock ();
private:
  ClockTrigger *clock_trigger;
  Clock *clock;
  uint8 rtc_reg[64];
  uint8 write_masks[64];
  uint32 frequency_ns;
  uint32 irq;
  bool interrupt_enable;
  void update_host_time ();
  const struct tm *get_host_time () const;
  void unready_clock ();
};

#endif /* _DECRTC_H_ */
