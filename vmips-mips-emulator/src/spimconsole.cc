/* Implementation of SPIM compatible console device.
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

#include "clock.h"
#include "mapper.h"
#include "spimconsole.h"
#include "spimconsreg.h"
#include "vmips.h"
#include <cassert>

SpimConsoleDevice::SpimConsoleDevice (Clock *clock)
	: TerminalController (clock, KEYBOARD_POLL_NS, KEYBOARD_REPOLL_NS,
                          DISPLAY_READY_DELAY_NS),
	  DeviceMap (36),
	  trigger (0), clock_interrupt (false), clock_state (UNREADY)
{
	display_interrupt_enable[0] = display_interrupt_enable[1] = false;
	keyboard_interrupt_enable[0] = keyboard_interrupt_enable[1] = false;

	trigger = new ClockTrigger( this );
	clock->add_deferred_task( trigger, CLOCK_TRIGGER_NS );
}

SpimConsoleDevice::~SpimConsoleDevice()
{
	assert( trigger );

	trigger->cancel();
}

void SpimConsoleDevice::unready_display( int line, char data )
{
	TerminalController::unready_display( line, data );
	deassertInt( line == 0 ? IRQ4 : IRQ6 );	
}

void SpimConsoleDevice::ready_display( int line )
{
	TerminalController::ready_display( line );
	if( display_interrupt_enable[line] )
		assertInt( line == 0 ? IRQ4 : IRQ6 );
}

void SpimConsoleDevice::unready_keyboard( int line )
{
	TerminalController::unready_keyboard( line );
	deassertInt( line == 0 ? IRQ3 : IRQ5 );
}

void SpimConsoleDevice::ready_keyboard( int line )
{
	TerminalController::ready_keyboard( line );
	if( keyboard_interrupt_enable[line] )
		assertInt( line == 0 ? IRQ3 : IRQ5 );
}

void SpimConsoleDevice::unready_clock()
{
	clock_state = UNREADY;
	deassertInt( IRQ2 );
}

void SpimConsoleDevice::ready_clock()
{
	clock_state = READY;

	trigger = new ClockTrigger( this );
	clock->add_deferred_task( trigger, CLOCK_TRIGGER_NS );

	if( clock_interrupt )
		assertInt( IRQ2 );
}

uint32 SpimConsoleDevice::fetch_word( uint32 offset, int mode,
				      DeviceExc *client)
{
	uint32 word = 0;
	
	switch( offset / 4 ) {
	case 0:		// keyboard 1 control
		word = keyboard_interrupt_enable[0] ? CTL_IE : 0;
		if( line_connected(0) )
			word |= lines[0].keyboard_state;
		if (!keyboard_interrupt_enable[0])
			deassertInt (IRQ3);	
		break;
	case 1:		// keyboard 1 data
		if( line_connected(0) ) {
			unready_keyboard( 0 );
			word = lines[0].keyboard_char;
		}
		break;
	case 2:		// display 1 control
		word = display_interrupt_enable[0] ? CTL_IE : 0;
		if( line_connected(0) )
			word |= lines[0].display_state;
		else
			word |= CTL_RDY;
		if (!display_interrupt_enable[0])
			deassertInt (IRQ4);	
		break;
	case 3:		// display 1 data
		break;
	case 4:		// keyboard 2 control
		word = keyboard_interrupt_enable[1] ? CTL_IE : 0;
		if( line_connected(1) )
			word |= lines[1].keyboard_state;
		if (!keyboard_interrupt_enable[1])
			deassertInt (IRQ5);	
		break;
	case 5:		// keyboard 2 data
		if( line_connected(1) ) {
			unready_keyboard( 1 );
			word = lines[1].keyboard_char;
		}
		break;
	case 6:		// display 2 control
		word = display_interrupt_enable[1] ? CTL_IE : 0;
		if( line_connected(1) )
			word |= lines[1].display_state;
		else
			word |= CTL_RDY;
		if (!display_interrupt_enable[1])
			deassertInt (IRQ6);	
		break;
	case 7:		// display 2 data
		break;
	case 8:		// clock control
		word = clock_interrupt ? CTL_IE : 0;
		word |= clock_state;
		unready_clock();
		break;
	default:
		assert( ! "reached" );
	}
	return machine->physmem->mips_to_host_word(word);
}

void SpimConsoleDevice::store_word( uint32 offset, uint32 odata,
				    DeviceExc *client )
{
	uint32 data = machine->physmem->host_to_mips_word(odata);

	switch( offset / 4 ) {
	case 0:		// keyboard 1 control
		keyboard_interrupt_enable[0] = data & CTL_IE;
		if( line_connected(0) && keyboard_interrupt_enable[0]
		    && lines[0].display_state == READY )
			assertInt( IRQ3 );
		break;
	case 1:		// keyboard 1 data
		break;
	case 2:		// display 1 control
		display_interrupt_enable[0] = data & CTL_IE;
		if( line_connected(0) && display_interrupt_enable[0]
		    && lines[0].display_state == READY )
			assertInt( IRQ4 );
		break;
	case 3:		// display 1 data
		if( line_connected(0) )
			unready_display( 0, data );
		break;
	case 4:		// keyboard 2 control
		keyboard_interrupt_enable[1] = data & CTL_IE;
		if( line_connected(1) && keyboard_interrupt_enable[1] &&
		    lines[1].keyboard_state == READY )
			assertInt( IRQ5 );
		break;
	case 5:		// keyboard 2 data
		break;
	case 6:		// display 2 control
		display_interrupt_enable[1] = data & CTL_IE;
		if( line_connected(1) && display_interrupt_enable[1] &&
		    lines[1].display_state == READY )
			assertInt( IRQ6 );
		break;
	case 7:		// display 2 data
		if( line_connected(1) )
			unready_display( 1, data );
		break;
	case 8:		// clock control
		clock_interrupt = data & CTL_IE;
		if( clock_interrupt && clock_state == READY )
			assertInt( IRQ2 );
		break;
	default:
		assert( ! "reached" );
	}
}

const char *SpimConsoleDevice::descriptor_str() const
{
	return "SPIM console";
}


SpimConsoleDevice::ClockTrigger::ClockTrigger( SpimConsoleDevice *console )
	: console( console )
{
	assert( console );
}

SpimConsoleDevice::ClockTrigger::~ClockTrigger()
{
}

void SpimConsoleDevice::ClockTrigger::real_task()
{
	console->ready_clock();
}
