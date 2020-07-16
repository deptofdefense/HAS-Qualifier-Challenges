/* Headers for DZ11-based DEC 5000/200 serial chip emulation.
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

#ifndef _DECSERIAL_H_
#define _DECSERIAL_H_

#include "decserialreg.h"
#include "deviceint.h"
#include "devicemap.h"
#include "terminalcontroller.h"
class Clock;

class DECSerialDevice : public DeviceMap, public DeviceInt,
                        public TerminalController {
  static const int KEYBOARD_POLL_NS = 100;
  static const int KEYBOARD_REPOLL_NS = 100;
  static const int DISPLAY_READY_DELAY_NS = 100;
  void master_clear ();
  uint32 csr, rbuf, lpr, tcr, msr;
  uint8 deccsr_irq;
  bool keyboard_interrupt_enable;
  bool display_interrupt_enable;
  void assertCSRInt ();
  void deassertCSRInt ();
  bool receiver_done (const int line) const;
  bool transmitter_ready (const int line) const;
  bool keyboardInterruptReadyForLine (const int line) const;
  bool displayInterruptReadyForLine (const int line) const;
 public:
  DECSerialDevice (Clock *clock, uint8 deccsr_irq_);
  virtual ~DECSerialDevice() { }
  uint32 fetch_word (uint32 offset, int mode, DeviceExc *client);
  void store_word (uint32 offset, uint32 data, DeviceExc *client);
  const char *descriptor_str () const { return "DECstation 5000/200 DZ11 Serial"; }

  /* Call the routines in TerminalController and then assert or
     deassert the appropriate interrupt. */
  virtual void ready_display (int line);
  virtual void unready_display (int line, char data);
  virtual void unready_keyboard (int line);
protected:
  virtual void ready_keyboard (int line);
};

#endif /* _DECSERIAL_H_ */
