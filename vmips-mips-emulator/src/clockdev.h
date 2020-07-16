/* Declarations to support the VMIPS clock device.
   Copyright 2003 Paul Twohey.

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

#ifndef _CLOCKDEV_H_
#define _CLOCKDEV_H_

#include "clock.h"
#include "deviceint.h"
#include "devicemap.h"
#include "devreg.h"
#include "task.h"
#include <new>

/* High resolution clock device. */
class ClockDevice : public DeviceMap, public DeviceInt
{
public:
	/* Create a new clock device that uses CLOCK as its time source and
	   which reports interrupts on irq IRQ at the regular interval
	   FREQUENCY_NS nanoseconds. */
	ClockDevice( Clock *clock, uint32 irq, long frequency_ns );

	/* Destroy the clock device and cancel any tasks it may have
	   waiting to execute on CLOCK. */
	virtual ~ClockDevice();

	/* Utility function called to trigger a clock interrupt, transitions
	   the clock to the READY state and asserts an interrupt if they
	   are enabled. Used in conjunction with class ClockTrigger to make
	   clock interrupts. */
	virtual void ready_clock();

	virtual uint32 fetch_word(uint32 offset, int mode, DeviceExc *client);
	virtual void store_word(uint32 offset, uint32 data, DeviceExc *client);

	/* Return a description of this device. */
	virtual const char *descriptor_str() const;

protected:
	/* Transition the clock into the UNREADY state and deassert the
	   clock interrupt. */
	virtual void unready_clock();

protected:
	/* Utility class to trigger interrupts to the clock device. */
	class ClockTrigger : public CancelableTask
	{
	public:
		ClockTrigger( ClockDevice *clock_device );
		virtual ~ClockTrigger();

	protected:
		virtual void real_task();

	protected:
		ClockDevice	*clock_device;
	};

protected:
	const uint32	irq;
	const long	frequency_ns;

	enum State {
		UNREADY	= 0,
		READY	= CTL_RDY
	};

	Clock		*clock;
	ClockTrigger	*clock_trigger;
	State		clock_state;
	bool		interrupt_enabled;
};

#endif /* _CLOCKDEV_H_ */
