/* DZ11-based DEC 5000/200 Serial chip emulation.
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

/* DZ11 serial device as implemented the DECstation 5000/200
 * 
 * This version has not been tested with multiple serial lines. An actual DZ11
 * supports 4 lines (on the 5000/200, these are the keyboard, mouse, modem,
 * and printer ports.) 
 *
 * This version does not support the CSR<MAINT> (loopback enable) bit.
 * 
 * If you are having trouble, try recompiling with the SERIAL_DEBUG macro
 * defined; see below. This will spew a large amount of stuff, some of which
 * may be helpful.
 */

/* #define SERIAL_DEBUG 1 */

#include "cpu.h"
#include "deccsr.h"
#include "decserial.h"
#include "deviceexc.h"
#include "mapper.h"
#include "vmips.h"
#include <cassert>

DECSerialDevice::DECSerialDevice (Clock *clock, uint8 deccsr_irq_)
  : TerminalController (clock, KEYBOARD_POLL_NS, KEYBOARD_REPOLL_NS,
                        DISPLAY_READY_DELAY_NS),
    deccsr_irq (deccsr_irq_)
{
  extent = 0x80000;
  master_clear ();
}

void
DECSerialDevice::master_clear ()
{
#if defined(SERIAL_DEBUG)
  fprintf (stderr, "DZ11 Master clear!\n");
#endif
  csr = 0;
  rbuf &= ~DZ_RBUF_DVAL;
  lpr = 0;
  tcr = 0;
}

static bool
TCR_LINE_ENABLED (uint32 Tcr, unsigned int Line)
{
  return ((bool) ((Tcr) & (DZ_TCR_LNENB0 << (Line))));
}

static unsigned int
CSR_TLINE (unsigned int Line)
{
  return (((Line) & 0x03) << 8);
}

#if defined(SERIAL_DEBUG)
static unsigned int
GET_CURRENT_CSR_TLINE (uint32 Csr)
{
  return (((Csr) >> 8) & 0x03);
}
#endif

static unsigned int
RBUF_RLINE (unsigned int Line)
{
  return (((Line) & 0x03) << 8);
}

bool DECSerialDevice::receiver_done (const int line) const {
  return (line_connected (line) && (lines[line].keyboard_state == READY));
}

bool DECSerialDevice::transmitter_ready (const int line) const {
  return (line_connected (line) && (lines[line].display_state == READY)
          && TCR_LINE_ENABLED(tcr, line));
}

uint32
DECSerialDevice::fetch_word (uint32 offset, int mode, DeviceExc *client)
{
  uint32 rv = 0;
  switch (offset & 0x18) {
  case DZ_CSR:
    csr &= ~(DZ_CSR_RDONE | DZ_CSR_TRDY | DZ_CSR_TLINE);
    if (csr & DZ_CSR_MSE)
      // Scan for lines with data.
      for (int line = 0; line < 4; ++line) {
        if (receiver_done (line))
          csr |= DZ_CSR_RDONE;
        if (transmitter_ready (line)) {
          csr |= DZ_CSR_TRDY;
          csr |= CSR_TLINE(line);
        }
      }
    rv = csr;
    break;
  case DZ_RBUF:
    rbuf &= ~DZ_RBUF_DVAL;
    for (int line = 0; line < 4; ++line) {
      if (receiver_done (line)) {
        unready_keyboard (line);
        rbuf = lines[line].keyboard_char | DZ_RBUF_DVAL;
        rbuf |= RBUF_RLINE(line);
        break;
      }
    }
    rv = rbuf;
    break;
  case DZ_TCR:
    rv = tcr;
#if defined(SERIAL_DEBUG)
    fprintf (stderr, "PC=0x%x DZ11 TCR read as 0x%x\n",
	    machine->cpu->debug_get_pc(), rv);
#endif
    break;
  case DZ_MSR:
    rv = msr;
#if defined(SERIAL_DEBUG)
    fprintf (stderr, "DZ11 MSR read as 0x%x\n", rv);
#endif
    break;
  }
  if (machine->cpu->is_bigendian()) {
      rv <<= 16;
  }
  return machine->physmem->mips_to_host_word(rv);
}

bool
DECSerialDevice::keyboardInterruptReadyForLine (const int line) const {
  return keyboard_interrupt_enable && receiver_done (line);
}

bool
DECSerialDevice::displayInterruptReadyForLine (const int line) const {
  return display_interrupt_enable && transmitter_ready (line);
}

