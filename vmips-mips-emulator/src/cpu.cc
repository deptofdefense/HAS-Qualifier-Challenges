/* MIPS R3000 CPU emulation.
   Copyright 2001, 2002, 2003, 2004 Brian R. Gaeke.

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

#include <string.h>
#include "cpu.h"
#include "cpzero.h"
#include "debug.h"
#include "fpu.h"
#include "mapper.h"
#include "vmips.h"
#include "options.h"
#include "excnames.h"
#include "cpzeroreg.h"
#include "error.h"
#include "remotegdb.h"
#include "fileutils.h"
#include "stub-dis.h"
#include <cstring>

/* states of the delay-slot state machine -- see CPU::step() */
static const int NORMAL = 0, DELAYING = 1, DELAYSLOT = 2;

/* certain fixed register numbers which are handy to know */
static const int reg_zero = 0;  /* always zero */
static const int reg_sp = 29;   /* stack pointer */
static const int reg_ra = 31;   /* return address */

/* pointer to CPU method returning void and taking two uint32's */
typedef void (CPU::*emulate_funptr)(uint32, uint32);

static const char *strdelaystate(const int state) {
	static const char *const statestr[] = {
		"NORMAL", "DELAYING", "DELAYSLOT"
	};
	return statestr[state];
}

CPU::CPU (Mapper &m, IntCtrl &i)
  : tracing (false), last_epc (0), last_prio (0), mem (&m),
    cpzero (new CPZero (this, &i)), fpu (0), delay_state (NORMAL)
{
	opt_fpu = machine->opt->option("fpu")->flag;
	if (opt_fpu)
		fpu = new FPU (this);
	reg[reg_zero] = 0;
	opt_excmsg = machine->opt->option("excmsg")->flag;
	opt_reportirq = machine->opt->option("reportirq")->flag;
	opt_excpriomsg = machine->opt->option("excpriomsg")->flag;
	opt_haltbreak = machine->opt->option("haltbreak")->flag,
	opt_haltibe = machine->opt->option("haltibe")->flag;
	opt_instdump = machine->opt->option("instdump")->flag;
	opt_tracing = machine->opt->option("tracing")->flag;
	opt_tracesize = machine->opt->option("tracesize")->num;
	opt_tracestartpc = machine->opt->option("tracestartpc")->num;
	opt_traceendpc = machine->opt->option("traceendpc")->num;
	opt_bigendian = machine->opt->option("bigendian")->flag;
	if (opt_tracing)
		open_trace_file ();
}

CPU::~CPU ()
{
	if (opt_tracing)
		close_trace_file ();
}

void
CPU::reset(void)
{
#ifdef INTENTIONAL_CONFUSION
	int r;
	for (r = 0; r < 32; r++) {
		reg[r] = random();
	}
#endif /* INTENTIONAL_CONFUSION */
	reg[reg_zero] = 0;
	pc = 0xbfc00000;
	cpzero->reset();
}

void
CPU::dump_regs(FILE *f)
{
	int i;

	fprintf(f,"Reg Dump: [ PC=%08x  LastInstr=%08x  HI=%08x  LO=%08x\n",
		pc,instr,hi,lo);
	fprintf(f,"            DelayState=%s  DelayPC=%08x  NextEPC=%08x\n",
		strdelaystate(delay_state), delay_pc, next_epc);
	for (i = 0; i < 32; i++) {
		fprintf(f," R%02d=%08x ",i,reg[i]);
		if (i % 5 == 4) {
			fputc('\n',f);
		} else if (i == 31) {
			fprintf(f, " ]\n");
		}
	}
}

void
CPU::dump_stack(FILE *f)
{
	uint32 stackphys;
	if (cpzero->debug_tlb_translate(reg[reg_sp], &stackphys)) {
		mem->dump_stack(f, stackphys);
	} else {
		fprintf(f, "Stack: (not mapped in TLB)\n");
	}
}

void
CPU::dump_mem(FILE *f, uint32 addr)
{
	uint32 phys;
        fprintf(f, "0x%08x: ", addr);
	if (cpzero->debug_tlb_translate(addr, &phys)) {
		mem->dump_mem(f, phys);
	} else {
		fprintf(f, "(not mapped in TLB)");
	}
	fprintf(f, "\n");
}

/* Disassemble a word at addr and print the result to f.
 * FIXME: currently, f must be stderr, for the disassembler.
 */
void
CPU::dis_mem(FILE *f, uint32 addr)
{
	uint32 phys;
	uint32 instr;
	if (cpzero->debug_tlb_translate(addr, &phys)) {
		fprintf(f,"PC=0x%08x [%08x]      %s",addr,phys,(addr==pc?"=>":"  "));
		instr = mem->fetch_word(phys,INSTFETCH,false, this);
		fprintf(f,"%08x ",instr);
		machine->disasm->disassemble(addr,instr);
	} else {
		fprintf(f,"PC=0x%08x [%08x]      %s",addr,phys,(addr==pc?"=>":"  "));
		fprintf(f, "(not mapped in TLB)\n");
	}
}

void
CPU::cpzero_dump_regs_and_tlb(FILE *f)
{
	cpzero->dump_regs_and_tlb(f);
}

/* exception handling */
static const char *strexccode(const uint16 excCode) {
	static const char *const exception_strs[] =
	{
		/* 0 */ "Interrupt",
		/* 1 */ "TLB modification exception",
		/* 2 */ "TLB exception (load or instr fetch)",
		/* 3 */ "TLB exception (store)",
		/* 4 */ "Address error exception (load or instr fetch)",
		/* 5 */ "Address error exception (store)",
		/* 6 */ "Instruction bus error",
		/* 7 */ "Data (load or store) bus error",
		/* 8 */ "SYSCALL exception",
		/* 9 */ "Breakpoint32 exception (BREAK instr)",
		/* 10 */ "Reserved instr exception",
		/* 11 */ "Coprocessor Unusable",
		/* 12 */ "Arithmetic Overflow",
		/* 13 */ "Trap (R4k/R6k only)",
		/* 14 */ "LDCz or SDCz to uncached address (R6k)",
		/* 14 */ "Virtual Coherency Exception (instr) (R4k)",
		/* 15 */ "Machine check exception (R6k)",
		/* 15 */ "Floating-point32 exception (R4k)",
		/* 16 */ "Exception 16 (reserved)",
		/* 17 */ "Exception 17 (reserved)",
		/* 18 */ "Exception 18 (reserved)",
		/* 19 */ "Exception 19 (reserved)",
		/* 20 */ "Exception 20 (reserved)",
		/* 21 */ "Exception 21 (reserved)",
		/* 22 */ "Exception 22 (reserved)",
		/* 23 */ "Reference to WatchHi/WatchLo address detected (R4k)",
		/* 24 */ "Exception 24 (reserved)",
		/* 25 */ "Exception 25 (reserved)",
		/* 26 */ "Exception 26 (reserved)",
		/* 27 */ "Exception 27 (reserved)",
		/* 28 */ "Exception 28 (reserved)",
		/* 29 */ "Exception 29 (reserved)",
		/* 30 */ "Exception 30 (reserved)",
		/* 31 */ "Virtual Coherency Exception (data) (R4k)"
	};

	return exception_strs[excCode];
}

static const char *strmemmode(const int memmode) {
	static const char *const memmode_strs[] =
	{
		"instruction fetch", /* INSTFETCH */
		"data load", /* DATALOAD */
		"data store", /* DATASTORE */
		"not applicable" /* ANY */
	};

	return memmode_strs[memmode];
}

