/* Main driver program for VMIPS.
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

#include "clock.h"
#include "clockdev.h"
#include "clockreg.h"
#include "synova_timer.h"
#include "synova_uart.h"
#include "flag_device.h"
#include "cpzeroreg.h"
#include "debug.h"
#include "error.h"
#include "endiantest.h"
#include "haltreg.h"
#include "haltdev.h"
#include "intctrl.h"
#include "range.h"
#include "spimconsole.h"
#include "mapper.h"
#include "memorymodule.h"
#include "cpu.h"
#include "cpzero.h"
#include "spimconsreg.h"
#include "vmips.h"
#include "options.h"
#include "decrtc.h"
#include "decrtcreg.h"
#include "deccsr.h"
#include "deccsrreg.h"
#include "decstat.h"
#include "decserial.h"
#include "testdev.h"
#include "stub-dis.h"
#include "rommodule.h"
#include "interactor.h"
#include <fcntl.h>
#include <cerrno>
#include <csignal>
#include <cstdarg>
#include <cstring>
#include <string>
#include <exception>

#define RUN_CHALLENGE_EMULATOR	(1)

vmips *machine;

void
vmips::refresh_options(void)
{
	/* Extract important flags and things. */
	opt_bootmsg = opt->option("bootmsg")->flag;
	opt_clockdevice = opt->option("clockdevice")->flag;
	opt_debug = opt->option("debug")->flag;
	opt_dumpcpu = opt->option("dumpcpu")->flag;
	opt_dumpcp0 = opt->option("dumpcp0")->flag;
	opt_haltdevice = opt->option("haltdevice")->flag;
	opt_haltdumpcpu = opt->option("haltdumpcpu")->flag;
	opt_haltdumpcp0 = opt->option("haltdumpcp0")->flag;
	opt_instcounts = opt->option("instcounts")->flag;
	opt_memdump = opt->option("memdump")->flag;
	opt_realtime = opt->option("realtime")->flag;
 
	opt_clockspeed = opt->option("clockspeed")->num;
	clock_nanos = 1000000000/opt_clockspeed;

	opt_clockintr = opt->option("clockintr")->num;
	opt_clockdeviceirq = opt->option("clockdeviceirq")->num;
	opt_loadaddr = opt->option("loadaddr")->num;
	opt_memsize = opt->option("memsize")->num;
	opt_timeratio = opt->option("timeratio")->num;
 
	opt_memdumpfile = opt->option("memdumpfile")->str;
	opt_image = opt->option("romfile")->str;
	opt_execname = opt->option("execname")->str;
	opt_ttydev = opt->option("ttydev")->str;
	opt_ttydev2 = opt->option("ttydev2")->str;

	opt_decrtc = opt->option("decrtc")->flag;
	opt_deccsr = opt->option("deccsr")->flag;
	opt_decstat = opt->option("decstat")->flag;
	opt_decserial = opt->option("decserial")->flag;
	opt_spimconsole = opt->option("spimconsole")->flag;
	opt_testdev = opt->option("testdev")->flag;
}

/* Set up some machine globals, and process command line arguments,
 * configuration files, etc.
 */
vmips::vmips(int argc, char *argv[])
	: opt(new Options), state(HALT),
	  clock(0), clock_device(0), synova_timer(0), synova_uart1(0), synova_uart2(0), halt_device(0), spim_console(0),
	  num_instrs(0), interactor(0)
{
    opt->process_options (argc, argv);
	refresh_options();
}

vmips::~vmips()
{
	if (disasm) delete disasm;
	if (opt_debug && dbgr) delete dbgr;
	if (cpu) delete cpu;
	if (physmem) delete physmem;
	//if (clock) delete clock;  // crash in this dtor - double free?
	if (intc) delete intc;
	if (opt) delete opt;
}

void
vmips::setup_machine(void)
{
	/* Construct the various vmips components. */
	intc = new IntCtrl;
	physmem = new Mapper;
	cpu = new CPU (*physmem, *intc);

	/* Set up the debugger interface, if applicable. */
	if (opt_debug)
		dbgr = new Debug (*cpu, *physmem);

    /* Direct the libopcodes disassembler output to stderr. */
    disasm = new Disassembler (host_bigendian, stderr);
}

