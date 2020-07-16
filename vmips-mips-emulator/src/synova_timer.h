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

#ifndef _SYNOVA_CLOCKDEV_H_
#define _SYNOVA_CLOCKDEV_H_

#include "clock.h"
#include "deviceint.h"
#include "devicemap.h"
#include "devreg.h"
#include "task.h"
#include <new>

class vmips;

// Instruction count clock device
class SynovaTimerDevice : public DeviceMap, public DeviceInt
{
public:
	/* Create a new clock device that uses CLOCK as its time source and
	   which reports interrupts on irq IRQ at the regular interval
	   FREQUENCY_NS nanoseconds. */
	SynovaTimerDevice( uint32 irq );

	/* Destroy the clock device and cancel any tasks it may have
	   waiting to execute on CLOCK. */
	virtual ~SynovaTimerDevice();

	virtual uint32 fetch_word(uint32 offset, int mode, DeviceExc *client);
	virtual void store_word(uint32 offset, uint32 data, DeviceExc *client);

	/* Return a description of this device. */
	virtual const char *descriptor_str() const;

	virtual void timer_tick( void );

protected:
	const uint32	irq;


	enum State {
		STOP	= 0,
		RUNNING	= 1
	};

	bool	interrupt_enabled;
	bool	interrupt_set;

	uint32 timer_divider;
	uint32 timer_divider_counter;
	uint32 timer_hi;
	uint32 timer_lo;
	uint32 timer_counter;
	uint32 timer_set_counter;
};

#endif /* _SYNOVA_CLOCKDEV_H_ */