int
CPU::exception_priority(uint16 excCode, int mode) const
{
	/* See doc/excprio for an explanation of this table. */
	static const struct excPriority prio[] = {
		{1, AdEL, INSTFETCH},
		{2, TLBL, INSTFETCH}, {2, TLBS, INSTFETCH},
		{3, IBE, ANY},
		{4, Ov, ANY}, {4, Tr, ANY}, {4, Sys, ANY},
		{4, Bp, ANY}, {4, RI, ANY}, {4, CpU, ANY},
		{5, AdEL, DATALOAD}, {5, AdES, ANY},
		{6, TLBL, DATALOAD}, {6, TLBS, DATALOAD},
		{6, TLBL, DATASTORE}, {6, TLBS, DATASTORE},
		{7, Mod, ANY},
		{8, DBE, ANY},
		{9, Int, ANY},
		{0, ANY, ANY} /* catch-all */
	};
	const struct excPriority *p;

	for (p = prio; p->priority != 0; p++) {
		if (excCode == p->excCode || p->excCode == ANY) {
			if (mode == p->mode || p->mode == ANY) {
				return p->priority;
			} else if (opt_excpriomsg) {
				fprintf(stderr,
					"exception code matches but mode %d != table %d\n",
					mode,p->mode);
			}
		} else if (opt_excpriomsg) {
			fprintf(stderr, "exception code %d != table %d\n", excCode,
				p->excCode);
		}
	}
	return 0;
}

void
CPU::exception(uint16 excCode, int mode /* = ANY */, int coprocno /* = -1 */)
{
	int prio;
	uint32 base, vector, epc;
	bool delaying = (delay_state == DELAYSLOT);

	if (opt_haltbreak) {
		if (excCode == Bp) {
			fprintf(stderr,"* BREAK instruction reached -- HALTING *\n");
			machine->halt();
		}
	}
	if (opt_haltibe) {
		if (excCode == IBE) {
			fprintf(stderr,"* Instruction bus error occurred -- HALTING *\n");
			machine->halt();
		}
	}

	/* step() ensures that next_epc will always contain the correct
	 * EPC whenever exception() is called.
	 */
	epc = next_epc;

	/* Prioritize exception -- if the last exception to occur _also_ was
	 * caused by this EPC, only report this exception if it has a higher
	 * priority.  Otherwise, exception handling terminates here,
	 * because only one exception will be reported per instruction
	 * (as per MIPS RISC Architecture, p. 6-35). Note that this only
	 * applies IFF the previous exception was caught during the current
	 * _execution_ of the instruction at this EPC, so we check that
	 * EXCEPTION_PENDING is true before aborting exception handling.
	 * (This flag is reset by each call to step().)
	 */
	prio = exception_priority(excCode, mode);
	if (epc == last_epc) {
		if (prio <= last_prio && exception_pending) {
			if (opt_excpriomsg) {
				fprintf(stderr,
					"(Ignoring additional lower priority exception...)\n");
			}
			return;
		} else {
			last_prio = prio;
		}
	}
	last_epc = epc;

	/* Set processor to Kernel mode, disable interrupts, and save 
	 * exception PC.
	 */
	cpzero->enter_exception(epc,excCode,coprocno,delaying);

	/* Calculate the exception handler address; this is of the form BASE +
	 * VECTOR. The BASE is determined by whether we're using boot-time
	 * exception vectors, according to the BEV bit in the CP0 Status register.
	 */
	if (cpzero->use_boot_excp_address()) {
		base = 0xbfc00100;
	} else {
		base = 0x80000000;
	}

	/* Do we have a User TLB Miss exception? If so, jump to the
	 * User TLB Miss exception vector, otherwise jump to the
	 * common exception vector.
	 */
	if ((excCode == TLBL || excCode == TLBS) && (cpzero->tlb_miss_user)) {
		vector = 0x000;
	} else {
		vector = 0x080;
	}

	if (opt_excmsg && (excCode != Int || opt_reportirq)) {
		fprintf(stderr,"Exception %d (%s) triggered, EPC=%08x\n", excCode, 
			strexccode(excCode), epc);
		fprintf(stderr,
			" Priority is %d; delay state is %s; mem access mode is %s\n",
			prio, strdelaystate(delay_state), strmemmode(mode));
		if (excCode == Int) {
		  uint32 status, bad, cause;
		  cpzero->read_debug_info(&status, &bad, &cause);
		  fprintf (stderr, " Interrupt cause = %x, status = %x\n", cause, status);
		}
	}
    if (opt_tracing) {
		if (tracing) {
			current_trace.exception_happened = true;
			current_trace.last_exception_code = excCode;
		}
	}
	pc = base + vector;
	exception_pending = true;
}

/* emulation of instructions */
void
CPU::cpzero_emulate(uint32 instr, uint32 pc)
{
	cpzero->cpzero_emulate(instr, pc);
	mem->cache_set_control_bits(cpzero->caches_isolated(),
		cpzero->caches_swapped());
}

/* Called when the program wants to use coprocessor COPROCNO, and there
 * isn't any implementation for that coprocessor.
 * Results in a Coprocessor Unusable exception, along with an error
 * message being printed if the coprocessor is marked usable in the
 * CP0 Status register.
 */
void
CPU::cop_unimpl (int coprocno, uint32 instr, uint32 pc)
{
	if (cpzero->cop_usable (coprocno)) {
		/* Since they were expecting this to work, the least we
		 * can do is print an error message. */
		fprintf (stderr, "CP%d instruction %x not implemented at pc=0x%x:\n",
				 coprocno, instr, pc);
		machine->disasm->disassemble (pc, instr);
		exception (CpU, ANY, coprocno);
	} else {
		/* It's fair game to just throw an exception, if they
		 * haven't even bothered to twiddle the status bits first. */
		exception (CpU, ANY, coprocno);
	}
}

void
CPU::cpone_emulate(uint32 instr, uint32 pc)
{
	if (opt_fpu) {
		// FIXME: check cpzero->cop_usable
		fpu->cpone_emulate (instr, pc);
	} else {
		/* If it's a cfc1 <reg>, $0 then we copy 0 into reg,
		 * which is supposed to mean there is NO cp1... 
		 * for now, though, ANYTHING else asked of cp1 results
		 * in the default "unimplemented" behavior. */
		if (cpzero->cop_usable (1) && rs (instr) == 2
                    && rd (instr) == 0) {
			reg[rt (instr)] = 0; /* No cp1. */
		} else {
			cop_unimpl (1, instr, pc);
		}
        }
}

void
CPU::cptwo_emulate(uint32 instr, uint32 pc)
{
	cop_unimpl (2, instr, pc);
}

void
CPU::cpthree_emulate(uint32 instr, uint32 pc)
{
	cop_unimpl (3, instr, pc);
}

void
CPU::control_transfer (uint32 new_pc)
{
	if (!new_pc) warning ("Jumping to zero (PC = 0x%x)\n", pc);
	delay_state = DELAYING;
    delay_pc = new_pc;
}

/// calc_jump_target - Calculate the address to jump to as a result of
/// the J-format (jump) instruction INSTR at address PC.  (PC is the address
/// of the jump instruction, and INSTR is the jump instruction word.)
///
uint32
CPU::calc_jump_target (uint32 instr, uint32 pc)
{
    // Must use address of delay slot (pc + 4) to calculate.
	return ((pc + 4) & 0xf0000000) | (jumptarg(instr) << 2);
}

void
CPU::jump(uint32 instr, uint32 pc)
{
    control_transfer (calc_jump_target (instr, pc));
}

void
CPU::j_emulate(uint32 instr, uint32 pc)
{
	jump (instr, pc);
}

void
CPU::jal_emulate(uint32 instr, uint32 pc)
{
    jump (instr, pc);
	// RA gets addr of instr after delay slot (2 words after this one).
	reg[reg_ra] = pc + 8;
}

/// calc_branch_target - Calculate the address to jump to for the
/// PC-relative branch for which the offset is specified by the immediate field
/// of the branch instruction word INSTR, with the program counter equal to PC.
/// 
uint32
CPU::calc_branch_target(uint32 instr, uint32 pc)
{
	return (pc + 4) + (s_immed(instr) << 2);
}

