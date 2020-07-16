/* Table of supported options, their meanings, and defaults.
   Copyright 2001, 2003 Brian R. Gaeke.
   Copyright 2002 Paul Twohey.

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

#ifndef _OPTIONTBL_H_
#define _OPTIONTBL_H_

/* WARNING!
 * This file is parsed by a Perl script (doc/makeoptdoc.pl), and
 * that script is not as smart as the C compiler and preprocessor.
 * Therefore, the format of this file must be as follows...
 *   <junk>
 *   nametable [] = {       // no space btwn nametable and []
 *    { "option-name", TYPE },
 *    Comment explaining option, delimited by slash star star and
 *    star star slash
 *    (repeat as necessary)
 *    { NULL, ... }
 *   }
 *   <junk>
 *   defaults_table [] = {       // no space
 *    "default", "default", ...
 *    NULL
 *   }
 *   <junk>
 * Whitespace is ignored. Stuff marked as <junk> is ignored.
 * In the individual tables, anything after NULL is ignored.
 */

/* This is the official table of options. Each one has a name
 * (an arbitrary character string) and a type, which
 * may be FLAG (i.e., Boolean), STR (string), or NUM (number).
 */

static Option nametable[] = {
    { "haltdumpcpu", FLAG },
    /** Controls whether the CPU registers and stack will be dumped
        on halt. For the output format, please see the description of the
        @option{dumpcpu} option, below. **/

    { "haltdumpcp0", FLAG },
    /** Controls whether the system control coprocessor (CP0) registers
        and the contents of the translation lookaside buffer (TLB) will be
        dumped on halt. For the output format, please see the description
        of the @option{dumpcp0} option, below. **/

    { "excpriomsg", FLAG },
    /** Controls whether exception prioritizing messages will
        be printed.  These messages attempt to explain which of
        a number of exceptions caused by the same instruction
        will be reported. **/

    { "excmsg", FLAG },
    /** Controls whether every exception will cause a message
        to be printed. The message gives the exception code, a
        short explanation of the exception code, its priority,
        the delay slot state of the virtual CPU, and states
        what type of memory access the exception was caused by,
        if applicable. Interrupt exceptions are only printed if
        @option{reportirq} is also set; when they occur, they also have Cause
        and Status register information printed. TLB misses will have fault
        address and user/kernel mode information printed. **/

    { "bootmsg", FLAG },
    /** Controls whether boot-time and halt-time messages will be printed.
        These include ROM image size, self test messages, reset and halt
        announcements, and possibly other messages. **/

    { "instdump", FLAG },
    /** Controls whether every instruction executed will be disassembled
        and printed. DEFAULT GOES HERE. The output is in the following format:
        @example
        PC=0xbfc00000 [1fc00000]    24000000 li $zero,0
        @end example
        The first column contains the PC (program counter), followed by
        the physical translation of that address in brackets. The third
        column contains the machine instruction word at that address,
        followed by the assembly language corresponding to that word.
        All of the constants except for the assembly language are in
        hexadecimal. **/

    { "dumpcpu", FLAG },
    /** Controls whether the CPU registers and stack will be dumped after every
        instruction. DEFAULT GOES HERE. The output is in the following format:
        @example
        Reg Dump: [ PC=bfc00180  LastInstr=0000000d  HI=00000000  LO=00000000
                    DelayState=NORMAL  DelayPC=bfc00308  NextEPC=bfc00308
         R00=00000000  R01=00000000  R02=00000000  R03=a00c000e  R04=0000000a 
         ...
         R30=00000000  R31=bfc00308  ]
        Stack: 00000000 00000000 00000000 00000000 a2000008 a2000008 ...
        @end example

        (Some values have been omitted for brevity.)
        Here, PC is the program counter, LastInstr is the last instruction
        executed, HI and LO are the multiplication/division result registers,
        DelayState and DelayPC are used in delay slot processing, NextEPC
        is what the Exception PC would be if an exception were to occur, and
        R00 ... R31 are the CPU general purpose registers. Stack represents
        the top few words on the stack.  All values are in hexadecimal.  **/

    { "dumpcp0", FLAG },
    /** Controls whether the system control coprocessor (CP0)
        registers and the contents of the translation lookaside buffer
        (TLB) will be dumped after every instruction.  DEFAULT GOES HERE.
        The output is in the following format:
        @example
        CP0 Dump Registers: [        R00=00000000  R01=00003200 
         R02=00000000  R03=00000000  R04=001fca10  R05=00000000 
         R06=00000000  R07=00000000  R08=7fb7e0aa  R09=00000000 
         R10=00000000  R11=00000000  R12=00485e60  R13=f0002124 
         R14=bfc00308  R15=0000703b ]
        Dump TLB: [
        Entry 00: (00000fc000000000) V=00000 A=3f P=00000 ndvg
        Entry 01: (00000fc000000000) V=00000 A=3f P=00000 ndvg
        Entry 02: (00000fc000000000) V=00000 A=3f P=00000 ndvg
        Entry 03: (00000fc000000000) V=00000 A=3f P=00000 ndvg
        Entry 04: (00000fc000000000) V=00000 A=3f P=00000 ndvg
        Entry 05: (00000fc000000000) V=00000 A=3f P=00000 ndvg
        ...
        Entry 63: (00000fc000000000) V=00000 A=3f P=00000 ndvg
        ]
        @end example
        Each of the R00 .. R15 are coprocessor zero registers, in
        hexadecimal.  The Entry 00 .. 63 lines are TLB entries. The 64-bit
        number in parentheses is the hexadecimal raw value of the entry. V
        is the virtual page number. A is the ASID. P is the physical page
        number. NDVG are the Non-cacheable, Dirty, Valid, and Global bits,
        uppercase if on, lowercase if off.  **/

    { "haltibe", FLAG },
    /** If @option{haltibe} is set to TRUE, the virtual machine will halt
        after an instruction fetch causes a bus error (exception
        code 6, Instruction bus error). This is useful if you
        are expecting execution to jump to nonexistent addresses in
        memory, and you want it to stop instead of calling the
        exception handler.  It is important to note that the machine
        halts after the exception is processed. **/

    { "haltbreak", FLAG },
    /** If @option{haltbreak} is set to TRUE, the virtual machine will halt
        when a breakpoint exception is encountered (exception
        code 9). This is equivalent to halting when a @code{break}
        instruction is encountered. It is important to note that the
        machine halts after the breakpoint exception is processed. **/

    { "haltdevice", FLAG },
    /** If @option{haltdevice} is set to TRUE, the halt device is mapped into
        physical memory, otherwise it is not. **/

    { "instcounts", FLAG },
    /** Set @option{instcounts} to TRUE if you want to see instruction
        counts, a rough estimate of total runtime, and execution
        speed in instructions per second when the virtual
        machine halts. DEFAULT GOES HERE.  The output is printed
        at the end of the run, and is in the following format:
        @example
        7337 instructions in 0.0581 seconds (126282.271 instructions per second)
        @end example
        **/

    { "romfile", STR },
    /** This is the name of the file which will be initially
        loaded into memory (at the address given in @option{loadaddr},
        typically 0xbfc00000) and executed when the virtual
        machine is reset. **/

    { "loadaddr", NUM },
    /** This is the virtual address where the ROM will be loaded.
        Note that the MIPS reset exception vector is always 0xbfc00000
        so unless you're doing something incredibly clever you should
        plan to have some executable code at that address. Since the
        caches and TLB are in an indeterminate state at the time of
        reset, the load address must be in uncacheable memory which
        is not mapped through the TLB (kernel segment "kseg1"). This
        effectively constrains the valid range of load addresses to
        between 0xa0000000 and 0xc0000000. **/

    { "memsize", NUM },
    /** This variable controls the size of the virtual CPU's "physical"
        memory in bytes. **/

    { "memdump", FLAG },
    /** If @option{memdump} is set, then the virtual machine will dump its RAM
        into a file, whose name is given by the @option{memdumpfile} option,
        at the end of the simulation run. **/

    { "memdumpfile", STR },
    /** This is the name of the file to which a RAM dump will be
        written at the end of the simulation run. **/

    { "reportirq", FLAG },
    /** If @option{reportirq} is set, then any change in the interrupt
        inputs from a device will be reported on stderr. Also, any
        Interrupt exception will be reported, if @option{excmsg} is also
        set. **/

    { "spimconsole", FLAG },
    /** When set, configure the SPIM-compatible console device.
        This is incompatible with @option{decserial}. **/

    { "ttydev", STR },
    /** This pathname will be used as the device from which reads from the
        SPIM-compatible console device's Keyboard 1 will take their data, and
        to which writes to Display 1 will send their data. If the OS supports
        ttyname(3), that call will be used to guess the default pathname.
        If the pathname is the single word @samp{off}, then the device will be
        disconnected.
        If the pathname is the single word @samp{stdout}, then the device
	will be connected to standard output, and input will be disabled. **/

    { "ttydev2", STR },
    /** See @option{ttydev} option; this one is just like it, but pertains
        to Keyboard 2 and Display 2.  **/

    { "debug", FLAG },
    /** If debug is set, then the gdb remote serial protocol backend will
        be enabled in the virtual machine. This will cause the machine to
        wait for gdb to attach and @samp{continue} before booting the ROM file.
        If debug is not set, then the machine will boot the ROM file
        without pausing. **/

    { "debugport", NUM },
    /** If debugport is set to something nonzero, then the gdb remote
        serial protocol backend will use the specified TCP port. **/

    { "realtime", FLAG },
    /** If @option{realtime} is set, then the clock device will cause simulated
        time to run at some fraction of real time, determined by the
        @option{timeratio} option. If realtime is not set, then simulated time
        will run at the speed given by the @option{clockspeed} option.  **/

    { "timeratio", NUM },
    /** If the @option{realtime} option is set, this option gives the
        number of times slower than real time at which simulated time will
        run. It has no effect if @option{realtime} is not set. **/

    { "clockspeed", NUM },
    /** If the @option{realtime} option is not set, you should set this
        option to the average speed in MIPS instructions per second at which
        your system runs VMIPS. You can get suitable values from turning
        on the @option{instcounts} option and running some of your favorite
        programs. If you increase the value of @option{clockspeed}, time will
        appear to pass more slowly for the simulated machine; if you decrease
        it, time will pass more quickly. (To be precise, one instruction is
        assumed to take 1.0e9/@option{clockspeed} nanoseconds.) This option
        has no effect if @option{realtime} is set. **/

    { "clockintr", NUM },
    /** This option gives the frequency of clock interrupts, in nanoseconds
        of simulated time, for the clock device. It does not affect the
        DECstation-compatible realtime clock. **/

    { "clockdeviceirq", NUM },
    /** This option gives the interrupt line to which the clock device is
        connected. Values must be a number 2-7 corresponding to an interrupt
        line reserved for use by hardware. **/

    { "clockdevice", FLAG },
    /** If this option is set, then the clock device is enabled. This will
        allow MIPS programs to take advantage of a high precision clock. **/

    { "dbemsg", FLAG },
    /** If this option is set, then the physical addresses of accesses
        that cause data bus errors (DBE exceptions) will be printed. **/

    { "decrtc", FLAG },
    /** If this option is set, then the DEC RTC device will be
        configured. **/

    { "deccsr", FLAG },
    /** If this option is set, then the DEC CSR (Control/Status Register)
        will be configured. **/

    { "decstat", FLAG },
    /** If this option is set, then the DEC CHKSYN and ERRADR registers
        will be configured. **/

    { "decserial", FLAG },
    /** If this option is set, then the DEC DZ11 serial device
        will be configured. This is incompatible with @option{spimconsole}. **/

    { "tracing", FLAG },
    /** If this option is set, VMIPS will keep a trace of the last few
        instructions executed in memory, and write it out when the machine
        halts.  This incurs a substantial performance penalty.  Use the
        @option{tracesize} option to set the size of the trace you want. **/

    { "tracesize", NUM },
    /** Set this option to the maximum number of instructions to keep in the
        dynamic instruction trace. This has no effect if @option{tracing} is
        not set. **/

    { "bigendian", FLAG },
    /** If this option is set, then the emulated MIPS CPU will be in
        Big-Endian mode.  Otherwise, it will be in Little-Endian mode. You
        must set it to correspond to the type of binaries that your
        assembler and compiler are configured to produce, which is not
        necessarily the same as the endianness of the CPU on which you
        are running VMIPS.  (The default may not be meaningful for your
        setup!) **/

    { "tracestartpc", NUM },
    /** If the tracing option is set, then this is the PC value which will
        trigger the start of tracing.  Otherwise it has no effect. **/

    { "traceendpc", NUM },
    /** If the tracing option is set, then this is the PC value which will
        trigger the end of tracing. Otherwise it has no effect. **/

    { "mipstoolprefix", STR },
    /** vmipstool uses this option to locate your MIPS-targetted cross
        compilation tools, if you have them installed. If your MIPS GCC
        is installed as /opt/mips/bin/mips-elf-gcc, then you should set
        this option to "/opt/mips/bin/mips-elf-". vmipstool looks for
        the "gcc", "ld", "objcopy" and "objdump" programs starting with
        this prefix. This option should be set in your installed
        system-wide VMIPS configuration file (vmipsrc) by the "configure"
        script; the compiled-in default is designed to cause an error. **/

    { "execname", STR },
    /** Name of executable to be loaded by automatic kernel loader. This
	is an experimental, unfinished feature. The option value
	must be the name of a MIPS ECOFF executable file, or 'none'
	to disable the option.  The executable's headers must specify
	load addresses in KSEG0 or KSEG1 (0x80000000 through
	0xbfffffff).  **/

    { "fpu", FLAG },
    /** True to enable hooks in the CPU to communicate with a
	floating-point unit as coprocessor 1. The floating-point unit
	is not implemented; only the hooks in the CPU are. This is an
	experimental, unfinished feature. **/

    { "testdev", FLAG },
    /** True to enable a memory-mapped device that is used to test
	the memory-mapped device interface. The VMIPS test suite turns
	this device on as necessary; you should not normally need
	to enable it. **/

    { NULL, 0 }
};

/* This is the official default options list. */
static const char *defaults_table[] = {
    "nohaltdumpcpu", "nohaltdumpcp0", "noexcpriomsg",
    "noexcmsg", "bootmsg", "noinstdump", "nodumpcpu", "nodumpcp0",
    "haltibe", "haltbreak", "haltdevice", "romfile=romfile.rom",
    "loadaddr=0xbfc00000", "noinstcounts",
    "memsize=0x100000", "nomemdump", "memdumpfile=memdump.bin",
    "noreportirq", "ttydev=/dev/tty", "ttydev2=off",
    "nodebug", "debugport=0", "norealtime", "timeratio=1", "clockspeed=250000",
    "clockintr=200000000", "clockdeviceirq=7", "clockdevice",
    "nodbemsg", "nodecrtc", "nodeccsr", "nodecstat", "nodecserial",
    "spimconsole", "notracing", "tracesize=100000", "nobigendian",
    "tracestartpc=0", "traceendpc=0",
    "mipstoolprefix=/nonexistent/mips/bin/mipsel-ecoff-",
    "execname=none", "nofpu", "notestdev",
    NULL
};

/* If you add or remove an option, or modify an option's default value,
 * you should update vmipsrc.in to match. */

#endif /* _OPTIONTBL_H_ */
