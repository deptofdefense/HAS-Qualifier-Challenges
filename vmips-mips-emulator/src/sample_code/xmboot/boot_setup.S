/* setup.S
 *
 * A simple kernel to run one function void FUNCTION(void) in uncached,
 * unmapped kernel space. This program should be the first one linked in.
 */
#include "asm_regnames.h"

/* These values should match the values given in ld.script. */
#define MEM_BASE		0xa0000000
#define MEM_SIZE		0x1000000
#define DATA_START		MEM_BASE + (MEM_SIZE*15/16)

#define INIT_STACK_BASE	DATA_START - 4
#define NTLBENTRIES		64
#define FUNCTION 		entry

	.text
	.globl __start

	.ent __start
__start:
	.set noreorder
	/* Here begins the DEC PROM jump table! */
	j reset  /* 0 - reset */
	nop
    jr $31      /* 1 - exec - not implemented */
    nop
    jr $31      /* 2 - restart (halt) - not implemented */
    nop
    jr $31      /* 3 - reinit - not implemented */
    nop
    jr $31      /* 4 - reboot - not implemented */
    nop
    jr $31      /* 5 - autoboot - not implemented */
    nop
    jr $31      /* 6 - open - not implemented */
    nop
    jr $31      /* 7 - read - not implemented */
    nop
    jr $31      /* 8 - write - not implemented */
    nop
    jr $31      /* 9 - ioctl - not implemented */
    nop
    jr $31      /* 10 - close - not implemented */
    nop
    jr $31      /* 11 - lseek - not implemented */
    nop
    j getchar  /* 12 - getchar */
    nop
    j putchar  /* 13 - putchar */
    nop
    jr $31  /* 14 - showchar - not implemented */
    nop
    j gets  /* 15 - gets */
    nop
    j puts  /* 16 - puts */
    nop
    j printf  /* 17 - printf */
    nop
    jr $31  /* 18 - initproto - not used */
    nop
    jr $31  /* 19 - protoenable - not used */
    nop
    jr $31  /* 20 - protodisable - not used */
    nop
    jr $31  /* 21 - getpkt - not used */
    nop
    jr $31  /* 22 - putpkt - not used */
    nop
    jr $31  /* 23 - not used */
    nop
    jr $31  /* 24 - not used */
    nop
    jr $31  /* 25 - not used */
    nop
    jr $31  /* 26 - not used */
    nop
    jr $31  /* 27 - not used */
    nop
    jr $31  /* 28 - flushcache - not used */
    nop
    jr $31  /* 29 - clearcache - not used */
    nop
    jr $31  /* 30 - saveregs - not used */
    nop
    jr $31  /* 31 - loadregs - not used */
    nop
    j lowlevelpanic  /* 32 - jumps8 - user tlb exception vector 0x100 */
    nop
    j getenv  /* 33 - getenv2 */
    nop
    j setenv  /* 34 - setenv2 */
    nop
    j atoi  /* 35 - atonum - implemented as atoi */
    nop
    j strcmp  /* 36 - strcmp */
    nop
    j strlen  /* 37 - strlen */
    nop
    j strcpy  /* 38 - strcpy */
    nop
    j strcat  /* 39 - strcat */
    nop
    jr $31   /* 40 - getcmd - not implemented */
    nop
    jr $31  /* 41 - getnums - not implemented */
    nop
    jr $31  /* 42 - argparse - not implemented */
    nop
    jr $31  /* 43 - help - not implemented */
    nop
    jr $31  /* 44 - dump - not implemented */
    nop
    j setenv  /* 45 - setenv */
    nop
    j unsetenv  /* 46 - unsetenv */
    nop
    j printenv  /* 47 - printenv */
    nop
    j lowlevelpanic  /* 48 - general exception vector 0x180 */
    nop
    jr $31  /* 49 - enable - not implemented */
    nop
    jr $31  /* 50 - disable - not implemented */
    nop
    j printenv  /* 51 - printenv */
    nop
    jr $31  /* 52 - not used */
    nop
    jr $31  /* 53 - not used */
    nop
    jr $31  /* 54 - halt - not implemented */
    nop
	.set reorder
	.end __start

	/* Very simple exception handler for prom exceptions. */
lowlevelpanic:
	mfc0 a0, Cause
	mfc0 a1, Status
	mfc0 a2, EPC
	mfc0 a3, BadVAddr
	jal uncaught /* print a panic message */
1:	j 1b /* loop forever (halt) when we get here. */

	.globl reset
	.ent reset
reset:
/* Start by clearing everything out. */
	.set noat
	move $1, $0
	.set at
	move $2, $0
	move $3, $0
	move $4, $0
	move $5, $0
	move $6, $0
	move $7, $0
	move $8, $0
	move $9, $0
	move $10, $0
	move $11, $0
	move $12, $0
	move $13, $0
	move $14, $0
	move $15, $0
	move $16, $0
	move $17, $0
	move $18, $0
	move $19, $0
	move $20, $0
	move $21, $0
	move $22, $0
	move $23, $0
	move $24, $0
	move $25, $0
	move $26, $0
	move $27, $0
	move $28, $0
	move $29, $0
	move $30, $0
	mtc0 zero, $4
	mtc0 zero, $8
	mtc0 zero, $14

	/* Clear out the TLB. */
	li t2, NTLBENTRIES	/* t2 = TLB entry number */
	li t3, 0x00000fc0	/* t3 = (VPN 0x0, ASID 0x3f) */
1:
	addiu t2, t2, -1	/* Decrement TLB entry number */
	sll t1, t2, 8		/* Shift entry number into Index field position */
	mtc0 t1, $0		/* set Index */
	mtc0 zero, $2		/* clear EntryLo */
	mtc0 t3, $10		/* set EntryHi */
	tlbwi				/* write TLB[Index] with (EntryHi, EntryLo) */
	bnez t2, 1b		/* Go back if we're not done yet. */
	nop
	mtc0 zero, $10		/* clear EntryHi (sets effective ASID=0x0) */

	/* Set up the stack and globals pointer. */
	li sp, INIT_STACK_BASE
	la gp, _gp

	/* Copy writeable data to writeable RAM. */
	la t1, _copystart		/* t1 = beginning source address for copy */
	la t2, _copyend
	addiu t2, t2, 4		/* t2 = one word past ending source address */
	move t3, gp			/* t3 = beginning dest address */
1:
	lw t4, 0(t1)			/* load t4 from ROM */
	sw t4, 0(t3)			/* store it in RAM */
	addiu t1, t1, 4		/* increment both pointers */
	addiu t3, t3, 4
	bne t1, t2, 1b		/* if we're not finished, loop. */
	nop

	/* Call the function. */
	jal FUNCTION

	/* Wait a minute, wait a minute, stop the execution! */
	break 0x0
	.end reset