void
CPU::branch(uint32 instr, uint32 pc)
{
    control_transfer (calc_branch_target (instr, pc));
}

void
CPU::beq_emulate(uint32 instr, uint32 pc)
{
	if (reg[rs(instr)] == reg[rt(instr)])
        branch (instr, pc);
}

void
CPU::bne_emulate(uint32 instr, uint32 pc)
{
	if (reg[rs(instr)] != reg[rt(instr)])
        branch (instr, pc);
}

void
CPU::blez_emulate(uint32 instr, uint32 pc)
{
	if (rt(instr) != 0) {
		exception(RI);
		return;
    }
	if (reg[rs(instr)] == 0 || (reg[rs(instr)] & 0x80000000))
		branch(instr, pc);
}

void
CPU::bgtz_emulate(uint32 instr, uint32 pc)
{
	if (rt(instr) != 0) {
		exception(RI);
		return;
	}
	if (reg[rs(instr)] != 0 && (reg[rs(instr)] & 0x80000000) == 0)
		branch(instr, pc);
}

void
CPU::addi_emulate(uint32 instr, uint32 pc)
{
	int32 a, b, sum;

	a = (int32)reg[rs(instr)];
	b = s_immed(instr);
	sum = a + b;
	if ((a < 0 && b < 0 && !(sum < 0)) || (a >= 0 && b >= 0 && !(sum >= 0))) {
		exception(Ov);
		return;
	} else {
		reg[rt(instr)] = (uint32)sum;
	}
}

void
CPU::addiu_emulate(uint32 instr, uint32 pc)
{
	int32 a, b, sum;

	a = (int32)reg[rs(instr)];
	b = s_immed(instr);
	sum = a + b;
	reg[rt(instr)] = (uint32)sum;
}

void
CPU::slti_emulate(uint32 instr, uint32 pc)
{
	int32 s_rs = reg[rs(instr)];

	if (s_rs < s_immed(instr)) {
		reg[rt(instr)] = 1;
	} else {
		reg[rt(instr)] = 0;
	}
}

void
CPU::sltiu_emulate(uint32 instr, uint32 pc)
{
	if (reg[rs(instr)] < (uint32)(int32)s_immed(instr)) {
		reg[rt(instr)] = 1;
	} else {
		reg[rt(instr)] = 0;
	}
}

void
CPU::andi_emulate(uint32 instr, uint32 pc)
{
	reg[rt(instr)] = (reg[rs(instr)] & 0x0ffff) & immed(instr);
}

void
CPU::ori_emulate(uint32 instr, uint32 pc)
{
	reg[rt(instr)] = reg[rs(instr)] | immed(instr);
}

void
CPU::xori_emulate(uint32 instr, uint32 pc)
{
	reg[rt(instr)] = reg[rs(instr)] ^ immed(instr);
}

void
CPU::lui_emulate(uint32 instr, uint32 pc)
{
	reg[rt(instr)] = immed(instr) << 16;
}

void
CPU::lb_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, base;
	int8 byte;
	int32 offset;
	bool cacheable;

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(virt, DATALOAD, &cacheable, this);
	if (exception_pending) return;

	/* Fetch byte.
	 * Because it is assigned to a signed variable (int32 byte)
	 * it will be sign-extended.
	 */
	byte = mem->fetch_byte(phys, cacheable, this);
	if (exception_pending) return;

	/* Load target register with data. */
	reg[rt(instr)] = byte;
}

void
CPU::lh_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, base;
	int16 halfword;
	int32 offset;
	bool cacheable;

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;

	/* This virtual address must be halfword-aligned. */
	if (virt % 2 != 0) {
		exception(AdEL,DATALOAD);
		return;
	}

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(virt, DATALOAD, &cacheable, this);
	if (exception_pending) return;

	/* Fetch halfword.
	 * Because it is assigned to a signed variable (int32 halfword)
	 * it will be sign-extended.
	 */
	halfword = mem->fetch_halfword(phys, cacheable, this);
	if (exception_pending) return;

	/* Load target register with data. */
	reg[rt(instr)] = halfword;
}

/* The lwr and lwl algorithms here are taken from SPIM 6.0,
 * since I didn't manage to come up with a better way to write them.
 * Improvements are welcome.
 */
uint32
CPU::lwr(uint32 regval, uint32 memval, uint8 offset)
{
	if (opt_bigendian) {
		switch (offset)
		{
			case 0: return (regval & 0xffffff00) |
						((unsigned)(memval & 0xff000000) >> 24);
			case 1: return (regval & 0xffff0000) |
						((unsigned)(memval & 0xffff0000) >> 16);
			case 2: return (regval & 0xff000000) |
						((unsigned)(memval & 0xffffff00) >> 8);
			case 3: return memval;
		}
	} else /* if MIPS target is little endian */ {
		switch (offset)
		{
			/* The SPIM source claims that "The description of the
			 * little-endian case in Kane is totally wrong." The fact
			 * that I ripped off the LWR algorithm from them could be
			 * viewed as a sort of passive assumption that their claim
			 * is correct.
			 */
			case 0: /* 3 in book */
				return memval;
			case 1: /* 0 in book */
				return (regval & 0xff000000) | ((memval & 0xffffff00) >> 8);
			case 2: /* 1 in book */
				return (regval & 0xffff0000) | ((memval & 0xffff0000) >> 16);
			case 3: /* 2 in book */
				return (regval & 0xffffff00) | ((memval & 0xff000000) >> 24);
		}
	}
	fatal_error("Invalid offset %x passed to lwr\n", offset);
}

uint32
CPU::lwl(uint32 regval, uint32 memval, uint8 offset)
{
	if (opt_bigendian) {
		switch (offset)
		{
			case 0: return memval;
			case 1: return (memval & 0xffffff) << 8 | (regval & 0xff);
			case 2: return (memval & 0xffff) << 16 | (regval & 0xffff);
			case 3: return (memval & 0xff) << 24 | (regval & 0xffffff);
		}
	} else /* if MIPS target is little endian */ {
		switch (offset)
		{
			case 0: return (memval & 0xff) << 24 | (regval & 0xffffff);
			case 1: return (memval & 0xffff) << 16 | (regval & 0xffff);
			case 2: return (memval & 0xffffff) << 8 | (regval & 0xff);
			case 3: return memval;
		}
	}
	fatal_error("Invalid offset %x passed to lwl\n", offset);
}

void
CPU::lwl_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, wordvirt, base, memword;
	uint8 which_byte;
	int32 offset;
	bool cacheable;

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;
	/* We request the word containing the byte-address requested. */
	wordvirt = virt & ~0x03UL;

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(wordvirt, DATALOAD, &cacheable, this);
	if (exception_pending) return;

	/* Fetch word. */
	memword = mem->fetch_word(phys, DATALOAD, cacheable, this);
	if (exception_pending) return;
	
	/* Insert bytes into the left side of the register. */
	which_byte = virt & 0x03;
	reg[rt(instr)] = lwl(reg[rt(instr)], memword, which_byte);
}

void
CPU::lw_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, base, word;
	int32 offset;
	bool cacheable;

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;

	/* This virtual address must be word-aligned. */
	if (virt % 4 != 0) {
		exception(AdEL,DATALOAD);
		return;
	}

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(virt, DATALOAD, &cacheable, this);
	if (exception_pending) return;

	/* Fetch word. */
	word = mem->fetch_word(phys, DATALOAD, cacheable, this);
	if (exception_pending) return;

	/* Load target register with data. */
	reg[rt(instr)] = word;
}

void
CPU::lbu_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, base, byte;
	int32 offset;
	bool cacheable;

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(virt, DATALOAD, &cacheable, this);
	if (exception_pending) return;

	/* Fetch byte.  */
	byte = mem->fetch_byte(phys, cacheable, this) & 0x000000ff;
	if (exception_pending) return;

	/* Load target register with data. */
	reg[rt(instr)] = byte;
}

