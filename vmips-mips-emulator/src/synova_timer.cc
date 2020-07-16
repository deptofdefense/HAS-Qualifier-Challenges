/* Implementation of VMIPS clock device.
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

#include "synova_timer.h"
#include "devreg.h"
#include "vmips.h"

#include <cassert>
#include <cstddef>
#include <stdio.h>
#include <stdlib.h>

#define BUILD_SYNOVA_EMULATOR	(1)

SynovaTimerDevice::SynovaTimerDevice( uint32 irq )
	: DeviceMap(16), irq(irq),
	  interrupt_enabled(false), interrupt_set(false), timer_divider(1)
{
	assert (irq != IRQ0 && irq != IRQ1
            && "ClockDevice initialized with invalid IRQ");

	timer_hi = 0;
	timer_lo = 0;
	timer_counter = 0;
	timer_set_counter = 0;
	timer_divider = 0;	// Divide by 1
	timer_divider_counter = 0;
}

SynovaTimerDevice::~SynovaTimerDevice()
{

}

void SynovaTimerDevice::timer_tick()
{
	if ( timer_lo == 0xFFFFFFFF )
	{
		timer_hi++;
		timer_lo = 0;
	}
	else
		timer_lo++;

	if ( interrupt_enabled )
	{
		if ( timer_counter == 0 )
		{
			assertInt( irq );
			timer_counter = timer_set_counter;

			interrupt_set = true;
		}
		else
			timer_counter--;
	}
}

uint32 SynovaTimerDevice::fetch_word( uint32 offset, int mode, DeviceExc *client )
{
	switch( offset / 4 ) {
	case 0:		// simulated time - seconds
		return timer_hi;
		break;
	case 1:		// simulated time - microseconds
		return timer_lo;
		break;
	case 2:
		return timer_counter;
		break;
	case 3:		// control word
	{
		uint32 word = 0;
		if ( interrupt_enabled )
			word |= 0x1;

		if ( interrupt_set )
			word |= 0x2;

		// timer_divider = 0 = /1
		// timer_divider = 1 = /2
		// timer_divider = 2 = /4
		// timer_divider = 3 = /8
		word |=(timer_divider & 0x3) << 2;

		return word;
		break;
	}
	default:
		assert( ! "reached" );
		return 0;
	}
}

void SynovaTimerDevice::store_word( uint32 offset, uint32 data, DeviceExc *client )
{
	switch( offset / 4 ) {
	case 0:	// timer_hi
		timer_hi = data;
		break;
	case 1: // timer_lo
		timer_lo = data;
		break;
	case 2: // counter
		timer_set_counter = data;
		timer_counter = timer_set_counter;
		break;
	case 3:		// control word
		interrupt_enabled = data & 0x1;
		if ( interrupt_set && data & 0x2 )
		{
			interrupt_set = false;
			deassertInt( irq );
		}

		timer_divider = (data >> 2) & 0x3;

		return;
	default:
		assert( ! "reached" );
	}
}

const char *SynovaTimerDevice::descriptor_str() const
{
	return "Timer device";
}