/* Connect the file or device named NAME to line number L of
 * console device C, or do nothing if NAME is "off".
 * If NAME is "stdout", then the device will be connected to stdout.
 */
void vmips::setup_console_line(int l, char *name, TerminalController *c, const
char *c_name)
{
	/* If they said to turn off the tty line, do nothing. */
	if (strcmp(name, "off") == 0)
		return;

	int ttyfd;
	if (strcmp(name, "stdout") == 0) {
		/* If they asked for stdout, give them stdout. */
		ttyfd = fileno(stdout);
	} else {
		/* Open the file or device in question. */
		ttyfd = open(name, O_RDWR | O_NONBLOCK);
		if (ttyfd == -1) {
			/* If we can't open it, warn and use stdout instead. */
			error("Opening %s (terminal %d): %s", name, l,
				strerror(errno));
			warning("using stdout, input disabled\n");
			ttyfd = fileno(stdout);
		}
	}

	/* Connect it to the SPIM-compatible console device. */
	c->connect_terminal(ttyfd, l);
	boot_msg("Connected fd %d to %s line %d.\n", ttyfd, c_name, l);
}

bool vmips::setup_spimconsole()
{
	/* FIXME: It would be helpful to restore tty modes on a SIGINT or
	   other abortive exit or when vmips has been foregrounded after
	   being in the background. The restoration mechanism should use
	   TerminalController::reinitialze_terminals() */

	if (!opt_spimconsole)
		return true;
	
	spim_console = new SpimConsoleDevice( clock );
	physmem->map_at_physical_address( spim_console, SPIM_BASE );
	boot_msg("Mapping %s to physical address 0x%08x\n",
		  spim_console->descriptor_str(), SPIM_BASE);
	
	intc->connectLine(IRQ2, spim_console);
	intc->connectLine(IRQ3, spim_console);
	intc->connectLine(IRQ4, spim_console);
	intc->connectLine(IRQ5, spim_console);
	intc->connectLine(IRQ6, spim_console);
	boot_msg("Connected IRQ2-IRQ6 to %s\n",spim_console->descriptor_str());

	setup_console_line(0, opt_ttydev, spim_console,
		spim_console->descriptor_str ());
	setup_console_line(1, opt_ttydev2, spim_console,
		spim_console->descriptor_str ());
	return true;
}

bool vmips::setup_clockdevice()
{
	if( !opt_clockdevice )
		return true;

	uint32 clock_irq;
	if( !(clock_irq = DeviceInt::num2irq( opt_clockdeviceirq )) ) {
		error( "invalid clockdeviceirq (%u), irq numbers must be 2-7.",
		       opt_clockdeviceirq );
		return false;
	}	

	/* Microsecond Clock at base physaddr CLOCK_BASE */
	clock_device = new ClockDevice( clock, clock_irq, opt_clockintr );
	physmem->map_at_physical_address( clock_device, CLOCK_BASE );
	boot_msg( "Mapping %s to physical address 0x%08x\n",
		  clock_device->descriptor_str(), CLOCK_BASE );

	intc->connectLine( clock_irq, clock_device );
	boot_msg( "Connected %s to the %s\n", DeviceInt::strlineno(clock_irq),
		  clock_device->descriptor_str() );

	return true;
}

bool vmips::setup_flagdevice()
{
#if RUN_CHALLENGE_EMULATOR
	// Setup the flag device in memory
	char *pFlagData = getenv( "FLAG" );
	//fprintf( stderr, "FLAG STRING:: %s\n", pFlagData );

	if ( pFlagData == NULL )
		flag_device = new FlagDevice( (uint8*)"empty", strlen("empty") );
	else
		flag_device = new FlagDevice( (uint8*)pFlagData, strlen(pFlagData) );

	if ( physmem->map_at_physical_address( flag_device, FLAG_DEVICE_BASE ) == -1 )
	{
		error( "Failed to map flag_device" );
		return false;
	}

	boot_msg( "Mapping %s to physical address 0x%08x\n",
		  flag_device->descriptor_str(), FLAG_DEVICE_BASE );

#endif

	return true;
}