void
CPU::lhu_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, base, halfword;
	int32 offset;
	bool cacheable;

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;

	/* This virtual address must be halfword-aligned. */
	if (virt % 2 != 0) {
		exception(AdEL,DATALOAD);
		return;
	}

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(virt, DATALOAD, &cacheable, this);
	if (exception_pending) return;

	/* Fetch halfword.  */
	halfword = mem->fetch_halfword(phys, cacheable, this) & 0x0000ffff;
	if (exception_pending) return;

	/* Load target register with data. */
	reg[rt(instr)] = halfword;
}

void
CPU::lwr_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, wordvirt, base, memword;
	uint8 which_byte;
	int32 offset;
	bool cacheable;

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;
	/* We request the word containing the byte-address requested. */
	wordvirt = virt & ~0x03UL;

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(wordvirt, DATALOAD, &cacheable, this);
	if (exception_pending) return;

	/* Fetch word. */
	memword = mem->fetch_word(phys, DATALOAD, cacheable, this);
	if (exception_pending) return;
	
	/* Insert bytes into the left side of the register. */
	which_byte = virt & 0x03;
	reg[rt(instr)] = lwr(reg[rt(instr)], memword, which_byte);
}

void
CPU::sb_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, base;
	uint8 data;
	int32 offset;
	bool cacheable;

	/* Load data from register. */
	data = reg[rt(instr)] & 0x0ff;

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(virt, DATASTORE, &cacheable, this);
	if (exception_pending) return;

	/* Store byte. */
	mem->store_byte(phys, data, cacheable, this);
}

void
CPU::sh_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, base;
	uint16 data;
	int32 offset;
	bool cacheable;

	/* Load data from register. */
	data = reg[rt(instr)] & 0x0ffff;

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;

	/* This virtual address must be halfword-aligned. */
	if (virt % 2 != 0) {
		exception(AdES,DATASTORE);
		return;
	}

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(virt, DATASTORE, &cacheable, this);
	if (exception_pending) return;

	/* Store halfword. */
	mem->store_halfword(phys, data, cacheable, this);
}

uint32
CPU::swl(uint32 regval, uint32 memval, uint8 offset)
{
	if (opt_bigendian) {
		switch (offset) {
			case 0: return regval; 
			case 1: return (memval & 0xff000000) | (regval >> 8 & 0xffffff); 
			case 2: return (memval & 0xffff0000) | (regval >> 16 & 0xffff); 
			case 3: return (memval & 0xffffff00) | (regval >> 24 & 0xff); 
		}
	} else /* if MIPS target is little endian */ {
		switch (offset) {
			case 0: return (memval & 0xffffff00) | (regval >> 24 & 0xff); 
			case 1: return (memval & 0xffff0000) | (regval >> 16 & 0xffff); 
			case 2: return (memval & 0xff000000) | (regval >> 8 & 0xffffff); 
			case 3: return regval; 
		}
	}
	fatal_error("Invalid offset %x passed to swl\n", offset);
}

uint32
CPU::swr(uint32 regval, uint32 memval, uint8 offset)
{
	if (opt_bigendian) {
		switch (offset) {
			case 0: return ((regval << 24) & 0xff000000) | (memval & 0xffffff); 
			case 1: return ((regval << 16) & 0xffff0000) | (memval & 0xffff); 
			case 2: return ((regval << 8) & 0xffffff00) | (memval & 0xff); 
			case 3: return regval; 
		}
	} else /* if MIPS target is little endian */ {
		switch (offset) {
			case 0: return regval; 
			case 1: return ((regval << 8) & 0xffffff00) | (memval & 0xff); 
			case 2: return ((regval << 16) & 0xffff0000) | (memval & 0xffff); 
			case 3: return ((regval << 24) & 0xff000000) | (memval & 0xffffff); 
		}
	}
	fatal_error("Invalid offset %x passed to swr\n", offset);
}

void
CPU::swl_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, wordvirt, base, regdata, memdata;
	int32 offset;
	uint8 which_byte;
	bool cacheable;

	/* Load data from register. */
	regdata = reg[rt(instr)];

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;
	/* We request the word containing the byte-address requested. */
	wordvirt = virt & ~0x03UL;

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(wordvirt, DATASTORE, &cacheable, this);
	if (exception_pending) return;

	/* Read data from memory. */
	memdata = mem->fetch_word(phys, DATASTORE, cacheable, this);
	if (exception_pending) return;

	/* Write back the left side of the register. */
	which_byte = virt & 0x03UL;
	mem->store_word(phys, swl(regdata, memdata, which_byte), cacheable, this);
}

void
CPU::sw_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, base, data;
	int32 offset;
	bool cacheable;

	/* Load data from register. */
	data = reg[rt(instr)];

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;

	/* This virtual address must be word-aligned. */
	if (virt % 4 != 0) {
		exception(AdES,DATASTORE);
		return;
	}

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(virt, DATASTORE, &cacheable, this);
	if (exception_pending) return;

	/* Store word. */
	mem->store_word(phys, data, cacheable, this);
}

void
CPU::swr_emulate(uint32 instr, uint32 pc)
{
	uint32 phys, virt, wordvirt, base, regdata, memdata;
	int32 offset;
	uint8 which_byte;
	bool cacheable;

	/* Load data from register. */
	regdata = reg[rt(instr)];

	/* Calculate virtual address. */
	base = reg[rs(instr)];
	offset = s_immed(instr);
	virt = base + offset;
	/* We request the word containing the byte-address requested. */
	wordvirt = virt & ~0x03UL;

	/* Translate virtual address to physical address. */
	phys = cpzero->address_trans(wordvirt, DATASTORE, &cacheable, this);
	if (exception_pending) return;

	/* Read data from memory. */
	memdata = mem->fetch_word(phys, DATASTORE, cacheable, this);
	if (exception_pending) return;

	/* Write back the right side of the register. */
	which_byte = virt & 0x03UL;
	mem->store_word(phys, swr(regdata, memdata, which_byte), cacheable, this);
}

void
CPU::lwc1_emulate(uint32 instr, uint32 pc)
{
	if (opt_fpu) {
		uint32 phys, virt, base, word;
		int32 offset;
		bool cacheable;

		/* Calculate virtual address. */
		base = reg[rs(instr)];
		offset = s_immed(instr);
		virt = base + offset;

		/* This virtual address must be word-aligned. */
		if (virt % 4 != 0) {
			exception(AdEL,DATALOAD);
			return;
		}

		/* Translate virtual address to physical address. */
		phys = cpzero->address_trans(virt, DATALOAD, &cacheable, this);
		if (exception_pending) return;

		/* Fetch word. */
		word = mem->fetch_word(phys, DATALOAD, cacheable, this);
		if (exception_pending) return;

		/* Load target register with data. */
		fpu->write_reg (rt (instr), word);
	} else {
		cop_unimpl (1, instr, pc);
	}
}

void
CPU::lwc2_emulate(uint32 instr, uint32 pc)
{
	cop_unimpl (2, instr, pc);
}

void
CPU::lwc3_emulate(uint32 instr, uint32 pc)
{
	cop_unimpl (3, instr, pc);
}

void
CPU::swc1_emulate(uint32 instr, uint32 pc)
{
	if (opt_fpu) {
		uint32 phys, virt, base, data;
		int32 offset;
		bool cacheable;

		/* Load data from register. */
		data = fpu->read_reg (rt (instr));

		/* Calculate virtual address. */
		base = reg[rs(instr)];
		offset = s_immed(instr);
		virt = base + offset;

		/* This virtual address must be word-aligned. */
		if (virt % 4 != 0) {
			exception(AdES,DATASTORE);
			return;
		}

		/* Translate virtual address to physical address. */
		phys = cpzero->address_trans(virt, DATASTORE, &cacheable, this);
		if (exception_pending) return;

		/* Store word. */
		mem->store_word(phys, data, cacheable, this);
	} else {
		cop_unimpl (1, instr, pc);
	}
}

