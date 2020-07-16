/* Definitions to support the main driver program.  -*- C++ -*-
   Copyright 2001, 2003 Brian R. Gaeke.
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

#ifndef _VMIPS_H_
#define _VMIPS_H_

#include "types.h"
#include <cstdio>
#include <new>

class Mapper;
class CPU;
class IntCtrl;
class Options;
class MemoryModule;
class Debug;
class Clock;
class ClockDevice;
class SynovaTimerDevice;
class SynovaUartDevice;
class FlagDevice;
class HaltDevice;
class SpimConsoleDevice;
class TerminalController;
class DECRTCDevice;
class DECCSRDevice;
class DECStatDevice;
class DECSerialDevice;
class TestDev;
class Disassembler;
class Interactor;

long timediff(struct timeval *after, struct timeval *before);

class vmips
{
public:
	// Machine states
	enum { HALT, RUN, DEBUG, INTERACT }; 

	Mapper		*physmem;
	CPU		*cpu;
	IntCtrl		*intc;
	Options		*opt;
	MemoryModule	*memmod;
	Debug	*dbgr;
	Disassembler	*disasm;
	bool		host_bigendian;

	int			state;
	bool halted() const { return (state == HALT); }

	Clock		*clock;
	ClockDevice	*clock_device;
	SynovaTimerDevice *synova_timer;
	SynovaUartDevice *synova_uart1;
	SynovaUartDevice *synova_uart2;
	FlagDevice 	*flag_device;
	HaltDevice	*halt_device;
	SpimConsoleDevice	*spim_console;
	DECRTCDevice	*decrtc_device;
	DECCSRDevice	*deccsr_device;
	DECStatDevice	*decstat_device;
	DECSerialDevice	*decserial_device;
	TestDev		*test_device;

	/* Cached versions of options: */
	bool		opt_bootmsg;
	bool		opt_clockdevice;
	bool		opt_debug;
	bool		opt_dumpcpu;
	bool		opt_dumpcp0;
	bool		opt_haltdevice;
	bool		opt_haltdumpcpu;
	bool		opt_haltdumpcp0;
	bool		opt_instcounts;
	bool		opt_memdump;
	bool		opt_realtime;
	bool		opt_decrtc;
	bool		opt_deccsr;
	bool		opt_decstat;
	bool		opt_decserial;
	bool		opt_spimconsole;
	bool		opt_testdev;
	uint32		opt_clockspeed;
	uint32		clock_nanos;
	uint32		opt_clockintr;
	uint32		opt_clockdeviceirq;
	uint32		opt_loadaddr;
	uint32		opt_memsize;
	uint32		opt_timeratio;
	char		*opt_image;
	char		*opt_execname;
	char		*opt_memdumpfile;
	char		*opt_ttydev;
	char		*opt_ttydev2;

private:
	uint32	num_instrs;
	Interactor *interactor;

	/* If boot messages are enabled with opt_bootmsg, print MSG as a
	   printf(3) style format string for the remaing arguments. */
	virtual void boot_msg( const char *msg, ... );

	/* Initialize the SPIM-compatible console device and connect it to
	   configured terminal lines. */
	virtual bool setup_spimconsole();

	/* Initialize the test-only device. */
	virtual bool setup_testdev();

	/* Initialize the clock device if it is configured. Return true if
	   there are no initialization problems, otherwise return false. */
	virtual bool setup_clockdevice();

	/* Initialize the DEC RTC if it is configured. Return true if
	   there are no initialization problems, otherwise return false. */
	virtual bool setup_decrtc();

	/* Initialize the DEC CSR if it is configured. Return true if
	   there are no initialization problems, otherwise return false. */
	virtual bool setup_deccsr();

	/* Initialize the DEC status registers if configured. Return true if
	   there are no initialization problems, otherwise return false. */
	virtual bool setup_decstat();

	/* Initialize the DEC serial device if it is configured. Return true if
	   there are no initialization problems, otherwise return false. */
	virtual bool setup_decserial();

	virtual bool setup_synovatimerdevice();

	virtual bool setup_synovauart1device();
	virtual bool setup_synovauart2device();

	virtual bool setup_flagdevice();

	virtual bool setup_rom();

	virtual bool setup_exe();

	bool load_elf (FILE *fp);
	bool load_ecoff (FILE *fp);
	char *translate_to_host_ram_pointer (uint32 vaddr);

	virtual bool setup_ram();

	virtual bool setup_clock();

	/* Connect the file or device named NAME to line number L of
	   console device C, or do nothing if NAME is "off".  */
	virtual void setup_console_line(int l, char *name,
		TerminalController *c, const char *c_name);

	/* Initialize the halt device if it is configured. */
	bool setup_haltdevice();

public:
	void refresh_options(void);
	vmips(int argc, char **argv);

	/* Cleanup after we are done. */
	virtual ~vmips();
	
	void setup_machine(void);

	/* Attention key was pressed. */
	void attn_key(void);

	/* Halt the simulation. */
	void halt(void);

	/* Interact with user. */
	bool interact(void);

	int host_endian_selftest(void);

	void dump_cpu_info(bool dumpcpu, bool dumpcp0);

	void run_fast(void);
	void step(void);
	int run(void);
};

extern vmips *machine;

#endif /* _VMIPS_H_ */
