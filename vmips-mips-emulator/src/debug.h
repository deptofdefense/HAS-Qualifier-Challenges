/* Defintions to support the remote debugging interface.
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

#ifndef _DEBUG_H_
#define _DEBUG_H_

#include "deviceexc.h"
#include <set>
class CPU;
class Mapper;

class Debug : public DeviceExc {
private:
	CPU *cpu;
	Mapper *mem;
	int signo;
	int listener;
	long threadno_step;
	long threadno_gen;
	uint32 rom_baseaddr;
	uint32 rom_nwords;
	typedef std::set<uint32> wordset;
	wordset bp_set;
	bool opt_bigendian;
	bool debug_verbose;

public:
	Debug (CPU &c_, Mapper &m_);
	virtual ~Debug () { }
	bool got_interrupt;

	uint32 packet_pop_word(char **packet);
	uint8 packet_pop_byte(char **packet);

	int setup(uint32 baseaddr, uint32 nwords);
	int serverloop(void);
	void exception(uint16 excCode, int mode, int coprocno);

private:
	int setup_listener_socket(void);
	int set_nonblocking(int fd);
	void print_local_name(int s);
	void targetloop(void);
	char *rawpacket(const char *str);
	char *hexpacket(const char *str);
	char *error_packet(int error_code);
	char *signal_packet(int signal);
	char *target_query(char *pkt);
	char *target_kill(char *pkt);
	char *target_set_thread(char *pkt);
	char *target_poll_thread(char *pkt);
	char *target_read_registers(char *pkt);
	char *target_write_registers(char *pkt);
	char *target_read_memory(char *pkt);
	char *target_write_memory(char *pkt);
	uint8 single_step(void);
	char *target_continue(char *pkt);
	char *target_detach(char *pkt);
	char *target_step(char *pkt);
	char *target_last_signal(char *pkt);
	char *target_unimplemented(char *pkt);
	int exccode_to_signal(int exccode);
	/* Breakpoint support methods. */
	bool breakpoint_exists(uint32 addr);
	void declare_breakpoint(uint32 addr);
	void remove_breakpoint(uint32 addr);
	bool address_in_rom(uint32 addr);
	void get_breakpoint_bitmap_entry(uint32 addr, uint8 *&entry, uint8 &bitno);
	bool is_breakpoint_insn(char *packetptr);
	char *target_set_or_remove_breakpoint(char *pkt, bool setting);
};

#endif /* _DEBUG_H_ */