void
CPU::swc2_emulate(uint32 instr, uint32 pc)
{
	cop_unimpl (2, instr, pc);
}

void
CPU::swc3_emulate(uint32 instr, uint32 pc)
{
	cop_unimpl (3, instr, pc);
}

void
CPU::sll_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = reg[rt(instr)] << shamt(instr);
}

int32
srl(int32 a, int32 b)
{
	if (b == 0) {
		return a;
	} else if (b == 32) {
		return 0;
	} else {
		return (a >> b) & ((1 << (32 - b)) - 1);
	}
}

int32
sra(int32 a, int32 b)
{
	if (b == 0) {
		return a;
	} else {
		return (a >> b) | (((a >> 31) & 0x01) * (((1 << b) - 1) << (32 - b)));
	}
}

void
CPU::srl_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = srl(reg[rt(instr)], shamt(instr));
}

void
CPU::sra_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = sra(reg[rt(instr)], shamt(instr));
}

void
CPU::sllv_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = reg[rt(instr)] << (reg[rs(instr)] & 0x01f);
}

void
CPU::srlv_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = srl(reg[rt(instr)], reg[rs(instr)] & 0x01f);
}

void
CPU::srav_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = sra(reg[rt(instr)], reg[rs(instr)] & 0x01f);
}

void
CPU::jr_emulate(uint32 instr, uint32 pc)
{
	if (reg[rd(instr)] != 0) {
		exception(RI);
		return;
	}
	control_transfer (reg[rs(instr)]);
}

void
CPU::jalr_emulate(uint32 instr, uint32 pc)
{
	control_transfer (reg[rs(instr)]);
	/* RA gets addr of instr after delay slot (2 words after this one). */
	reg[rd(instr)] = pc + 8;
}

void
CPU::syscall_emulate(uint32 instr, uint32 pc)
{
	exception(Sys);
}

void
CPU::break_emulate(uint32 instr, uint32 pc)
{
	exception(Bp);
}

void
CPU::mfhi_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = hi;
}

void
CPU::mthi_emulate(uint32 instr, uint32 pc)
{
	if (rd(instr) != 0) {
		exception(RI);
		return;
	}
	hi = reg[rs(instr)];
}

void
CPU::mflo_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = lo;
}

void
CPU::mtlo_emulate(uint32 instr, uint32 pc)
{
	if (rd(instr) != 0) {
		exception(RI);
		return;
	}
	lo = reg[rs(instr)];
}

void
CPU::mult_emulate(uint32 instr, uint32 pc)
{
	if (rd(instr) != 0) {
		exception(RI);
		return;
	}
	mult64s(&hi, &lo, reg[rs(instr)], reg[rt(instr)]);
}

void
CPU::mult64(uint32 *hi, uint32 *lo, uint32 n, uint32 m)
{
#ifdef HAVE_LONG_LONG
	uint64 result;
	result = ((uint64)n) * ((uint64)m);
	*hi = (uint32) (result >> 32);
	*lo = (uint32) result;
#else /* HAVE_LONG_LONG */
	/*           n = (w << 16) | x ; m = (y << 16) | z
	 *     w x   g = a + e ; h = b + f ; p = 65535
	 *   X y z   c = (z * x) mod p
	 *   -----   b = (z * w + ((z * x) div p)) mod p
	 *   a b c   a = (z * w + ((z * x) div p)) div p
	 * d e f     f = (y * x) mod p
	 * -------   e = (y * w + ((y * x) div p)) mod p
	 * i g h c   d = (y * w + ((y * x) div p)) div p
	 */
	uint16 w,x,y,z,a,b,c,d,e,f,g,h,i;
	uint32 p;
	p = 65536;
	w = (n >> 16) & 0x0ffff;
	x = n & 0x0ffff;
	y = (m >> 16) & 0x0ffff;
	z = m & 0x0ffff;
	c = (z * x) % p;
	b = (z * w + ((z * x) / p)) % p;
	a = (z * w + ((z * x) / p)) / p;
	f = (y * x) % p;
	e = (y * w + ((y * x) / p)) % p;
	d = (y * w + ((y * x) / p)) / p;
	h = (b + f) % p;
	g = ((a + e) + ((b + f) / p)) % p;
	i = d + (((a + e) + ((b + f) / p)) / p);
	*hi = (i << 16) | g;
	*lo = (h << 16) | c;
#endif /* HAVE_LONG_LONG */
}

void
CPU::mult64s(uint32 *hi, uint32 *lo, int32 n, int32 m)
{
#ifdef HAVE_LONG_LONG
	int64 result;
	result = ((int64)n) * ((int64)m);
	*hi = (uint32) (result >> 32);
	*lo = (uint32) result;
#else /* HAVE_LONG_LONG */
	int32 result_sign = (n<0)^(m<0);
	int32 n_abs = n;
	int32 m_abs = m;

	if (n_abs < 0) n_abs = -n_abs;
	if (m_abs < 0) m_abs = -m_abs;

	mult64(hi,lo,n_abs,m_abs);
	if (result_sign)
	{
		*hi = ~*hi;
		*lo = ~*lo;
		if (*lo & 0x80000000)
		{
			*lo += 1;
			if (!(*lo & 0x80000000))
			{
				*hi += 1;
			}
		}
		else
		{
			*lo += 1;
		}
	}
#endif /* HAVE_LONG_LONG */
}

void
CPU::multu_emulate(uint32 instr, uint32 pc)
{
	if (rd(instr) != 0) {
		exception(RI);
		return;
	}
	mult64(&hi, &lo, reg[rs(instr)], reg[rt(instr)]);
}

void
CPU::div_emulate(uint32 instr, uint32 pc)
{
	int32 signed_rs = (int32)reg[rs(instr)];
	int32 signed_rt = (int32)reg[rt(instr)];
	lo = signed_rs / signed_rt;
	hi = signed_rs % signed_rt;
}

void
CPU::divu_emulate(uint32 instr, uint32 pc)
{
	lo = reg[rs(instr)] / reg[rt(instr)];
	hi = reg[rs(instr)] % reg[rt(instr)];
}

void
CPU::add_emulate(uint32 instr, uint32 pc)
{
	int32 a, b, sum;
	a = (int32)reg[rs(instr)];
	b = (int32)reg[rt(instr)];
	sum = a + b;
	if ((a < 0 && b < 0 && !(sum < 0)) || (a >= 0 && b >= 0 && !(sum >= 0))) {
		exception(Ov);
		return;
	} else {
		reg[rd(instr)] = (uint32)sum;
	}
}

void
CPU::addu_emulate(uint32 instr, uint32 pc)
{
	int32 a, b, sum;
	a = (int32)reg[rs(instr)];
	b = (int32)reg[rt(instr)];
	sum = a + b;
	reg[rd(instr)] = (uint32)sum;
}

void
CPU::sub_emulate(uint32 instr, uint32 pc)
{
	int32 a, b, diff;
	a = (int32)reg[rs(instr)];
	b = (int32)reg[rt(instr)];
	diff = a - b;
	if ((a < 0 && !(b < 0) && !(diff < 0)) || (!(a < 0) && b < 0 && diff < 0)) {
		exception(Ov);
		return;
	} else {
		reg[rd(instr)] = (uint32)diff;
	}
}

void
CPU::subu_emulate(uint32 instr, uint32 pc)
{
	int32 a, b, diff;
	a = (int32)reg[rs(instr)];
	b = (int32)reg[rt(instr)];
	diff = a - b;
	reg[rd(instr)] = (uint32)diff;
}

void
CPU::and_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = reg[rs(instr)] & reg[rt(instr)];
}

void
CPU::or_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = reg[rs(instr)] | reg[rt(instr)];
}

void
CPU::xor_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = reg[rs(instr)] ^ reg[rt(instr)];
}

