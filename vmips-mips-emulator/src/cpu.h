/* Definitions and declarations to support the MIPS R3000 emulation.
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

#ifndef _CPU_H_
#define _CPU_H_

#include "deviceexc.h"
#include <cstdio>
#include <deque>
#include <map>
#include <vector>
class CPZero;
class FPU;
class Mapper;
class IntCtrl;

/* Exception priority information -- see exception_priority(). */
struct excPriority {
	int priority;
	int excCode;
	int mode;
};

struct last_change {
	uint32 pc;
	uint32 instr;
	uint32 old_value;
	last_change () { }
	last_change (uint32 pc_, uint32 instr_, uint32 old_value_) :
		pc(pc_), instr(instr_), old_value(old_value_) { }
	static last_change make (uint32 pc_, uint32 instr_, uint32 old_value_) {
		last_change rv (pc_, instr_, old_value_);
		return rv;
	}
};

class Trace {
public:
	struct Operand {
		const char *tag;
		int regno;
		uint32 val;
		Operand () : regno (-1) { }
		Operand (const char *tag_, int regno_, uint32 val_) :
			tag(tag_), regno(regno_), val(val_) { }
		static Operand make (const char *tag_, int regno_, uint32 val_) {
			Operand rv (tag_, regno_, val_);
			return rv;
		}
		Operand (const char *tag_, uint32 val_) :
			tag(tag_), regno(-1), val(val_) { }
		static Operand make (const char *tag_, uint32 val_) {
			Operand rv (tag_, val_);
			return rv;
		}
	};
	struct Record {
		typedef std::vector<Operand> OperandListType;
		OperandListType inputs;
		OperandListType outputs;
		uint32 pc;
		uint32 instr;
		uint32 saved_reg[32];
		void inputs_push_back_op (const char *tag, int regno, uint32 val) {
			inputs.push_back(Operand::make(tag, regno, val));
		}
		void inputs_push_back_op (const char *tag, uint32 val) {
			inputs.push_back(Operand::make(tag, val));
		}
		void outputs_push_back_op (const char *tag, int regno, uint32 val) {
			outputs.push_back(Operand::make(tag, regno, val));
		}
		void outputs_push_back_op (const char *tag, uint32 val) {
			outputs.push_back(Operand::make(tag, val));
		}
		void clear () { inputs.clear (); outputs.clear (); pc = 0; instr = 0; }
	};
	typedef std::deque<Record> RecordListType;
	typedef RecordListType::iterator record_iterator;
private:
	RecordListType records;
public:
	std::map <int, last_change> last_change_for_reg;
	record_iterator rbegin () { return records.begin (); }
	record_iterator rend () { return records.end (); }
	void clear () { records.clear (); last_change_for_reg.clear (); }
	size_t record_size () const { return records.size (); }
	void pop_front_record () { records.pop_front (); }
	void push_back_record (Trace::Record &r) { records.push_back (r); }
	bool exception_happened;
	int last_exception_code;
};

class CPU : public DeviceExc {
	// Tracing data.
	bool tracing;
	Trace current_trace;
	Trace::Record current_trace_record;
	FILE *traceout;

	// Tracing support methods.
	void open_trace_file ();
	void close_trace_file ();
	void start_tracing ();
	void write_trace_to_file ();
	void write_trace_instr_inputs (uint32 instr);
	void write_trace_instr_outputs (uint32 instr);
	void write_trace_record_1 (uint32 pc, uint32 instr);
	void write_trace_record_2 (uint32 pc, uint32 instr);
	void stop_tracing ();

	// Important registers:
	uint32 pc;      // Program counter
	uint32 reg[32]; // General-purpose registers
	uint32 instr;   // The current instruction
	uint32 hi, lo;  // Division and multiplication results

	// Exception bookkeeping data.
	uint32 last_epc;
	int last_prio;
	uint32 next_epc;

	// Other components of the VMIPS machine.
	Mapper *mem;
	CPZero *cpzero;
	FPU *fpu;

	// Delay slot handling.
	int delay_state;
	uint32 delay_pc;