bool vmips::setup_synovauart1device()
{
#if RUN_CHALLENGE_EMULATOR
	uint32 write_irq;
	if( !(write_irq = DeviceInt::num2irq( 3 )) ) {
		error( "invalid clockdeviceirq (%u), irq numbers must be 2-7.",
		       7 );
		return false;
	}

	// Byte mode, no read, write to stderr (FD # = 2)
	synova_uart1 = new SynovaUartDevice( false, true, -1, 2, 0, write_irq, false );
	if ( physmem->map_at_physical_address( synova_uart1, SYNOVA_UART1_BASE ) == -1 )
	{
		error( "Failed to map synova_uart" );
		return false;
	}

	boot_msg( "Mapping %s to physical address 0x%08x\n",
		  synova_uart1->descriptor_str(), SYNOVA_UART1_BASE );

	intc->connectLine( write_irq, synova_uart1 );
	boot_msg( "Connected %s to the %s\n", DeviceInt::strlineno(write_irq),
		  synova_uart1->descriptor_str() );

#endif

	return true;
}

bool vmips::setup_synovauart2device()
{
#if RUN_CHALLENGE_EMULATOR
	uint32 read_irq, write_irq;
	if( !(read_irq = DeviceInt::num2irq( 4 )) ) {
		error( "invalid clockdeviceirq (%u), irq numbers must be 2-7.",
		       7 );
		return false;
	}	

	if( !(write_irq = DeviceInt::num2irq( 5 )) ) {
		error( "invalid clockdeviceirq (%u), irq numbers must be 2-7.",
		       7 );
		return false;
	}

	// Word mode, read and write, read (FD # = 0, stdin), write (FD # = 1, stdout)
	synova_uart2 = new SynovaUartDevice( true, true, 0, 1, read_irq, write_irq, true );
	if ( physmem->map_at_physical_address( synova_uart2, SYNOVA_UART2_BASE ) == -1 )
	{
		error( "Failed to map synova_uart" );
		return false;
	}

	boot_msg( "Mapping %s to physical address 0x%08x\n",
		  synova_uart2->descriptor_str(), SYNOVA_UART2_BASE );

	intc->connectLine( read_irq, synova_uart2 );
	boot_msg( "Connected %s to the %s\n", DeviceInt::strlineno(read_irq),
		  synova_uart2->descriptor_str() );
	
	intc->connectLine( write_irq, synova_uart2 );
	boot_msg( "Connected %s to the %s\n", DeviceInt::strlineno(write_irq),
		  synova_uart2->descriptor_str() );

#endif

	return true;
}

bool vmips::setup_synovatimerdevice()
{
#if RUN_CHALLENGE_EMULATOR
	uint32 timer_irq;
	if( !(timer_irq = DeviceInt::num2irq( 7 )) ) {
		error( "invalid clockdeviceirq (%u), irq numbers must be 2-7.",
		       7 );
		return false;
	}	

	/* Microsecond Clock at base physaddr CLOCK_BASE */
	synova_timer = new SynovaTimerDevice( timer_irq );
	physmem->map_at_physical_address( synova_timer, CLOCK_BASE );
	boot_msg( "Mapping %s to physical address 0x%08x\n",
		  synova_timer->descriptor_str(), CLOCK_BASE );

	intc->connectLine( timer_irq, synova_timer );
	boot_msg( "Connected %s to the %s\n", DeviceInt::strlineno(timer_irq),
		  synova_timer->descriptor_str() );

#endif

	return true;
}