void
CPU::nor_emulate(uint32 instr, uint32 pc)
{
	reg[rd(instr)] = ~(reg[rs(instr)] | reg[rt(instr)]);
}

void
CPU::slt_emulate(uint32 instr, uint32 pc)
{
	int32 s_rs = (int32)reg[rs(instr)];
	int32 s_rt = (int32)reg[rt(instr)];
	if (s_rs < s_rt) {
		reg[rd(instr)] = 1;
	} else {
		reg[rd(instr)] = 0;
	}
}

void
CPU::sltu_emulate(uint32 instr, uint32 pc)
{
	if (reg[rs(instr)] < reg[rt(instr)]) {
		reg[rd(instr)] = 1;
	} else {
		reg[rd(instr)] = 0;
	}
}

void
CPU::bltz_emulate(uint32 instr, uint32 pc)
{
	if ((int32)reg[rs(instr)] < 0)
		branch(instr, pc);
}

void
CPU::bgez_emulate(uint32 instr, uint32 pc)
{
	if ((int32)reg[rs(instr)] >= 0)
		branch(instr, pc);
}

/* As with JAL, BLTZAL and BGEZAL cause RA to get the address of the
 * instruction two words after the current one (pc + 8).
 */
void
CPU::bltzal_emulate(uint32 instr, uint32 pc)
{
	reg[reg_ra] = pc + 8;
	if ((int32)reg[rs(instr)] < 0)
		branch(instr, pc);
}

void
CPU::bgezal_emulate(uint32 instr, uint32 pc)
{
	reg[reg_ra] = pc + 8;
	if ((int32)reg[rs(instr)] >= 0)
		branch(instr, pc);
}

/* reserved instruction */
void
CPU::RI_emulate(uint32 instr, uint32 pc)
{
	exception(RI);
}

void
CPU::open_trace_file ()
{
	char tracefilename[80];
	for (unsigned i = 0; ; ++i) {
		sprintf (tracefilename, "/tmp/traceout%d.txt", i);
		if (!can_read_file (tracefilename))
			break;
	}
	traceout = fopen (tracefilename, "w");
}

void
CPU::close_trace_file ()
{
	fclose (traceout);
}

void
CPU::write_trace_to_file ()
{
	for (Trace::record_iterator ri = current_trace.rbegin (), re =
         current_trace.rend (); ri != re; ++ri) {
        Trace::Record &tr = *ri;
		fprintf (traceout, "(TraceRec (PC #x%08x) (Insn #x%08x) ", tr.pc, tr.instr);

		if (! tr.inputs.empty ()) {

		fprintf (traceout, "(Inputs (");
		for (std::vector<Trace::Operand>::iterator oi = tr.inputs.begin (),
			oe = tr.inputs.end (); oi != oe; ++oi) {
			Trace::Operand &op = *oi;
			if (op.regno != -1) {
				fprintf (traceout, "(%s %d #x%08x) ", op.tag, op.regno, op.val);
			} else {
				fprintf (traceout, "(%s #x%08x) ", op.tag, op.val);
			}
		}
		fprintf (traceout, "))");

		}

		if (!tr.outputs.empty ()) {

		fprintf (traceout, "(Outputs (");
		for (std::vector<Trace::Operand>::iterator oi = tr.outputs.begin (),
			oe = tr.outputs.end (); oi != oe; ++oi) {
			Trace::Operand &op = *oi;
			if (op.regno != -1) {
				fprintf (traceout, "(%s %d #x%08x) ", op.tag, op.regno, op.val);
			} else {
				fprintf (traceout, "(%s #x%08x) ", op.tag, op.val);
			}
		}
		fprintf (traceout, "))");

		}
		fprintf (traceout, ")\n");
	}
	// print lastchanges
	fprintf (traceout, "(LastChanges (");
	for (unsigned i = 0; i < 32; ++i) { 
		if (current_trace.last_change_for_reg.find (i) !=
				current_trace.last_change_for_reg.end ()) {
			last_change &lc = current_trace.last_change_for_reg[i];
			fprintf (traceout,
				"(Reg %d PC %x Instr %x OldValue %x CurValue %x) ",
				i, lc.pc, lc.instr, lc.old_value, reg[i]);
		}
	}
	fprintf (traceout, "))\n");
}

void
CPU::flush_trace()
{
	if (!opt_tracing) return;
	write_trace_to_file ();
	current_trace.clear ();
}

void
CPU::start_tracing()
{
	if (!opt_tracing) return;
	tracing = true;
	current_trace.clear ();
}

void
CPU::write_trace_instr_inputs (uint32 instr)
{
    // rs,rt:  add,addu,and,beq,bne,div,divu,mult,multu,nor,or,sb,sh,sllv,slt,
    //         sltu,srav,srlv,sub,subu,sw,swl,swr,xor
    // rs:     addi,addiu,andi,bgez,bgezal,bgtz,blez,bltz,bltzal,jal,jr,lb,lbu,
    //         lh,lhu,lw,lwl,lwr,mthi,mtlo,ori,slti,sltiu,xori
    // hi:     mfhi
    // lo:     mflo
    // rt:     mtc0
    // rt,shamt: sll,sra,srl
	// NOT HANDLED: syscall,break,jalr,cpone,cpthree,cptwo,cpzero,
	//              j,lui,lwc1,lwc2,lwc3,mtc0,swc1,swc2,swc3
	switch(opcode(instr))
	{
		case 0:
			switch(funct(instr))
			{
				case 4: //sllv
				case 6: //srlv
				case 7: //srav
				case 24: //mult
				case 25: //multu
				case 26: //div
				case 27: //divu
				case 32: //add
				case 33: //addu
				case 34: //sub
				case 35: //subu
				case 36: //and
				case 37: //or
				case 38: //xor
				case 39: //nor
				case 42: //slt
				case 43: //sltu
					current_trace_record.inputs_push_back_op("rs",
                        rs(instr), reg[rs(instr)]);
					current_trace_record.inputs_push_back_op("rt",
                        rt(instr), reg[rt(instr)]);
					break;
				case 0: //sll
				case 2: //srl
				case 3: //sra
					current_trace_record.inputs_push_back_op("rt",
                        rt(instr), reg[rt(instr)]);
					break;
				case 8: //jr
				case 17: //mthi
				case 19: //mtlo
					current_trace_record.inputs_push_back_op("rs",
                        rs(instr), reg[rs(instr)]);
					break;
				case 16: //mfhi
					current_trace_record.inputs_push_back_op("hi",
                        hi);
					break;
				case 18: //mflo
					current_trace_record.inputs_push_back_op("lo",
                        lo);
					break;
			}
			break;
		case 1:
			switch(rt(instr)) {
				case 0: //bltz
				case 1: //bgez
				case 16: //bltzal
				case 17: //bgezal
					current_trace_record.inputs_push_back_op("rs",
                        rs(instr), reg[rs(instr)]);
					break;
			}
			break;
		case 3: //jal
		case 6: //blez
		case 7: //bgtz
		case 8: //addi
		case 9: //addiu
		case 12: //andi
		case 32: //lb
		case 33: //lh
		case 35: //lw
		case 36: //lbu
		case 37: //lhu
		case 40: //sb
		case 41: //sh
		case 42: //swl
		case 43: //sw
		case 46: //swr
			current_trace_record.inputs_push_back_op("rs",
				rs(instr), reg[rs(instr)]);
			current_trace_record.inputs_push_back_op("rt",
				rt(instr), reg[rt(instr)]);
			break;
		case 4: //beq
		case 5: //bne
		case 10: //slti
		case 11: //sltiu
		case 13: //ori
		case 14: //xori
		case 34: //lwl
		case 38: //lwr
			current_trace_record.inputs_push_back_op("rs",
				rs(instr), reg[rs(instr)]);
			break;
	}
}