	// Cached option values that we use in the CPU core.
	bool opt_fpu;
	bool opt_excmsg;
	bool opt_reportirq;
	bool opt_excpriomsg;
	bool opt_haltbreak;
	bool opt_haltibe;
	bool opt_haltjrra;
	bool opt_instdump;
	bool opt_tracing;
	uint32 opt_tracesize;
	uint32 opt_tracestartpc;
	uint32 opt_traceendpc;
	bool opt_bigendian; // True if CPU in big endian mode.

	// Miscellaneous shared code. 
	void control_transfer(uint32 new_pc);
	void jump(uint32 instr, uint32 pc);
	uint32 calc_jump_target(uint32 instr, uint32 pc);
	uint32 calc_branch_target(uint32 instr, uint32 pc);
	void mult64(uint32 *hi, uint32 *lo, uint32 n, uint32 m);
	void mult64s(uint32 *hi, uint32 *lo, int32 n, int32 m);
	void cop_unimpl (int coprocno, uint32 instr, uint32 pc);

	// Unaligned load/store support.
	uint32 lwr(uint32 regval, uint32 memval, uint8 offset);
	uint32 lwl(uint32 regval, uint32 memval, uint8 offset);
	uint32 swl(uint32 regval, uint32 memval, uint8 offset);
	uint32 swr(uint32 regval, uint32 memval, uint8 offset);

	// Emulation of specific instructions.
	void funct_emulate(uint32 instr, uint32 pc);
	void regimm_emulate(uint32 instr, uint32 pc);
	void j_emulate(uint32 instr, uint32 pc);
	void jal_emulate(uint32 instr, uint32 pc);
	void beq_emulate(uint32 instr, uint32 pc);
	void bne_emulate(uint32 instr, uint32 pc);
	void blez_emulate(uint32 instr, uint32 pc);
	void bgtz_emulate(uint32 instr, uint32 pc);
	void addi_emulate(uint32 instr, uint32 pc);
	void addiu_emulate(uint32 instr, uint32 pc);
	void slti_emulate(uint32 instr, uint32 pc);
	void sltiu_emulate(uint32 instr, uint32 pc);
	void andi_emulate(uint32 instr, uint32 pc);
	void ori_emulate(uint32 instr, uint32 pc);
	void xori_emulate(uint32 instr, uint32 pc);
	void lui_emulate(uint32 instr, uint32 pc);
	void cpzero_emulate(uint32 instr, uint32 pc);
	void cpone_emulate(uint32 instr, uint32 pc);
	void cptwo_emulate(uint32 instr, uint32 pc);
	void cpthree_emulate(uint32 instr, uint32 pc);
	void lb_emulate(uint32 instr, uint32 pc);
	void lh_emulate(uint32 instr, uint32 pc);
	void lwl_emulate(uint32 instr, uint32 pc);
	void lw_emulate(uint32 instr, uint32 pc);
	void lbu_emulate(uint32 instr, uint32 pc);
	void lhu_emulate(uint32 instr, uint32 pc);
	void lwr_emulate(uint32 instr, uint32 pc);
	void sb_emulate(uint32 instr, uint32 pc);
	void sh_emulate(uint32 instr, uint32 pc);
	void swl_emulate(uint32 instr, uint32 pc);
	void sw_emulate(uint32 instr, uint32 pc);
	void swr_emulate(uint32 instr, uint32 pc);
	void lwc1_emulate(uint32 instr, uint32 pc);
	void lwc2_emulate(uint32 instr, uint32 pc);
	void lwc3_emulate(uint32 instr, uint32 pc);
	void swc1_emulate(uint32 instr, uint32 pc);
	void swc2_emulate(uint32 instr, uint32 pc);
	void swc3_emulate(uint32 instr, uint32 pc);
	void sll_emulate(uint32 instr, uint32 pc);
	void srl_emulate(uint32 instr, uint32 pc);
	void sra_emulate(uint32 instr, uint32 pc);
	void sllv_emulate(uint32 instr, uint32 pc);
	void srlv_emulate(uint32 instr, uint32 pc);
	void srav_emulate(uint32 instr, uint32 pc);
	void jr_emulate(uint32 instr, uint32 pc);
	void jalr_emulate(uint32 instr, uint32 pc);
	void syscall_emulate(uint32 instr, uint32 pc);
	void break_emulate(uint32 instr, uint32 pc);
	void mfhi_emulate(uint32 instr, uint32 pc);
	void mthi_emulate(uint32 instr, uint32 pc);
	void mflo_emulate(uint32 instr, uint32 pc);
	void mtlo_emulate(uint32 instr, uint32 pc);
	void mult_emulate(uint32 instr, uint32 pc);
	void multu_emulate(uint32 instr, uint32 pc);
	void div_emulate(uint32 instr, uint32 pc);
	void divu_emulate(uint32 instr, uint32 pc);
	void add_emulate(uint32 instr, uint32 pc);
	void addu_emulate(uint32 instr, uint32 pc);
	void sub_emulate(uint32 instr, uint32 pc);
	void subu_emulate(uint32 instr, uint32 pc);
	void and_emulate(uint32 instr, uint32 pc);
	void or_emulate(uint32 instr, uint32 pc);
	void xor_emulate(uint32 instr, uint32 pc);
	void nor_emulate(uint32 instr, uint32 pc);
	void slt_emulate(uint32 instr, uint32 pc);
	void sltu_emulate(uint32 instr, uint32 pc);
	void bltz_emulate(uint32 instr, uint32 pc);
	void bgez_emulate(uint32 instr, uint32 pc);
	void bltzal_emulate(uint32 instr, uint32 pc);
	void bgezal_emulate(uint32 instr, uint32 pc);
	void RI_emulate(uint32 instr, uint32 pc);