bool vmips::setup_decrtc()
{
	if (!opt_decrtc)
		return true;

	/* Always use IRQ3 ("hw interrupt level 1") for RTC. */
	uint32 decrtc_irq = DeviceInt::num2irq (3);

	/* DECstation 5000/200 DS1287-based RTC at base physaddr DECRTC_BASE */
	decrtc_device = new DECRTCDevice( clock, decrtc_irq );
	physmem->map_at_physical_address( decrtc_device, DECRTC_BASE );
	boot_msg( "Mapping %s to physical address 0x%08x\n",
		  decrtc_device->descriptor_str(), DECRTC_BASE );

	intc->connectLine( decrtc_irq, decrtc_device );
	boot_msg( "Connected %s to the %s\n", DeviceInt::strlineno(decrtc_irq),
		  decrtc_device->descriptor_str() );

	return true;
}

bool vmips::setup_deccsr()
{
	if (!opt_deccsr)
		return true;

	/* DECstation 5000/200 Control/Status Reg at base physaddr DECCSR_BASE */
    /* Connected to IRQ2 */
    static const uint32 DECCSR_MIPS_IRQ = DeviceInt::num2irq (2);
	deccsr_device = new DECCSRDevice (DECCSR_MIPS_IRQ);
	physmem->map_at_physical_address (deccsr_device, DECCSR_BASE);
	boot_msg ("Mapping %s to physical address 0x%08x\n",
		  deccsr_device->descriptor_str(), DECCSR_BASE);

	intc->connectLine (DECCSR_MIPS_IRQ, deccsr_device);
    boot_msg("Connected %s to the %s\n", DeviceInt::strlineno(DECCSR_MIPS_IRQ),
             deccsr_device->descriptor_str());

	return true;
}

bool vmips::setup_decstat()
{
	if (!opt_decstat)
		return true;

	/* DECstation 5000/200 CHKSYN + ERRADR at base physaddr DECSTAT_BASE */
	decstat_device = new DECStatDevice( );
	physmem->map_at_physical_address( decstat_device, DECSTAT_BASE );
	boot_msg( "Mapping %s to physical address 0x%08x\n",
		  decstat_device->descriptor_str(), DECSTAT_BASE );

	return true;
}

bool vmips::setup_decserial()
{
	if (!opt_decserial)
		return true;

	/* DECstation 5000/200 DZ11 serial at base physaddr DECSERIAL_BASE */
	/* Uses CSR interrupt SystemInterfaceCSRInt */
	decserial_device = new DECSerialDevice (clock, SystemInterfaceCSRInt);
	physmem->map_at_physical_address (decserial_device, DECSERIAL_BASE );
	boot_msg ("Mapping %s to physical address 0x%08x\n",
		  decserial_device->descriptor_str (), DECSERIAL_BASE );

	// Use printer line for console.
	setup_console_line (3, opt_ttydev, decserial_device,
      decserial_device->descriptor_str ());
	return true;
}

bool vmips::setup_testdev()
{
	if (!opt_testdev)
		return true;

	test_device = new TestDev();
	physmem->map_at_physical_address(test_device, TEST_BASE);
	boot_msg("Mapping %s to physical address 0x%08x\n",
		 test_device->descriptor_str(), TEST_BASE);
	return true;
}

bool vmips::setup_haltdevice()
{
	if( !opt_haltdevice )
		return true;

	halt_device = new HaltDevice( this );
	physmem->map_at_physical_address( halt_device, HALT_BASE );
	boot_msg( "Mapping %s to physical address 0x%08x\n",
		  halt_device->descriptor_str(), HALT_BASE );

	return true;
}

void vmips::boot_msg( const char *msg, ... )
{
	if( !opt_bootmsg )
		return;

	va_list ap;
	va_start( ap, msg );
	vfprintf( stderr, msg, ap );
	va_end( ap );

	fflush( stderr );
}

int
vmips::host_endian_selftest(void)
{
  try {
    EndianSelfTester est;
    machine->host_bigendian = est.host_is_big_endian();
    if (!machine->host_bigendian) {
      boot_msg ("Little-Endian host processor detected.\n");
    } else {
      boot_msg ("Big-Endian host processor detected.\n");
    }
    return 0;
  } catch (std::string &err) {
    boot_msg (err.c_str ());
    return -1;
  }
}