void
CPU::write_trace_instr_outputs (uint32 instr)
{
    // hi,lo: div,divu,mult,multu
    // hi:    mthi
    // lo:    mtlo
    // rt:    addi,addiu,andi,lb,lbu,lh,lhu,lui,lw,lwl,lwr,mfc0,ori,slti,sltiu,
    //        xori
    // rd:    add,addu,and,jalr,mfhi,mflo,nor,or,sllv,slt,sltu,sll,sra,srav,srl,
    //        srlv,sub,subu,xor
    // r31:   jal
	// NOT HANDLED: syscall,break,jalr,cpone,cpthree,cptwo,cpzero,j,lwc1,lwc2,
    //              lwc3,mtc0,swc1,swc2,swc3,jr,jalr,mfc0,bgtz,blez,sb,sh,sw,
    //              swl,swr,beq,bne
	switch(opcode(instr))
	{
		case 0:
			switch(funct(instr))
			{
				case 26: //div
				case 27: //divu
				case 24: //mult
				case 25: //multu
					current_trace_record.outputs_push_back_op("lo",
                        lo);
					current_trace_record.outputs_push_back_op("hi",
                        hi);
					break;
				case 17: //mthi
					current_trace_record.outputs_push_back_op("hi",
                        hi);
					break;
				case 19: //mtlo
					current_trace_record.outputs_push_back_op("lo",
                        lo);
					break;
				case 32: //add
				case 33: //addu
				case 36: //and
				case 39: //nor
				case 37: //or
				case 4: //sllv
				case 42: //slt
				case 43: //sltu
				case 7: //srav
				case 6: //srlv
				case 34: //sub
				case 35: //subu
				case 38: //xor
				case 0: //sll
				case 3: //sra
				case 2: //srl
				case 16: //mfhi
				case 18: //mflo
					current_trace_record.outputs_push_back_op("rd",
                        rd(instr),reg[rd(instr)]);
					break;
			}
			break;
		case 8: //addi
		case 9: //addiu
		case 12: //andi
		case 32: //lb
		case 36: //lbu
		case 33: //lh
		case 37: //lhu
		case 35: //lw
		case 34: //lwl
		case 38: //lwr
		case 13: //ori
		case 10: //slti
		case 11: //sltiu
		case 14: //xori
		case 15: //lui
			current_trace_record.outputs_push_back_op("rt",rt(instr),
                reg[rt(instr)]);
			break;
		case 3: //jal
			current_trace_record.outputs_push_back_op("ra",
                reg[reg_ra]);
			break;
	}
}

void
CPU::write_trace_record_1(uint32 pc, uint32 instr)
{
	current_trace_record.clear ();
	current_trace_record.pc = pc;
	current_trace_record.instr = instr;
	write_trace_instr_inputs (instr);
	std::copy (&reg[0], &reg[32], &current_trace_record.saved_reg[0]);
}

void
CPU::write_trace_record_2 (uint32 pc, uint32 instr)
{
	write_trace_instr_outputs (instr);
	// which insn was the last to change each reg?
	for (unsigned i = 0; i < 32; ++i) { 
		if (current_trace_record.saved_reg[i] != reg[i]) {
			current_trace.last_change_for_reg[i] = last_change::make (pc, instr,
				current_trace_record.saved_reg[i]);
		}
	}
	current_trace.push_back_record (current_trace_record);
    if (current_trace.record_size () > opt_tracesize)
		flush_trace ();
}

void
CPU::stop_tracing()
{
	tracing = false;
}

/* dispatching */
void
CPU::step()
{
	// Table of emulation functions.
	static const emulate_funptr opcodeJumpTable[] = {
        &CPU::funct_emulate, &CPU::regimm_emulate,  &CPU::j_emulate,
        &CPU::jal_emulate,   &CPU::beq_emulate,     &CPU::bne_emulate,
        &CPU::blez_emulate,  &CPU::bgtz_emulate,    &CPU::addi_emulate,
        &CPU::addiu_emulate, &CPU::slti_emulate,    &CPU::sltiu_emulate,
        &CPU::andi_emulate,  &CPU::ori_emulate,     &CPU::xori_emulate,
        &CPU::lui_emulate,   &CPU::cpzero_emulate,  &CPU::cpone_emulate,
        &CPU::cptwo_emulate, &CPU::cpthree_emulate, &CPU::RI_emulate,
        &CPU::RI_emulate,    &CPU::RI_emulate,      &CPU::RI_emulate,
        &CPU::RI_emulate,    &CPU::RI_emulate,      &CPU::RI_emulate,
        &CPU::RI_emulate,    &CPU::RI_emulate,      &CPU::RI_emulate,
        &CPU::RI_emulate,    &CPU::RI_emulate,      &CPU::lb_emulate,
        &CPU::lh_emulate,    &CPU::lwl_emulate,     &CPU::lw_emulate,
        &CPU::lbu_emulate,   &CPU::lhu_emulate,     &CPU::lwr_emulate,
        &CPU::RI_emulate,    &CPU::sb_emulate,      &CPU::sh_emulate,
        &CPU::swl_emulate,   &CPU::sw_emulate,      &CPU::RI_emulate,
        &CPU::RI_emulate,    &CPU::swr_emulate,     &CPU::RI_emulate,
        &CPU::RI_emulate,    &CPU::lwc1_emulate,    &CPU::lwc2_emulate,
        &CPU::lwc3_emulate,  &CPU::RI_emulate,      &CPU::RI_emulate,
        &CPU::RI_emulate,    &CPU::RI_emulate,      &CPU::RI_emulate,
        &CPU::swc1_emulate,  &CPU::swc2_emulate,    &CPU::swc3_emulate,
        &CPU::RI_emulate,    &CPU::RI_emulate,      &CPU::RI_emulate,
        &CPU::RI_emulate
    };

	// Clear exception_pending flag if it was set by a prior instruction.
	exception_pending = false;

	// Decrement Random register every clock cycle.
	cpzero->adjust_random();

    // Check whether we should start tracing with this instruction.
	if (opt_tracing && !tracing && pc == opt_tracestartpc)
		start_tracing();

	// Save address of instruction responsible for exceptions which may occur.
	if (delay_state != DELAYSLOT)
		next_epc = pc;

	// Get physical address of next instruction.
	bool cacheable;
	uint32 real_pc = cpzero->address_trans(pc,INSTFETCH,&cacheable, this);
	if (exception_pending) {
		if (opt_excmsg)
			fprintf(stderr,
				"** PC address translation caused the exception! **\n");
		goto out;
	}

	// Fetch next instruction.
	instr = mem->fetch_word(real_pc,INSTFETCH,cacheable, this);
	if (exception_pending) {
		if (opt_excmsg)
			fprintf(stderr, "** Instruction fetch caused the exception! **\n");
		goto out;
	}

	// Disassemble the instruction, if the user requested it.
	if (opt_instdump) {
		fprintf(stderr,"PC=0x%08x [%08x]\t%08x ",pc,real_pc,instr);
		machine->disasm->disassemble(pc,instr);
	}

	// Perform first half of trace recording for this instruction.
	if (tracing)
		write_trace_record_1 (pc, instr);

	// Check for a (hardware or software) interrupt.
	if (cpzero->interrupt_pending()) {
		exception(Int);
		goto out;
	}

	// Emulate the instruction by jumping to the appropriate emulation method.
	(this->*opcodeJumpTable[opcode(instr)])(instr, pc);

out:
	// Force register zero to contain zero.
	reg[reg_zero] = 0;

	// Perform second half of trace recording for this instruction.
	if (tracing) {
		write_trace_record_2 (pc, instr);
		if (pc == opt_traceendpc)
			stop_tracing();
	}

	// If an exception is pending, then the PC has already been changed to
	// contain the exception vector.  Return now, so that we don't clobber it.
	if (exception_pending) {
		// Instruction at beginning of exception handler is NOT in delay slot,
		// no matter what the last instruction was.
		delay_state = NORMAL;
		return;
	}

	// Recall the delay_state values: 0=NORMAL, 1=DELAYING, 2=DELAYSLOT.
	// This is what the delay_state values mean (at this point in the code):
	// DELAYING: The last instruction caused a branch to be taken.
	//  The next instruction is in the delay slot.
	//  The next instruction EPC will be PC - 4.
	// DELAYSLOT: The last instruction was executed in a delay slot.
	//  The next instruction is on the other end of the branch.
	//  The next instruction EPC will be PC.
	// NORMAL: No branch was executed; next instruction is at PC + 4.
	//  Next instruction EPC is PC.

	// Update the pc and delay_state values.
	pc += 4;
	if (delay_state == DELAYSLOT)
		pc = delay_pc;
	delay_state = (delay_state << 1) & 0x03; // 0->0, 1->2, 2->0
}

