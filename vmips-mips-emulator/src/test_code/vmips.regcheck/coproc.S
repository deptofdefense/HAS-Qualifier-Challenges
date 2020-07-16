/*  ../vmips -o haltdumpcpu -o haltbreak coproc.rom */
/*  tests instructions: lwc2 lwc3 swc2 swc3 */
/*  (in the case where they are all unimplemented, that is) */
/*  should end with:  R10=01010102  R11=02020203  R12=03030304 */
/*  The trick here is to write an exception handler that simulates */
/*  the intended effect of the unimplemented instructions. Here, the */
/*  main cpu registers are used instead of the coprocessor registers */
/*  to do the load. */
#include "asm_regnames.h"

/* These values should match the values given in ld.script. */
#define MEM_BASE		0xa0000000
#define MEM_SIZE		0x100000
#define DATA_START		MEM_BASE + (MEM_SIZE*3/4)

#define INIT_STACK_BASE	DATA_START - 4
#define NTLBENTRIES		64

	.data
second: .word 0x02020202
third: .word 0x03030303

	.text
	.globl __start
	.ent __start
__start:
	/* Clear out the TLB. */
	li t2, NTLBENTRIES	/* t2 = TLB entry number */
1:
	addiu t2, t2, -1	/* Decrement TLB entry number */
	sll t1, t2, 8		/* Shift entry number into Index field position */
	mtc0 t1, $0		/* set Index */
	mtc0 zero, $2		/* clear EntryHi */
	mtc0 zero, $10		/* clear EntryLo */
	tlbwi				/* write TLB[Index] with (EntryHi, EntryLo) */
	bnez t2, 1b		/* Go back if we're not done yet. */
	nop

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

	la a1,  second
	la a2,  third
	lwc2 $11, 0(a1)
	lwc3 $12, 0(a2)
	addiu $11, $11, 1 
	addiu $12, $12, 1 
	swc2 $11, 0(a1)
	swc3 $12, 0(a2)
	lw $11, 0(a1)
	lw $12, 0(a2)

	break 0x0
	.end __start

	.org 0x180

	mfc0 k0, $14         /* k0 <- EPC */
	mfc0 k1, $13         /* k1 <- Cause */
    addiu sp, sp, -128    /* get some stack */
    /* sw $0, 0(sp) */
    /* sw $1, 4(sp) */
    sw $2, 8(sp)
    sw $3, 12(sp)
    sw $4, 16(sp)
    sw $5, 20(sp)
    sw $6, 24(sp)
    sw $7, 28(sp)
    sw $8, 32(sp)
    sw $9, 36(sp)
    sw $10, 40(sp)
    sw $11, 44(sp)
    sw $12, 48(sp)
    sw $13, 52(sp)
    sw $14, 56(sp)
    sw $15, 60(sp)
    sw $16, 64(sp)
    sw $17, 68(sp)
    sw $18, 72(sp)
    sw $19, 76(sp)
    sw $20, 80(sp)
    sw $21, 84(sp)
    sw $22, 88(sp)
    sw $23, 92(sp)
    sw $24, 96(sp)
    sw $25, 100(sp)
    sw $26, 104(sp)
    sw $27, 108(sp)
    sw $28, 112(sp)
    sw $29, 116(sp)
    sw $30, 120(sp)
    sw $31, 124(sp)
    andi k1, k1, 0x007c  /* mask out exccode */
    srl k1, k1, 2        /* shift it */
    li  t0, 11           /* t0 <- CpU */
    beq t0, k1, cpuexcp  /* if we don't know how to handle it, bail */
    break                /* halt here if we get an unknown exception. */
cpuexcp:
    lw t0, 0(k0)         /* get offending instruction word */
    srl t1, t0, 26       /* shift down opcode */
    andi t1, t1, 0x03f   /* mask it */
    srl t3, t0, 21
    andi t3, t3, 0x01f   /* get rs field  into t3 */
    sll t3, t3, 2        /* multiply it by 4 */
    addu t3, t3, sp      /* offset from top of stack */
    lw t3, 0(t3)         /* get base address into t3 */
    sll t4, t0, 16
    sra t4, t4, 16       /* get signed immediate into t4 */
    addu t3, t3, t4      /* add offset to base address, result in t3 */
    srl t4, t0, 16
    andi t4, t4, 0x01f   /* get rt field into t4 */
    sll t4, t4, 2        /* multiply it by 4 */
    addu t4, t4, sp      /* offset from top of stack */
    /* li t2, 49 */           /* test various opcodes we know */
    /* beq t1, t2, load */    /* lwc1 */
    li t2, 50
    beq t1, t2, load     /* lwc2 */
    li t2, 51
    beq t1, t2, load     /* lwc3 */
    /* li t2, 57 */
    /* beq t1, t2, store */   /* swc1 */
    li t2, 58
    beq t1, t2, store    /* swc2 */
    li t2, 59
    beq t1, t2, store    /* swc3 */
    break                /* halt here if we get an unknown opcode. */
load:
    lw t3, 0(t3)         /* do the load */
    sw t3, 0(t4)         /* store result into the right register */
    b finish
store:
    lw t4, 0(t4)         /* get data item to store */
    sw t4, 0(t3)         /* do the store */
finish:
    lw $31, 124(sp)
    lw $30, 120(sp)
    lw $29, 116(sp)
    lw $28, 112(sp)
    lw $27, 108(sp)
    lw $26, 104(sp)
    lw $25, 100(sp)
    lw $24, 96(sp)
    lw $23, 92(sp)
    lw $22, 88(sp)
    lw $21, 84(sp)
    lw $20, 80(sp)
    lw $19, 76(sp)
    lw $18, 72(sp)
    lw $17, 68(sp)
    lw $16, 64(sp)
    lw $15, 60(sp)
    lw $14, 56(sp)
    lw $13, 52(sp)
    lw $12, 48(sp)
    lw $11, 44(sp)
    lw $10, 40(sp)
    lw $9, 36(sp)
    lw $8, 32(sp)
    lw $7, 28(sp)
    lw $6, 24(sp)
    lw $5, 20(sp)
    lw $4, 16(sp)
    lw $3, 12(sp)
    lw $2, 8(sp)
    /* lw $1, 4(sp) */
    /* lw $0, 0(sp) */
    addiu sp, sp, 128     /* restore stack */
    addiu k0, k0, 4       /* set return pt to instruction following excp. */ 
    rfe                   /* restore status bits */
    jr k0                 /* return. */