void
vmips::halt(void)
{
	state = HALT;
}

void
vmips::attn_key(void)
{
    state = INTERACT;
}

void vmips::dump_cpu_info(bool dumpcpu, bool dumpcp0) {
	if (dumpcpu) {
		cpu->dump_regs (stderr);
		cpu->dump_stack (stderr);
	}
	if (dumpcp0)
		cpu->cpzero_dump_regs_and_tlb (stderr);
}

void
vmips::step(void)
{
	/* Process instructions. */
	cpu->step();

	/* Keep track of time passing. Each instruction either takes
	 * clock_nanos nanoseconds, or we use pass_realtime() to check the
	 * system clock.
     */
	if( !opt_realtime )
	   clock->increment_time(clock_nanos);
	else
	   clock->pass_realtime(opt_timeratio);

	/* If user requested it, dump registers from CPU and/or CP0. */
    dump_cpu_info (opt_dumpcpu, opt_dumpcp0);

	num_instrs++;
}

long 
timediff(struct timeval *after, struct timeval *before)
{
    return (after->tv_sec * 1000000 + after->tv_usec) -
        (before->tv_sec * 1000000 + before->tv_usec);
}

bool
vmips::setup_rom ()
{
  // Open ROM image.
  FILE *rom = fopen (opt_image, "rb");
  if (!rom) {
    error ("Could not open ROM `%s': %s", opt_image, strerror (errno));
    return false;
  }
  // Translate loadaddr to physical address.
  opt_loadaddr -= KSEG1_CONST_TRANSLATION;
  ROMModule *rm;
  try {
    rm = new ROMModule (rom);
  } catch (int errcode) {
    error ("mmap failed for %s: %s", opt_image, strerror (errcode));
    return false;
  }
  // Map the ROM image to the virtual physical memory.
  physmem->map_at_physical_address (rm, opt_loadaddr);
  boot_msg ("Mapping ROM image (%s, %u words) to physical address 0x%08x\n",
            opt_image, rm->getExtent () / 4, rm->getBase ());
  // Point debugger at wherever the user thinks the ROM is.
  if (opt_debug)
    if (dbgr->setup (opt_loadaddr, rm->getExtent () / 4) < 0)
      return false; // Error in setting up debugger.
  return true;
}

bool
vmips::setup_ram ()
{
  // Make a new RAM module and install it at base physical address 0.
  memmod = new MemoryModule(opt_memsize);
  physmem->map_at_physical_address(memmod, 0);
  boot_msg( "Mapping RAM module (host=%p, %uKB) to physical address 0x%x\n",
	    memmod->getAddress (), memmod->getExtent () / 1024, memmod->getBase ());
  return true;
}

bool
vmips::setup_clock ()
{
  /* Set up the clock with the current time. */
  timeval start;
  gettimeofday(&start, NULL);
  timespec start_ts;
  TIMEVAL_TO_TIMESPEC( &start, &start_ts );
  clock = new Clock( start_ts );
  return true;
}

static void
halt_machine_by_signal (int sig)
{
  machine->halt();
}

/// Interact with user. Returns true if we should continue, false otherwise.
///
bool
vmips::interact ()
{
  TerminalController *c;
  if (opt_spimconsole) c = spim_console;
  else if (opt_decserial) c = decserial_device;
  else c = 0;
  if (c) c->suspend();
  bool should_continue = true;
  printf ("\n");
  if (!interactor) interactor = create_interactor ();
  interactor->interact ();
  if (state == INTERACT) state = RUN;
  if (state == HALT) should_continue = false;
  if (c) c->reinitialize_terminals ();
  return should_continue;
}

