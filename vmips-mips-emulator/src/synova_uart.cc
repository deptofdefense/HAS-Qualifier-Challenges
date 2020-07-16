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
#include "synova_uart.h"
#include "spimconsreg.h"
#include "vmips.h"
#include <cassert>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#define CPU_SPEED	(10000000)
#define BAUD_RATE	(200000)
#define TICK_COUNTER	(1600)	// 200kbit/s sending 32-bits at a time at a clock speed of 10MHz

#define UART_CR_IE_BIT          0x1     // Set to enable interrupts
#define UART_CR_RDY_BIT         0x2     // Set when data is ready to read from data register
#define UART_CR_INT_SET_BIT     0x4     // Set when an interrupt is triggered (interrupt is cleared on read from data register)
#define UART_CR_INT_CLEAR_BIT	0x8	// Clear any pending interrupt


SynovaUartDevice::SynovaUartDevice ( bool enable_read, bool enable_write, int read_fd, int write_fd, int read_irq, int write_irq, bool word_mode )
	: DeviceMap(16), DeviceInt(), read_fd( read_fd ), write_fd( write_fd ), read_irq( read_irq ), write_irq( write_irq ), write_interrupt_enable( false ), read_interrupt_enable( false ), read_interrupt_set( false ), write_interrupt_set( false ), enable_read( enable_read ), enable_write( enable_write ), word_mode( word_mode )
{
	read_tick_count = 0;
	write_tick_count = 0;

	read_word = 0;	// Currently reading in word
	read_value = 0;	// Read value in buffer
	read_word_pos = 0;	// Currently reading in word position

	write_word = 0;	// Currently writing word
	write_value = 0; // Write value in buffer
	write_word_pos = 0; 	// Currently writing word position

	max_fd = -1;

	if ( read_fd > max_fd )
		max_fd = read_fd + 1;

	if ( write_fd > max_fd )
		max_fd = write_fd + 1;

	tv_zero.tv_sec = 0;
	tv_zero.tv_usec = 0;

	write_value_ready = true;
	read_value_ready = false;
}

SynovaUartDevice::~SynovaUartDevice()
{

}

void SynovaUartDevice::uart_tick( void )
{

	if ( enable_read && read_tick_count >= TICK_COUNTER )
	{
		uint8 read_byte;

		// Poll read
		fd_set read_set;

		FD_ZERO( &read_set );
		FD_SET( read_fd, &read_set );

		int read_count = select( read_fd+1, &read_set, NULL, NULL, &tv_zero );

		if ( read_count > 0 && FD_ISSET( read_fd, &read_set ) )
		{
			// Data available
			ssize_t read_count = read( read_fd, &read_byte, 1 );

			if ( read_count == 1 )
			{
				if ( word_mode )
				{
					// Read into little endian position (1-byte at a time)
					read_word |= ((uint32)read_byte << ((3-read_word_pos)<<3));
					read_word_pos++;

					if ( read_word_pos == 4 )
					{
						// Save read word into read value
						read_value = read_word;
						read_value_ready = true;

						// Reset
						read_word = 0;
						read_word_pos = 0;

						// Check for interrupt and assert it
						if ( read_interrupt_enable )
						{
							assertInt( read_irq );
							read_interrupt_set = true;
						}
					}
				}
				else
				{
					// Byte mode read
					read_value = read_byte;
					read_value_ready = true;
						
					// Check for interrupt and assert it
					if ( read_interrupt_enable )
					{
						assertInt( read_irq );
						read_interrupt_set = true;
					}
				}
			}
			else
			{
				// Kill container
				exit(1);
			}
		}
		read_tick_count = 0;
	}
	else
		read_tick_count++;

	if ( enable_write && write_tick_count >= TICK_COUNTER )
	{
		if ( write_value_ready == false )
		{
			if ( word_mode )
			{
				if ( write_word_pos == 0 )
					write_word = write_value;

				write_word_pos++;

				// Send any data we have now
				if ( write_word_pos == 3 )
				{
					write_word = ((write_word & 0xFF) << 24) | ((write_word & 0xFF00) << 8) | ((write_word & 0xFF0000) >> 8) | ((write_word & 0xFF000000) >> 24);

					ssize_t write_count = write( write_fd, &write_word, 4 );

					// TODO: Handle error
					if ( write_interrupt_enable )
					{
						assertInt( write_irq );
						write_interrupt_set = true;
					}

					write_word_pos = 0;

					// Accept new writes
					write_value_ready = true;
				}
			}
			else
			{
				// Byte mode write
				uint8 temp_val = write_value;
				ssize_t write_count = write( write_fd, &temp_val, 1 );

				if ( write_count != 1 )
				{
					// Kill container
					exit(1);
				}

				// TODO: Handle error
				if ( write_interrupt_enable )
				{
					assertInt( write_irq );
					write_interrupt_set = true;
				}
			
				// Accept new writes	
				write_value_ready = true;
			}
		}
		write_tick_count = 0;
	}
	else
		write_tick_count++;
}

uint32 SynovaUartDevice::fetch_word( uint32 offset, int mode, DeviceExc *client)
{
	uint32 word = 0;

	switch( offset / 4 ) {
	case 0:		// Read UART control
		if ( enable_read )
		{
			word = read_interrupt_enable ? UART_CR_IE_BIT : 0;
			
			if ( read_value_ready )
				word |= UART_CR_RDY_BIT;

			if ( read_interrupt_set )
				word |= UART_CR_INT_SET_BIT;
		}
		else
			word = 0;

		break;
	case 1:		// Read UART data
		if ( read_value_ready )
		{
			word = read_value;
			read_value_ready = false;

			if ( read_interrupt_set )
			{
				// Clear on read
				deassertInt( read_irq );
				read_interrupt_set = false;
			}
		}
		else
			word = 0;
		break;
	case 2:		// Write UART control
		if ( enable_write )
		{
			word = write_interrupt_enable ? UART_CR_IE_BIT : 0;

			// Read write ready flag
			if ( write_value_ready )
				word |= UART_CR_RDY_BIT;

			if ( write_interrupt_set )
				word |= UART_CR_INT_SET_BIT;
		}
		else
			word = 0;
		break;
	case 3:		// Write UART data
		break;
	default:
		assert( ! "reached" );
	}
	return machine->physmem->mips_to_host_word(word);
}

void SynovaUartDevice::store_word( uint32 offset, uint32 odata, DeviceExc *client )
{
	uint32 data = machine->physmem->host_to_mips_word(odata);

	switch( offset / 4 ) {
	case 0:		// Read UART control
		if ( enable_read )
			read_interrupt_enable = data & UART_CR_IE_BIT;
		break;
	case 1:		// Read UART data
		break;
	case 2:		// Write UART control
		if ( enable_write )
		{
			write_interrupt_enable = data & UART_CR_IE_BIT;

			if ( write_interrupt_enable && (data & UART_CR_INT_SET_BIT) )
			{
				assertInt( write_irq );
				write_interrupt_set = true;
			}

			if ( write_interrupt_set && (data & UART_CR_INT_CLEAR_BIT) )
			{
				deassertInt( write_irq );
				write_interrupt_set = false;
			}
		}
		break;
	case 3:		// Write UART data
		if ( enable_write )
		{
			if( write_value_ready )
			{
				write_value = data;
				write_value_ready = false;
			}

			if ( write_interrupt_set )
			{
				deassertInt( write_irq );
				write_interrupt_set = false;
			}
		}
		break;
	default:
		assert( ! "reached" );
	}
}

const char *SynovaUartDevice::descriptor_str() const
{
	return "Synova UART";
}
