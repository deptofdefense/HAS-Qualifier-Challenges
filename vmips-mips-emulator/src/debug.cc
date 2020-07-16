/* Interface to an external GNU debugger over TCP/IP.
   Copyright 2001, 2003 Brian R. Gaeke.

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

#include "debug.h"
#include "remotegdb.h"
#include "cpu.h"
#include "mapper.h"
#include "excnames.h"
#include "cpzeroreg.h"
#include "vmips.h"
#include "options.h"
#include <csignal>
#include <cstring>
#include <cstdlib>
#include <cerrno>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>

extern int remotegdb_backend_error;

Debug::Debug (CPU &cpu_, Mapper &mem_)
  : cpu (&cpu_), mem (&mem_), listener (-1), threadno_step (-1),
    threadno_gen (-1), rom_baseaddr (0), rom_nwords (0), got_interrupt (false),
    debug_verbose (false) {
	/* Upon connecting to our socket, gdb will ask for the current
	 * signal; so we set the current signal to the breakpoint signal.
	 */
	signo = exccode_to_signal(Bp);
	opt_bigendian = machine->opt->option("bigendian")->flag;
}

void
Debug::exception(uint16 excCode, int mode, int coprocno)
{
	/* Set the exception_pending flag so that target commands (or
	 * their subroutines) can catch errors and pass them back to GDB.
	 */
	exception_pending = true;
}

void
debugger_interrupt (int sig)
{
	machine->dbgr->got_interrupt = true;
}

int
Debug::setup(uint32 baseaddr, uint32 nwords)
{
	rom_baseaddr = baseaddr;
	rom_nwords = nwords;

	/* Set up a TCP/IP socket to listen for a debugger connection. */
	listener = setup_listener_socket();
	if (listener >= 0) {
		/* Print out where we bound to. */
		print_local_name(listener);
	} else {
		return -1;
	}

	struct sigaction sa;
	sa.sa_handler = debugger_interrupt;
	sa.sa_flags = 0;
	sigemptyset(&sa.sa_mask);

	if (sigaction(SIGINT, &sa, NULL) < 0) {
		perror ("sigaction");
		return -1;
	}
	return 0;
}

/* True if a breakpoint has been set for the instruction given in ADDR,
 * and false otherwise.
 */
bool
Debug::breakpoint_exists(uint32 addr)
{
	return (bp_set.find (addr) != bp_set.end ());
}

/* Set a breakpoint for the instruction given in ADDR. */
void
Debug::declare_breakpoint(uint32 addr)
{
	bp_set.insert (addr);
}

/* Unset a breakpoint for the instruction given in ADDR. */
void
Debug::remove_breakpoint(uint32 addr)
{
	wordset::iterator i = bp_set.find (addr);
	if (i != bp_set.end ()) {
		bp_set.erase (i);
	}
}

/* True if ADDR is a virtual address within a known ROM block. This is pretty
 * lame right now; we should really ask the Mapper.
 */
bool
Debug::address_in_rom(uint32 addr)
{
	return !((addr < rom_baseaddr) || (addr > (rom_baseaddr + 4*rom_nwords)));
}

/* Instructions that gdb uses to set breakpoints.
 * These are taken from gdb/mips-tdep.c, without modification.
 */
#define BIG_BREAKPOINT {0, 0x5, 0, 0xd}
#define LITTLE_BREAKPOINT {0xd, 0, 0x5, 0}

/* Determine whether the packet pointer passed in points to a (serial-encoded)
 * GDB break instruction, and return true if this is the case.
 */
bool
Debug::is_breakpoint_insn(char *packetptr)
{
	int posn = 0;
	char big_break_insn[] = BIG_BREAKPOINT;
	char little_break_insn[] = LITTLE_BREAKPOINT;
	char *break_insn;
	int bytes;

	if (opt_bigendian) {
		break_insn = big_break_insn;
		bytes = sizeof (big_break_insn);
	} else /* if MIPS target is little endian */ {
		break_insn = little_break_insn;
		bytes = sizeof (little_break_insn);
	}
	while (--bytes) {
		if (packet_pop_byte(&packetptr) != break_insn[posn++]) 
			return false;
	}
	return true;
}