int timeval_subtract (struct timeval *result, struct timeval *x,struct timeval  *y)
{
  /* Perform the carry for the later subtraction by updating y. */
  if (x->tv_usec < y->tv_usec) {
    int nsec = (y->tv_usec - x->tv_usec) / 1000000 + 1;
    y->tv_usec -= 1000000 * nsec;
    y->tv_sec += nsec;
  }
  if (x->tv_usec - y->tv_usec > 1000000) {
    int nsec = (y->tv_usec - x->tv_usec) / 1000000;
    y->tv_usec += 1000000 * nsec;
    y->tv_sec -= nsec;
  }

  /* Compute the time remaining to wait.
     tv_usec is certainly positive. */
  result->tv_sec = x->tv_sec - y->tv_sec;
  result->tv_usec = x->tv_usec - y->tv_usec;

  /* Return 1 if result is negative. */
  return x->tv_sec < y->tv_sec;
}

void vmips::run_fast(void)
{
	struct timeval tv_temp;

	timespec ts_cur;
	timespec ts_prev;
	timespec ts_rem;
	timespec ts_diff;

	uint32_t instr_counter = 0;

	gettimeofday( &tv_temp, NULL );
	TIMEVAL_TO_TIMESPEC( &tv_temp, &ts_prev );

	if ( opt_debug )
	{
		state = (opt_debug ? DEBUG : RUN);
		while (state != HALT) {


			switch (state) {
				case RUN:
					while (state == RUN) { step (); }
					break;
				case DEBUG:
					while (state == DEBUG) { dbgr->serverloop(); }
					break;
				case INTERACT:
					while (state == INTERACT) { interact(); }
					break;
			}
			
			instr_counter++;

			if ( instr_counter == 500000 )
			{
				gettimeofday( &tv_temp, NULL );
				TIMEVAL_TO_TIMESPEC( &tv_temp, &ts_cur );

				timespecsub( &ts_cur, &ts_prev);

				TIMEVAL_TO_TIMESPEC( &tv_temp, &ts_prev );	

				// Synchronize to around 10MHz
				//printf( "S[%u] U[%u]\n", ts_cur.tv_sec, ts_cur.tv_nsec );
				if ( ts_cur.tv_sec == 0 && ts_cur.tv_nsec < 50000000 )
				{
					ts_diff.tv_sec = 0;
					ts_diff.tv_nsec = (50000000 - ts_cur.tv_nsec) + 20000000;

					nanosleep( &ts_diff, &ts_rem );

					timespecsub( &ts_prev, &ts_rem );
				}

				instr_counter = 0;
			}

			synova_timer->timer_tick();
			synova_uart1->uart_tick();
			synova_uart2->uart_tick();

			num_instrs++;
		}

		return;
	}
	else
	{
		while (state == RUN)
		{
		        cpu->step( );

			instr_counter++;

			if ( instr_counter == 500000 )
			{
				gettimeofday( &tv_temp, NULL );
				TIMEVAL_TO_TIMESPEC( &tv_temp, &ts_cur );

				timespecsub( &ts_cur, &ts_prev);

				TIMEVAL_TO_TIMESPEC( &tv_temp, &ts_prev );	

				// Synchronize to around 10MHz
				//printf( "S[%u] U[%u]\n", ts_cur.tv_sec, ts_cur.tv_nsec );
				if ( ts_cur.tv_sec == 0 && ts_cur.tv_nsec < 50000000 )
				{
					ts_diff.tv_sec = 0;
					ts_diff.tv_nsec = (50000000 - ts_cur.tv_nsec) + 20000000;

					nanosleep( &ts_diff, &ts_rem );

					timespecsub( &ts_prev, &ts_rem );
				}

				instr_counter = 0;
			}

#if 0	
			if( !opt_realtime )
			   clock->increment_time(clock_nanos);
			else
			   clock->pass_realtime(opt_timeratio);
#endif

			synova_timer->timer_tick();
			synova_uart1->uart_tick();
			synova_uart2->uart_tick();

		        num_instrs++;
		}
	}	
}

