#include "lib.h"
#include "cpzeroreg.h"

void uncaught (unsigned int cause, unsigned int status, unsigned int epc,
		unsigned int badvaddr)
{
	/* from cpu.cc */
	static char *const exception_strs[] =
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
	int kernelMode = !(status & Status_KUc_MASK);
	int excCode = (cause & Cause_ExcCode_MASK) >> 2;
	printf ("\nBoot ROM caught %s exception %d (%s) EPC=%x Status=%x "
			"Cause=%x BadVAddr=%x\nHalting\n", kernelMode ? "Kernel" : "User",
			excCode, exception_strs[excCode], epc, status, cause, badvaddr);
}
