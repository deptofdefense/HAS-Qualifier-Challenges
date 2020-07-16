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

#ifndef _SYNOVA_UART_H_
#define _SYNOVA_UART_H_

#include "deviceint.h"
#include "devicemap.h"
#include "task.h"
#include "terminalcontroller.h"
#include <new>

// Physical Base Address/
#define SYNOVA_UART1_BASE           0x02000000

// Virtual (KSEG0) address
#define SYNOVA_UART1_ADDR           0xa2000000

#define SYNOVA_UART2_BASE           0x02000010
#define SYNOVA_UART2_ADDR           0xa2000010

class Clock;

// Synova UART
class SynovaUartDevice : public DeviceMap, public DeviceInt
{
public:
	SynovaUartDevice( bool enable_read, bool enable_write, int read_fd, int write_fd, int read_irq, int write_irq, bool word_mode );

	virtual ~SynovaUartDevice();

	virtual void uart_tick( void );

protected:

public:

	/* Fetch and store console control words. */
	virtual uint32 fetch_word(uint32 offset, int mode, DeviceExc *client);
	virtual void store_word(uint32 offset, uint32 data, DeviceExc *client);

	/* Return a description of this device. */
	virtual const char *descriptor_str() const;

protected:
	bool enable_read;	// Enable read part of UART
	bool enable_write;	// Enable write part of UART

	bool word_mode;		// Read/write data in word mode (32-bits) vs byte mode (8-bit)

	bool write_interrupt_enable;
	bool read_interrupt_enable;

	bool write_interrupt_set;
	bool read_interrupt_set;

	bool read_value_ready;
	bool write_value_ready;

	int read_fd;
	int write_fd;
	int read_irq;
	int write_irq;

	uint32 read_tick_count;
	uint32 write_tick_count;

	uint32 read_value;
	uint32 read_word;
	uint32 read_word_pos;

	uint32 write_value;
	uint32 write_word;
	uint32 write_word_pos;


	int max_fd;

	struct timeval tv_zero;
};

#endif /* _SYNOVA_UART_H_ */