int
vmips::run()
{
	/* Check host processor endianness. */
	if (host_endian_selftest () != 0) {
		error( "Could not determine host processor endianness." );
		return 1;
	}

	/* Set up the rest of the machine components. */
	setup_machine();

	if (!setup_rom ()) 
	  return 1;

	if (!setup_ram ())
	  return 1;

#if RUN_CHALLENGE_EMULATOR
	// No halt device
	// No clock
	// No clock device
	// No RTC
	// No CSR
	//if (!setup_clock ())
	 // return 1;
	
	//if (!setup_clockdevice ())
	// return 1;
	if (!setup_synovatimerdevice())
		return 1;

	if (!setup_flagdevice())
		return 1;

	//if (!setup_decserial ())
	 // return 1;
	
	//if (!setup_spimconsole ())
	// return 1;
	
	if ( !setup_synovauart1device() )
		return 1;
	
	if ( !setup_synovauart2device() )
		return 1;

#else

	if (!setup_haltdevice ())
	  return 1;
	
	if (!setup_clock ())
	  return 1;

	if (!setup_clockdevice ())
	  return 1;

	if (!setup_decrtc ())
	  return 1;

	if (!setup_deccsr ())
	  return 1;

	if (!setup_decstat ())
	  return 1;

	if (!setup_decserial ())
	  return 1;

	if (!setup_spimconsole ())
	  return 1;

	if (!setup_testdev ())
	  return 1;
#endif

	signal (SIGQUIT, halt_machine_by_signal);

	boot_msg( "Hit Ctrl-\\ to halt machine, Ctrl-_ for a debug prompt.\n" );

	/* Reset the CPU. */
	boot_msg( "\n*************RESET*************\n\n" );
	cpu->reset();

	if (!setup_exe ())
	  return 1;

	timeval start;
	if (opt_instcounts)
		gettimeofday(&start, NULL);
#if RUN_CHALLENGE_EMULATOR
	state = RUN;

	run_fast();
#else
	state = (opt_debug ? DEBUG : RUN);
	while (state != HALT) {
		switch (state) {
			case RUN:
			    	while (state == RUN) { step (); }
				break;
			case DEBUG:
				while (state == DEBUG) { dbgr->serverloop(); }
				break;
			case INTERACT:
				while (state == INTERACT) { interact(); }
				break;
		}
	}
#endif

	timeval end;
	if (opt_instcounts)
		gettimeofday(&end, NULL);

	/* Halt! */
	boot_msg( "\n*************HALT*************\n\n" );

	/* If we're tracing, dump the trace. */
	cpu->flush_trace ();

	/* If user requested it, dump registers from CPU and/or CP0. */
	if (opt_haltdumpcpu || opt_haltdumpcp0) {
		fprintf(stderr,"Dumping:\n");
		dump_cpu_info (opt_haltdumpcpu, opt_haltdumpcp0);
	}

	if (opt_instcounts) {
		double elapsed = (double) timediff(&end, &start) / 1000000.0;
		fprintf(stderr, "%u instructions in %.5f seconds (%.3f "
			"instructions per second)\n", num_instrs, elapsed,
			((double) num_instrs) / elapsed);
	}

	if (opt_memdump) {
		fprintf(stderr,"Dumping RAM to %s...", opt_memdumpfile);
		if (FILE *ramdump = fopen (opt_memdumpfile, "wb")) {
			fwrite (memmod->getAddress (), memmod->getExtent (), 1, ramdump);
			fclose(ramdump);
			fprintf(stderr,"succeeded.\n");
		} else {
			error( "\nRAM dump failed: %s", strerror(errno) );
		}
	}

	/* We're done. */
	boot_msg( "Goodbye.\n" );
	return 0;
}

static void vmips_unexpected() {
  fatal_error ("unexpected exception");
}

static void vmips_terminate() {
  fatal_error ("uncaught exception");
}

int
main(int argc, char **argv)
try {
#if RUN_CHALLENGE_EMULATOR
	setvbuf( stdout, NULL, _IONBF, 0 );
#endif

	std::set_unexpected(vmips_unexpected);
	std::set_terminate(vmips_terminate);

	machine = new vmips(argc, argv);
	int rc = machine->run();
	delete machine; /* No disassemble Number Five!! */
	return rc;
}
catch( std::bad_alloc &b ) {
	fatal_error( "unable to allocate memory" );
}