	// Exception prioritization.
	int exception_priority(uint16 excCode, int mode) const;

public:
	// Instruction decoding.
	static uint16 opcode(const uint32 i) { return (i >> 26) & 0x03f; }
	static uint16 rs(const uint32 i) { return (i >> 21) & 0x01f; }
	static uint16 rt(const uint32 i) { return (i >> 16) & 0x01f; }
	static uint16 rd(const uint32 i) { return (i >> 11) & 0x01f; }
	static uint16 immed(const uint32 i) { return i & 0x0ffff; }
	static short s_immed(const uint32 i) { return i & 0x0ffff; }
	static uint16 shamt(const uint32 i) { return (i >> 6) & 0x01f; }
	static uint16 funct(const uint32 i) { return i & 0x03f; }
	static uint32 jumptarg(const uint32 i) { return i & 0x03ffffff; }

	// Constructor & destructor.
	CPU (Mapper &m, IntCtrl &i);
	virtual ~CPU ();

	// For printing out the register file, stack, CP0 registers, and TLB
	// per user request.
	void dump_regs (FILE *f);
	void dump_stack (FILE *f);
	void dump_mem (FILE *f, uint32 addr);
	void dis_mem (FILE *f, uint32 addr);
	void cpzero_dump_regs_and_tlb (FILE *f);

	// Register file accessors.
	uint32 get_reg (const unsigned regno) { return reg[regno]; }
	void put_reg (const unsigned regno, const uint32 new_data) {    
		reg[regno] = new_data;  
	}

	// Control-flow methods.
	void step ();
	void reset ();

	// Methods which are only for use by the CPU and its coprocessors.
	void branch (uint32 instr, uint32 pc);
	void exception (uint16 excCode, int mode = ANY, int coprocno = -1);

	// Public tracing support method.
	void flush_trace ();

	// Debugger interface support methods.
	char *debug_registers_to_packet ();
	void debug_packet_to_registers (char *packet);
	uint8 pending_exception ();
	uint32 debug_get_pc ();
	void debug_set_pc (uint32 newpc);
	void debug_packet_push_word (char *packet, uint32 n);
	void debug_packet_push_byte (char *packet, uint8 n);
	int debug_fetch_region (uint32 addr, uint32 len, char *packet,
		DeviceExc *client);
	int debug_store_region (uint32 addr, uint32 len, char *packet,
		DeviceExc *client);

	bool is_bigendian() const { return opt_bigendian; }
};

#endif /* _CPU_H_ */
