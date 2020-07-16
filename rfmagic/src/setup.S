/* setup.S
 * A simple routine that initializes the TLB with valid entries describing
 * an identity virtual=>physical mapping, and then run one function, void
 * FUNCTION(void), in uncached, unmapped kernel space. This module should
 * be linked in first, so that __start appears at the reset vector.
 */
#include "asm_regnames.h"

/* These values should match the values given in ld.script. */
#define MEM_BASE		0xa0000000
#define MEM_SIZE		0x200000
#define DATA_START		MEM_BASE + (MEM_SIZE*3/4)

#define INIT_STACK_BASE	(MEM_BASE + (MEM_SIZE*2/4)) - 4
#define NTLBENTRIES		64
#define FUNCTION 		main


	.data
save_at:	.word 0
save_ra:	.word 0
save_v0:	.word 0
save_v1:	.word 0
save_a0:	.word 0
save_a1:	.word 0
save_a2:	.word 0
save_a3:	.word 0
save_t0:	.word 0
save_t1:	.word 0
save_t2:	.word 0
save_t3:	.word 0
save_t4:	.word 0
save_t5:	.word 0
save_t6:	.word 0
save_t7:	.word 0
save_t8:	.word 0
save_t9:	.word 0

	.text
	.globl FUNCTION
	.globl TimerInterrupt
	.globl CIO_ReadInterrupt
	.globl CIO_WriteInterrupt
	.globl __start

	.ent __start
__start:
	j begin
	.end __start

	/* Halt on user tlb exceptions. */
	.org 0x100
	break 0x0

	/* Halt on exceptions. */
	.org 0x180
intrp:
	# Save EPC
	mfc0	k1,EPC
	nop

	# Save registers
	.set noat
	lui	k0, 0xa018
	sw	$1, 0(k0)
	.set at
	sw	v0, save_v0
	sw	v1, save_v1
	sw	a0, save_a0
	sw	a1, save_a1
	sw	a2, save_a2
	sw	a3, save_a3
	sw	t0, save_t0
	sw	t1, save_t1
	sw	t2, save_t2
	sw	t3, save_t3
	sw	t4, save_t4
	sw	t5, save_t5
	sw	t6, save_t6
	sw	t7, save_t7
	sw	t8, save_t8
	sw	t9, save_t9	
	sw	ra, save_ra
	
intrp_dispatch:
	# Get cause of exception
	mfc0 	k0, $13
	srl	a0, k0, 2
	andi	a0, a0, 0x1f

	# Check for interrupt
	bnez	a0, non_interrupt
	nop

	# Check which interrupt -- if all 0's then done
	beqz	k0, intrp_done

	and	a0, k0, 0x8000
	bnez	a0, timer_interrupt_handler

	and	a0, k0, 0x1000
	bnez	a0, uart2_read_interrupt_handler

	and	a0, k0, 0x2000
	bnez	a0, uart2_write_interrupt_handler
	
	nop
	j	intrp_done
	nop

uart2_read_interrupt_handler:
	jal	CIO_ReadInterrupt
	nop
	j	intrp_dispatch
	nop

uart2_write_interrupt_handler:
	jal	CIO_WriteInterrupt
	nop
	j	intrp_dispatch
	nop

timer_interrupt_handler:
	# In an interrupt
	jal TimerInterrupt
	nop
	j	intrp_dispatch
	nop

intrp_done:
	# Restore
	lw	v0, save_v0
	lw	v1, save_v1
	lw	a0, save_a0
	lw	a1, save_a1
	lw	a2, save_a2
	lw	a3, save_a3
	lw	t0, save_t0
	lw	t1, save_t1
	lw	t2, save_t2
	lw	t3, save_t3
	lw	t4, save_t4
	lw	t5, save_t5
	lw	t6, save_t6
	lw	t7, save_t7
	lw	t8, save_t8
	lw	t9, save_t9	
	lw	ra, save_ra
	
	.set noat
	lui	k0, 0xa018
	lw	$1, 0(k0)
	.set at

	# Re-enable interrupts
	mfc0	k0, $12
	nop
	ori	k0, 0x8001
	#mtc0	k0, $12
        #mfc0 k0, Status
        #ori k0, k0, 0x8001              /* IM7 and IEc */
        #mtc0 k0, Status

	# Return from interrupt
	nop
	rfe	
	jr	k1
	nop

non_interrupt:
	break 0x0

	.org 0x400
	.globl begin
	.ent begin
begin:
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
	mtc0 zero, Context
	mtc0 zero, BadVAddr
	mtc0 zero, EPC

	/* Initialize the TLB. */
	li t2, NTLBENTRIES	/* t2 = TLB entry number */
	li t3, 0x00000000	/* t3 = (VPN 0x0, ASID 0x00) */
	li t4, 0x00000700	/* t4 = (PFN 0x0, D V G) */
1:
	addiu t2, t2, -1	/* Decrement TLB entry number */
	sll t1, t2, 8		/* Shift entry number into Index field position */
	mtc0 t1, Index		/* set Index */
	mtc0 t4, EntryLo	/* clear EntryLo */
	mtc0 t3, EntryHi	/* set EntryHi */
	tlbwi			/* write TLB[Index] with (EntryHi, EntryLo) */
	addiu t3, t3, 0x1000	/* Increment VPN */
	addiu t4, t4, 0x1000	/* Increment PFN */
	bnez t2, 1b		/* Go back if we're not done yet. */
	nop
	mtc0 zero, EntryHi	/* clear EntryHi (sets effective ASID=0x0) */

	/* Set up the stack and globals pointer. */
	li sp, INIT_STACK_BASE
	la gp, _gp

	/* Copy writeable data to writeable RAM. */
	la t1, _copystart	/* t1 = beginning source address for copy */
	la t2, _copyend
	//addiu t2, t2, 4		/* t2 = one word past ending source address */
	move t3, gp		/* t3 = beginning dest address */
1:
	lw t4, 0(t1)		/* load t4 from ROM */
	sw t4, 0(t3)		/* store it in RAM */
	addiu t1, t1, 4		/* increment both pointers */
	addiu t3, t3, 4
	bne t1, t2, 1b		/* if we're not finished, loop. */
	nop

	/* Turn interrupts on in the CP0. */
        //mfc0 a0, Status
        //ori a0, a0, 0x8001              /* IM7 and IEc */
        //mtc0 a0, Status

	/* Call the function. */
	jal FUNCTION

	/* Wait a minute, wait a minute, stop the execution! */
	break 0x0
	.end begin