uint32
Debug::packet_pop_word(char **packet)
{
	char valstr[10];
	char *q, *p;
	int i;
	uint32 val;

	p = *packet;
	q = valstr;
	for (i = 0; i < 8; i++) {
		*q++ = *p++;
	}
	*q++ = '\0';
	val = strtoul(valstr, NULL, 16);
	if (!opt_bigendian)
		val = machine->physmem->swap_word(val);
	*packet = p;
	return val;
}

uint8
Debug::packet_pop_byte(char **packet)
{
	char valstr[4];
	char *q, *p;
	int i;
	uint8 val;

	p = *packet;
	q = valstr;
	for (i = 0; i < 2; i++) {
		*q++ = *p++;
	}
	*q++ = '\0';
	val = (uint8) strtoul(valstr, NULL, 16);
	*packet = p;
	return val;
}

int
Debug::setup_listener_socket(void)
{
	int sock;
	struct sockaddr_in addr;
	int value;
	unsigned int port;

	sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (sock < 0) {
		perror("socket");
		return -1;
	}
	memset(&addr, 0, sizeof(struct sockaddr_in));
	addr.sin_family = AF_INET;
	port = machine->opt->option("debugport")->num;
	addr.sin_port = htons(port);
	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
	value = 1;
	if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &value,
		sizeof(value)) < 0) {
		perror("setsockopt SO_REUSEADDR");
		return -1;
	}
	if (bind(sock, (struct sockaddr *) &addr, sizeof(addr)) < 0) {
		perror("bind");
		fprintf(stderr, "Failed bind addr: %s\n",
			inet_ntoa(addr.sin_addr));
		return -1;
	}
	if (listen(sock, 1) < 0) {
		perror("listen");
		return -1;
	}
	return sock;
}

int
Debug::set_nonblocking(int fd)
{
	if (fcntl(fd, F_SETFL, O_NONBLOCK) < 0) {
		perror("fcntl: set O_NONBLOCK");
		return -1;
	}
	return 0;
}

void
Debug::print_local_name(int s)
{
	struct sockaddr_in addr;
	socklen_t addrlen = sizeof(addr);

	if (getsockname(s, (struct sockaddr *) &addr, &addrlen) < 0) {
		perror("getsockname");
		return;
	}
	fprintf(stderr,
		"Use this command to attach debugger: target remote %s:%u\n",
		inet_ntoa(addr.sin_addr),
		ntohs(addr.sin_port));
}

int
Debug::serverloop(void)
{
	int clientno = 0;
	struct sockaddr_in clientaddr;
	int clientsock;
	socklen_t clientaddrlen = sizeof(clientaddr);
	extern int remote_desc;

	while (! machine->halted()) {
		/* Block until a connection is received */
		fprintf(stderr, "Waiting for connection from debugger.\n");
		clientsock = accept(listener, (struct sockaddr *) &clientaddr,
			&clientaddrlen);
		if (clientsock < 0) {
			perror ("accept");
			if (errno == EINTR) {
			    /* Maybe the user attempted a ^C. */
			    machine->halt();
			}
			return clientsock;
		}

		fprintf(stderr, "Debugger connected.\n");

		/* Set the client socket nonblocking */
		set_nonblocking(clientsock);

		remote_desc = clientsock;

		targetloop();

		/* We halt if the targetloop returned because of a remotegdb
		 * error.
		 */
		if (remotegdb_backend_error) {
		    remotegdb_backend_error = 0;
		    machine->halt();
		}

		close(clientsock);
		clientno++;
	}
	close(listener);
	return 0;
}

