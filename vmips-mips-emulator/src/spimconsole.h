/* Declarations to support the SPIM-compatible console device.
   Copyright 2002, 2003 Paul Twohey.

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

#ifndef _SPIMCONSOLE_H_
#define _SPIMCONSOLE_H_

#include "deviceint.h"
#include "devicemap.h"
#include "task.h"
#include "terminalcontroller.h"
#include <new>
class Clock;

/* SPIM-compatible console device. */
class SpimConsoleDevice : public TerminalController, public DeviceMap,
                          public DeviceInt
{
public:
	/* Create a new SPIM-compatible console device with CLOCK as the time
	   source for the device. */
	SpimConsoleDevice( Clock *clock );

	/* Destroy the device and cancel the clock trigger. */
	virtual ~SpimConsoleDevice();

	/* Call the routines in TerminalController and then assert or
	   deassert the appropriate interrupt. */
	virtual void ready_display( int line );
	virtual void unready_display( int line, char data );
	virtual void unready_keyboard( int line );
protected:
	virtual void ready_keyboard( int line );

public:

	/* Transition the clock component fom either the READY or UNREADY
	   states into the READY state, asserting IRQ2 if clock interrupts
	   are enabled. Called by ClockTrigger to allow the SPIM console to
	   mark the passage of time. */
	virtual void ready_clock();

	/* Transition the clock component from either the READY or UNREADY
	   states into the UNREADY state. */
	virtual void unready_clock();

	/* Fetch and store console control words. */
	virtual uint32 fetch_word(uint32 offset, int mode, DeviceExc *client);
	virtual void store_word(uint32 offset, uint32 data, DeviceExc *client);

	/* Return a description of this device. */
	virtual const char *descriptor_str() const;

protected:
	class ClockTrigger : public CancelableTask
	{
	public:
		ClockTrigger( SpimConsoleDevice *console );
		virtual ~ClockTrigger();

	protected:
		virtual void real_task();

	protected:
		SpimConsoleDevice	*console;
	};

protected:
	static const long KEYBOARD_POLL_NS	= 400 * 1000;		//400us
	static const long KEYBOARD_REPOLL_NS	= 40 * 1000 * 1000;	// 40ms
	static const long DISPLAY_READY_DELAY_NS= 40 * 1000 * 1000;	// 40ms
	static const long CLOCK_TRIGGER_NS	= 1000 * 1000 *1000;	// 1s

protected:
	ClockTrigger	*trigger;
	bool		display_interrupt_enable[2];
	bool		keyboard_interrupt_enable[2];
	bool		clock_interrupt;
	State		clock_state;
};

#endif /* _SPIMCONSOLE_H_ */