void
DECSerialDevice::store_word (uint32 offset, uint32 odata, DeviceExc *client)
{
  uint32 data = machine->physmem->host_to_mips_word(odata);
#if defined(SERIAL_DEBUG)
  fprintf(stderr,"DZ11 Store(0x%08x) got 0x%08x, storing 0x%08x\n", offset,odata,data);
#endif
  // For testing purposes, we would like this device to work even when the
  // machine is in big-endian mode. The issues are: (0) This is not
  // necessarily true of the actual hardware.  (1) The hardware contains
  // 16-bit registers, but we only implement store_word. (2) The DeviceMap
  // class only implements store_byte and store_halfword in terms of
  // store_word; it makes no provision for implementing store_byte and
  // store_word in terms of store_halfword. So, hack it to work by peeking at
  // the CPU endianness, and shifting the data if we are in big-endian mode.
  if (machine->cpu->is_bigendian()) {
      data >>= 16;
  }
  uint16 data16 = data & 0x0ffff;
  switch (offset & 0x18) {
    case DZ_CSR:
#if defined(SERIAL_DEBUG)
      fprintf (stderr, "DZ11 write CSR as %x\n", data16);
#endif
      csr = data16;
      if (csr & DZ_CSR_CLR)
        master_clear ();
      display_interrupt_enable = (csr & DZ_CSR_TIE);
      keyboard_interrupt_enable = (csr & DZ_CSR_RIE);
#if defined(SERIAL_DEBUG)
      fprintf (stderr, "DZ11 Keyboard IE is now %s, Display IE now %s, "
               "selected tx line now %d\n",
               keyboard_interrupt_enable ? "on" : "off",
               display_interrupt_enable ? "on" : "off",
               GET_CURRENT_CSR_TLINE (csr));
#endif
      break;
    case DZ_LPR:
#if defined(SERIAL_DEBUG)
      fprintf (stderr, "DZ11 write LPR as %x\n", data16);
#endif
      lpr = data16;
      break;
    case DZ_TCR:
#if defined(SERIAL_DEBUG)
      fprintf (stderr, "PC=0x%x DZ11 write TCR as %x (%x)\n",
	      machine->cpu->debug_get_pc(), data16, odata);
#endif
      tcr = data16;
      break;
    case DZ_TDR: {
      int line = 3; // FIXME: should be GET_CURRENT_CSR_TLINE (csr);
      if (line_connected (line))
        unready_display (line, data16 & 0xff);
      break;
    }
  }

  // Check whether we have to assert or deassert the CSR IRQ now because
  // flags changed.
  bool any_enable_is_on = (csr & (DZ_CSR_RIE | DZ_CSR_TIE));
  if (!any_enable_is_on) {
    // They turned all the interrupt enable bits off. So cancel any pending
    // interrupt and just return.
    deassertCSRInt();
    return;
  }
  // There is an interrupt enable on. Check for a source which has been
  // ready to trigger an interrupt.
  bool any_source_is_ready = false;
  for (int line = 0; line < 4; ++line)
    any_source_is_ready = any_source_is_ready
                          || (displayInterruptReadyForLine (line)
                              || keyboardInterruptReadyForLine (line));
  if (any_source_is_ready) {
    assertCSRInt();
  } else {
    deassertCSRInt();
  }
}

void
DECSerialDevice::assertCSRInt () {
  assert (machine->deccsr_device && "DECCSR device required for DECSerial");
  machine->deccsr_device->assertInt (deccsr_irq);
}

void
DECSerialDevice::deassertCSRInt () {
  assert (machine->deccsr_device && "DECCSR device required for DECSerial");
  machine->deccsr_device->deassertInt (deccsr_irq);
}

void
DECSerialDevice::unready_display (int line, char data)
{
  TerminalController::unready_display (line, data);
  deassertCSRInt();
}

void
DECSerialDevice::ready_display (int line)
{
  TerminalController::ready_display (line);
  if (displayInterruptReadyForLine(line))
    assertCSRInt();
}

void
DECSerialDevice::unready_keyboard (int line)
{
  TerminalController::unready_keyboard (line);
  deassertCSRInt();
}

void
DECSerialDevice::ready_keyboard (int line)
{
  TerminalController::ready_keyboard (line);
  if (keyboardInterruptReadyForLine(line))
    assertCSRInt();
}