void
Debug::targetloop(void)
{
	int packetno = 0;
	char buf[PBUFSIZ];
	char *result = NULL;

	while (! machine->halted()) {
		exception_pending = false;
		/* Wait for a packet, and when we get it, store it in
		 * BUF. If we get an error trying to receive a packet,
		 * give up.
		 */
		getpkt(buf, 1); if (remotegdb_backend_error) return;
		if (debug_verbose) {
			fprintf(stderr, "<==(%03d) \"%s\"\n", packetno, buf);
		}
		switch(buf[0]) {
			case 'g': result = target_read_registers(buf); break;
			case 'G': result = target_write_registers(buf); break;
			case 'm': result = target_read_memory(buf); break;
			case 'M': result = target_write_memory(buf); break;
			case 'c': result = target_continue(buf); break;
			case 'D': result = target_detach(buf); break;
			case 's': result = target_step(buf); break;
			case 'k': result = target_kill(buf); break;
			case 'H': result = target_set_thread(buf); break;
			case 'T': result = target_poll_thread(buf); break;
			case '?': result = target_last_signal(buf); break;
			case 'Z': result = target_set_or_remove_breakpoint(buf, true); break;
			case 'z': result = target_set_or_remove_breakpoint(buf, false); break;
			case 'q': result = target_query(buf); break;
			default:  result = target_unimplemented(buf); break;
		}
		if (debug_verbose) {
			fprintf(stderr, "==>(%03d) \"%s\"\n", packetno, result);
		}
		packetno++;
		putpkt(result); if (remotegdb_backend_error) return;
		free(result);
	}
	return;
}

char *
Debug::target_query(char *pkt)
{
	/* Implement just enough of the query packets to make it look like
	 * we have exactly one thread, with an ID of 1, called "Simulated 
	 * Thread".
	 */
	++pkt;
	if (strcmp(pkt, "C")==0) {
		return rawpacket("QC 1");
	} else if (strcmp(pkt, "fThreadInfo")==0) {
		return rawpacket("m 1");
	} else if (strcmp(pkt, "sThreadInfo")==0) {
		return rawpacket("l");
	} else if (strcmp(pkt, "ThreadExtraInfo,1")==0) {
		return hexpacket("Simulated Thread");
	} else {
		return rawpacket("");
	}
}

char *
Debug::target_kill(char *pkt)
{
	/* This is a request from GDB to kill the process being
	 * debugged. We interpret it as a request to halt the machine.
	 */
	machine->halt();
	return rawpacket("OK");
}

char *
Debug::target_set_thread(char *pkt)
{
	int thread_for_step = (pkt[1] == 'c');
	long threadno;

	threadno = strtol(&pkt[2], NULL, 0);
	/* This is a request from GDB to change threads. We don't really
	 * have anything to do here, but it needs to be handled without an
	 * error for things to work.  If THREAD_FOR_STEP is true, this is
	 * used to control step and continue operations. Otherwise, it is
	 * used to control general operations.
	 */
	if ((threadno < -1) || (threadno > 1)) {
	    	/* We only have one actual thread, and its number is one.
		 * Besides that, the any-thread (0) or all-thread (-1)
		 * designators are ok.
		 */
	    	return error_packet(1);
	}
	if (thread_for_step) {
		threadno_step = threadno;
	} else {
		threadno_gen = threadno;
	}
	return rawpacket("OK");
}

char *
Debug::target_poll_thread(char *pkt)
{
	long threadno = strtol(&pkt[1], NULL, 16);
	/* This is a request from GDB to check whether a thread is alive. */
	if (threadno != 1) {
	    	/* We only have one thread, and its number is one. */
	    	return error_packet(1);
	}
	return rawpacket("OK");
}

char *
Debug::target_read_registers(char *pkt)
{
	return cpu->debug_registers_to_packet();
}

