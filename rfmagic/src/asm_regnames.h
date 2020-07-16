#ifndef __asm_regnames_h__
#define __asm_regnames_h__

/* Special names */
#define zero $0	/* always zero */
/*#define at $1	(* assembler temporary *) */
/* above conflicts with the .set at assembler directive. just use $1 instead */
#define v0 $2	/* function values */
#define v1 $3
#define a0 $4	/* function arguments */
#define a1 $5
#define a2 $6
#define a3 $7
#define t0 $8	/* temporary registers; not preserved across func calls */
#define t1 $9
#define t2 $10
#define t3 $11
#define t4 $12
#define t5 $13
#define t6 $14
#define t7 $15
#define s0 $16	/* "saved" regs - must preserve these if you use them */
#define s1 $17
#define s2 $18
#define s3 $19
#define s4 $20
#define s5 $21
#define s6 $22
#define s7 $23
#define t8 $24	/* more temporary regs */
#define t9 $25
#define k0 $26	/* kernel temporary variables */
#define kt0 $26
#define k1 $27
#define kt1 $27
#define gp $28	/* pointer to globals */
#define sp $29	/* stack pointer */
#define s8 $30	/* another "saved" reg */
#define ra $31	/* return address */

/* FPU register names - included for a consistent appearance */
#define f0 $f0
#define f1 $f1
#define f2 $f2
#define f3 $f3
#define f4 $f4
#define f5 $f5
#define f6 $f6
#define f7 $f7
#define f8 $f8
#define f9 $f9
#define f10 $f10
#define f11 $f11
#define f12 $f12
#define f13 $f13
#define f14 $f14
#define f15 $f15
#define f16 $f16
#define f17 $f17
#define f18 $f18
#define f19 $f19
#define f20 $f20
#define f21 $f21
#define f22 $f22
#define f23 $f23
#define f24 $f24
#define f25 $f25
#define f26 $f26
#define f27 $f27
#define f28 $f28
#define f29 $f29
#define f30 $f30
#define f31 $f31

/* CP0 reg names - these pertain to address translation and
 * exception handling, and not all of them are implemented on the
 * R3000. (But they have such cool names...)
 */
#define Index $0     /* selects TLB entry for r/w ops & shows probe success */ 
#define Random $1    /* continuously decrementing number (range 8..63) */
#define EntryLo $2   /* low word of a TLB entry */
#define EntryLo0 $2  /* R4k uses this for even-numbered virtual pages */
#define EntryLo1 $3  /* R4k uses this for odd-numbered virtual pages */
#define Context $4   /* TLB refill handler's kernel PTE entry pointer */
#define PageMask $5  /* R4k page number bit mask (impl. variable page sizes) */
#define Wired $6     /* R4k lower bnd for Random (controls randomness of TLB) */
#define Error $7     /* R6k status/control register for parity checking */
#define BadVAddr $8  /* "bad" virt. addr (VA of last failed v->p translation) */
#define Count $9     /* R4k r/w reg - continuously incrementing counter */
#define EntryHi $10  /* High word of a TLB entry */
#define ASID $10     /* R6k uses this to store the ASID (only) */
#define Compare $11  /* R4k traps when this register equals Count */
#define Status $12   /* Kernel/User mode, interrupt enb., & diagnostic states */
#define Cause $13    /* Cause of last exception */
#define EPC $14      /* Address to return to after processing this exception */
#define PRId $15     /* Processor revision identifier */
#define Config $16   /* R4k config options for caches, etc. */
#define LLAdr $17    /* R4k last instruction read by a Load Linked */
#define LLAddr $17   /* Inconsistencies in naming... sigh. */
#define WatchLo $18  /* R4k hardware watchpoint data */
#define WatchHi $19  /* R4k hardware watchpoint data */
/* 20-25 - reserved */
#define ECC $26      /* R4k cache Error Correction Code */
#define CacheErr $27 /* R4k read-only cache error codes */
#define TagLo $28    /* R4k primary or secondary cache tag and parity */
#define TagHi $29    /* R4k primary or secondary cache tag and parity */
#define ErrorEPC $30 /* R4k cache error EPC */
/* 31 - reserved */

/* Exceptions - Cause register ExcCode field */
#define Int 0		/* Interrupt */
#define Mod 1		/* TLB modification exception */
#define TLBL 2		/* TLB exception (load or instruction fetch) */
#define TLBS 3		/* TLB exception (store) */
#define AdEL 4		/* Address error exception (load or instruction fetch) */
#define AdES 5		/* Address error exception (store) */
#define IBE 6		/* Instruction bus error */
#define DBE 7		/* Data (load or store) bus error */
#define Sys 8		/* SYSCALL exception */
#define Bp 9		/* Breakpoint exception (BREAK instruction) */
#define RI 10		/* Reserved instruction exception */
#define CpU 11		/* Coprocessor Unusable */
#define Ov 12		/* Arithmetic Overflow */
#define Tr 13		/* Trap (R4k/R6k only) */
#define NCD 14		/* LDCz or SDCz to uncached address (R6k) */
#define VCEI 14		/* Virtual Coherency Exception (instruction) (R4k) */
#define MV 15		/* Machine check exception (R6k) */
#define FPE 15		/* Floating-point exception (R4k) */
/* 16-22 - reserved */
#define WATCH 23	/* Reference to WatchHi/WatchLo address detected (R4k) */
/* 24-30 - reserved */
#define VCED 31		/* Virtual Coherency Exception (data) (R4k) */

#endif /* __asm_regnames_h__ */