void
CPU::funct_emulate(uint32 instr, uint32 pc)
{
	static const emulate_funptr functJumpTable[] = {
		&CPU::sll_emulate,     &CPU::RI_emulate,
		&CPU::srl_emulate,     &CPU::sra_emulate,
		&CPU::sllv_emulate,    &CPU::RI_emulate,
		&CPU::srlv_emulate,    &CPU::srav_emulate,
		&CPU::jr_emulate,      &CPU::jalr_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::syscall_emulate, &CPU::break_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::mfhi_emulate,    &CPU::mthi_emulate,
		&CPU::mflo_emulate,    &CPU::mtlo_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::mult_emulate,    &CPU::multu_emulate,
		&CPU::div_emulate,     &CPU::divu_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::add_emulate,     &CPU::addu_emulate,
		&CPU::sub_emulate,     &CPU::subu_emulate,
		&CPU::and_emulate,     &CPU::or_emulate,
		&CPU::xor_emulate,     &CPU::nor_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::slt_emulate,     &CPU::sltu_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate,
		&CPU::RI_emulate,      &CPU::RI_emulate
	};
	(this->*functJumpTable[funct(instr)])(instr, pc);
}

void
CPU::regimm_emulate(uint32 instr, uint32 pc)
{
	switch(rt(instr))
	{
		case 0: bltz_emulate(instr, pc); break;
		case 1: bgez_emulate(instr, pc); break;
		case 16: bltzal_emulate(instr, pc); break;
		case 17: bgezal_emulate(instr, pc); break;
		default: exception(RI); break; /* reserved instruction */
	}
}

/* Debug functions.
 *
 * These functions are primarily intended to support the Debug class,
 * which interfaces with GDB's remote serial protocol.
 */

/* Copy registers into an ASCII-encoded packet of hex numbers to send
 * to the remote GDB, and return the packet (allocated with malloc).
 */
char *
CPU::debug_registers_to_packet(void)
{
	char *packet = new char [PBUFSIZ];
	int i, r;

	/* order of regs:  (gleaned from gdb/gdb/config/mips/tm-mips.h)
	 * 
	 * cpu->reg[0]...cpu->reg[31]
	 * cpzero->reg[Status]
	 * cpu->lo
	 * cpu->hi
	 * cpzero->reg[BadVAddr]
	 * cpzero->reg[Cause]
	 * cpu->pc
	 * fpu stuff: 35 zeroes (Unimplemented registers read as
	 *  all bits zero.)
	 */
	packet[0] = '\0';
	r = 0;
	for (i = 0; i < 32; i++) {
		debug_packet_push_word(packet, reg[i]); r++;
	}
	uint32 sr, bad, cause;
	cpzero->read_debug_info(&sr, &bad, &cause);
	debug_packet_push_word(packet, sr); r++;
	debug_packet_push_word(packet, lo); r++;
	debug_packet_push_word(packet, hi); r++;
	debug_packet_push_word(packet, bad); r++;
	debug_packet_push_word(packet, cause); r++;
	debug_packet_push_word(packet, pc); r++;
	for (; r < 90; r++) { /* unimplemented regs at end */
		debug_packet_push_word(packet, 0);
	}
	return packet;
}

/* Copy the register values in the ASCII-encoded hex PACKET received from
 * the remote GDB and store them in the appropriate registers.
 */
void
CPU::debug_packet_to_registers(char *packet)
{
	int i;

	for (i = 0; i < 32; i++)
		reg[i] = machine->dbgr->packet_pop_word(&packet);
	uint32 sr, bad, cause;
	sr = machine->dbgr->packet_pop_word(&packet);
	lo = machine->dbgr->packet_pop_word(&packet);
	hi = machine->dbgr->packet_pop_word(&packet);
	bad = machine->dbgr->packet_pop_word(&packet);
	cause = machine->dbgr->packet_pop_word(&packet);
	pc = machine->dbgr->packet_pop_word(&packet);
	cpzero->write_debug_info(sr, bad, cause);
}

/* Returns the exception code of any pending exception, or 0 if no
 * exception is pending.
 */
uint8
CPU::pending_exception(void)
{
	uint32 sr, bad, cause;

	if (! exception_pending) return 0;
	cpzero->read_debug_info(&sr, &bad, &cause);
	return ((cause & Cause_ExcCode_MASK) >> 2);
}

/* Sets the program counter register to the value given in NEWPC. */
void
CPU::debug_set_pc(uint32 newpc)
{
	pc = newpc;
}

/* Returns the current program counter register. */
uint32
CPU::debug_get_pc(void)
{
	return pc;
}

void
CPU::debug_packet_push_word(char *packet, uint32 n)
{
	if (!opt_bigendian) {
		n = Mapper::swap_word(n);
	}
	char packetpiece[10];
	sprintf(packetpiece, "%08x", n);
	strcat(packet, packetpiece);
}

void
CPU::debug_packet_push_byte(char *packet, uint8 n)
{
	char packetpiece[4];
	sprintf(packetpiece, "%02x", n);
	strcat(packet, packetpiece);
}

/* Fetch LEN bytes starting from virtual address ADDR into the packet
 * PACKET, sending exceptions (if any) to CLIENT. Returns -1 if an exception
 * was encountered, 0 otherwise.  If an exception was encountered, the
 * contents of PACKET are undefined, and CLIENT->exception() will have
 * been called.
 */
int
CPU::debug_fetch_region(uint32 addr, uint32 len, char *packet,
	DeviceExc *client)
{
	uint8 byte;
	uint32 real_addr;
	bool cacheable = false;

	for (; len; addr++, len--) {
		real_addr = cpzero->address_trans(addr, DATALOAD, &cacheable, client);
		/* Stop now and return an error code if translation
		 * caused an exception.
		 */
		if (client->exception_pending) {
			return -1;
		}
		byte = mem->fetch_byte(real_addr, true, client);
		/* Stop now and return an error code if the fetch
		 * caused an exception.
		 */
		if (client->exception_pending) {
			return -1;
		}
		debug_packet_push_byte(packet, byte);
	}
	return 0;
}

/* Store LEN bytes starting from virtual address ADDR from data in the packet
 * PACKET, sending exceptions (if any) to CLIENT. Returns -1 if an exception
 * was encountered, 0 otherwise.  If an exception was encountered, the
 * contents of the region of virtual memory from ADDR to ADDR+LEN are undefined,
 * and CLIENT->exception() will have been called.
 */
int
CPU::debug_store_region(uint32 addr, uint32 len, char *packet,
	DeviceExc *client)
{
	uint8 byte;
	uint32 real_addr;
	bool cacheable = false;

	for (; len; addr++, len--) {
		byte = machine->dbgr->packet_pop_byte(&packet);
		real_addr = cpzero->address_trans(addr, DATALOAD, &cacheable, client);
		if (client->exception_pending) {
			return -1;
		}
		mem->store_byte(real_addr, byte, true, client);
		if (client->exception_pending) {
			return -1;
		}
	}
	return 0;
}