char *
Debug::hexpacket(const char *str)
{
	int len = strlen(str);
	char *packet = new char[2 * len + 3];
	for (int i = 0; i <= len; ++i) {
	    	char c = str[i];
		packet[2*i + 0] = tohex((c>>4) & 0xf);
		packet[2*i + 1] = tohex((c>>0) & 0xf);
	}
	packet[2*len + 2] = '\0';
	return packet;
}

char *
Debug::rawpacket(const char *str)
{
	char *packet = new char[1 + strlen(str)];
	strcpy(packet, str);
	return packet;
}

char * 
Debug::target_write_registers(char *pkt)
{
	cpu->debug_packet_to_registers(&pkt[1]);
	return rawpacket("OK");
}

char *
Debug::error_packet(int error_code)
{
	char str[10];
	sprintf(str, "E%02x", error_code);
	return rawpacket(str);
}

char *
Debug::signal_packet(int signal)
{
	char str[10];
	sprintf(str, "S%02x", signal);
	return rawpacket(str);
}

char * 
Debug::target_read_memory(char *pkt)
{
	char *addrstr = &pkt[1];
	char *lenstr = strchr(pkt, ',');
	uint32 addr, len;
	char *packet;

	if (! lenstr) {
		/* This read memory request is malformed, because it
		 * does not contain a comma. Send back an error.
		 */
		return error_packet(1);
	}
	lenstr[0] = 0;
	lenstr++;

	addr = strtoul(addrstr, NULL, 16);
	len = strtoul(lenstr, NULL, 16);

	/* Read memory starting from ADDR w/ length LEN and return
	 * it in a packet.
	 */
	packet = new char[2 * len + 1];
	packet[0] = '\0';
	
	if (cpu->debug_fetch_region(addr, len, packet, this) < 0) {
		/* There was an error fetching memory. We could try to
		 * return a real error code, but GDB will just ignore it
		 * anyway.
		 */
		delete [] packet;
		return error_packet(1);
	} else {
		return packet;
	}
}

char * 
Debug::target_write_memory(char *pkt)
{
	char *addrstr = &pkt[1];
	char *lenstr = strchr(pkt, ',');
	char *datastr = strchr(pkt, ':');
	uint32 addr, len;
	if (! lenstr) {
		/* This write-memory request is malformed, because the comma is
		 * missing.  Send back an error packet. */
		return error_packet(1);
	}
	lenstr[0] = 0;
	lenstr++;
	if (! datastr) {
		/* This write-memory request is malformed, because the colon is
		 * missing.  Send back an error packet. */
		return error_packet(1);
	}
	datastr[0] = 0;
	datastr++;
	/* At this point we have found all the arguments: the address, the
	 * length of data, and the data itself. We must translate the first
	 * two into integers, and then do some special handling for ROM
	 * breakpoint support.
	 */
	addr = strtoul(addrstr, NULL, 16);
	len = strtoul(lenstr, NULL, 16);

	if ((len == 4) && address_in_rom(addr) && is_breakpoint_insn(datastr)) {
		/* If attempting to write a word to ROM which is a breakpoint
		 * instruction, assume GDB is trying to set a breakpoint. 
		 */
		declare_breakpoint(addr);
	} else if ((len == 4) && address_in_rom(addr) &&
	           breakpoint_exists(addr) && !is_breakpoint_insn(datastr)) {
		/* If attempting to write a word to ROM which is not a
		 * breakpoint instruction, and GDB previously set a breakpoint
		 * there, assume GDB is trying to clear a breakpoint.
		 */
		remove_breakpoint(addr);
	} else {
		if (cpu->debug_store_region(addr, len, datastr, this) < 0) {
			return error_packet(1);
		}
	}
	return rawpacket("OK");
}

uint8
Debug::single_step(void)
{
	if (breakpoint_exists(cpu->debug_get_pc())) {
		return Bp; /* Simulate hitting the breakpoint. */
	}
	if (got_interrupt == true) {
		return Bp; /* interrupt. */
	}
	machine->step();
	return cpu->pending_exception();
}

char * 
Debug::target_continue(char *pkt)
{
	char *addrstr = &pkt[1];
	uint32 addr;
	int exccode;

	if (addrstr[0] != '\0') {
		/* The user specified an address to continue from. Continue from the
		 * address given in ADDRSTR by fiddling with the CPU's PC.
		 */
		addr = strtoul(addrstr, NULL, 16);
		cpu->debug_set_pc(addr);
	}
	do {
		exccode = single_step();
		if (machine->halted()) {
			/* Something happened to terminate execution. 
			 * Tell GDB that the program exited.
			 */
			return rawpacket("W00");
		} else if (got_interrupt && (exccode == Bp)) {
			got_interrupt = false;
			return signal_packet (exccode_to_signal (Bp));
		} else if (exccode != 0) {
			signo = exccode_to_signal (exccode);
			return signal_packet(signo);
		}
	} while (true);
}

char * 
Debug::target_detach(char *pkt)
{
	return rawpacket("OK");
}

char * 
Debug::target_step(char *pkt)
{
	char *addrstr = &pkt[1];
	uint32 addr;
	int exccode;

	if (! addrstr[0]) {
		/* fprintf(stderr, "STUB: step from last addr\n"); */
	} else {
		/* fprintf(stderr, "STUB: step from addr=%s\n", addrstr); */
		addr = strtoul(addrstr, NULL, 16);
		cpu->debug_set_pc(addr);
	}
	if ((exccode = single_step()) != 0) {
		signo = exccode_to_signal(exccode);
	}
	return signal_packet(signo);
}

char * 
Debug::target_last_signal(char *pkt)
{
	return signal_packet(signo);
}

char * 
Debug::target_set_or_remove_breakpoint(char *pkt, bool setting)
{
	char *typestr = &pkt[1];
	char *addrstr = strchr (pkt, ',');
	char *lenstr;
	uint32 type, addr, len;
	if (!addrstr) {
		/* Requests must specify address in hex after first comma. */
		return error_packet(1);
	}
	*addrstr++ = '\0';
	lenstr = strchr (addrstr, ',');
	if (!lenstr) {
		/* Requests must specify length in hex after second comma. */
		return error_packet(1);
	}
	*lenstr++ = '\0';
	type = strtoul(typestr, NULL, 10);
	addr = strtoul(addrstr, NULL, 16);
	len = strtoul(lenstr, NULL, 16);
	switch (type) {
	case 0: /* software breakpoint */
	case 1: /* hardware breakpoint */
		if (setting) {
			declare_breakpoint (addr);
		} else {
			remove_breakpoint (addr);
		}
		return rawpacket("OK");
	case 2: /* write watchpoint */
	case 3: /* read watchpoint */
	case 4: /* access watchpoint */
	default:
		return rawpacket(""); /* Not supported. */
	}
}

char * 
Debug::target_unimplemented(char *pkt)
{
	/* fprintf(stderr, "STUB: unimplemented request [%s]\n", pkt); */
	return rawpacket("");
}

/* Translates between MIPS exception codes and Unix signals (which GDB
 * likes better.)
 */
int
Debug::exccode_to_signal(int exccode)
{
	const int signos[] = { 2,  /* Int -> SIGINT */
	 11, 11, 11, 11, 11,       /* Mod, TLBL, TLBS, AdEL, AdES -> SIGSEGV */
	 7, 7,                     /* IBE, DBE -> SIGBUS */
	 5, 5,                     /* Sys, Bp -> SIGTRAP */
	 4,                        /* RI -> SIGILL */
	 8, 8 };                   /* CpU, OV -> SIGFPE */
	const int defaultsig = 1;  /* others -> SIGHUP */
  
	if (exccode < Int || exccode > Ov) {
		return defaultsig; /* SIGHUP */
	} else {
		return signos[exccode];
	}
}
