/* Smoketest of cache swapping + isolation (reading/invalidating icache) */
#include "asm_regnames.h"

/* base + cachesize = base2.
   base and base2 map to the same cache entry. */
#define BASE 0x80001000
#define CACHE_SIZE 0x10000
#define BASE2 (BASE+CACHE_SIZE)

/* Size of a single I-Cache entry */
#define ENTRY_SIZE 4

/* Cache isolation bit in cp0 status register */
#define ISC 0x10000

/* Cache swap bit in cp0 status register */
#define SWC 0x20000

		.text

		.macro	IsolateAndSwap
		/* Turn Isolate + swap cache bits ON */
		li	t3, (ISC|SWC)
		mfc0	t4, Status
		or	t4, t4, t3
		mtc0	t4, Status
		.endm

/*---------------------------------------------------------------------------*/

		.macro	UnIsolateAndSwap
		/* Turn Isolate + swap cache bits OFF */
		li	t3, ~(ISC|SWC)
		mfc0	t4, Status
		and	t4, t4, t3
		mtc0	t4, Status
		.endm

/*---------------------------------------------------------------------------*/

		.globl ClearICache
		.ent ClearICache
ClearICache:
		/* Isolate/swap caches */
		IsolateAndSwap

		/* Start at addr == 0. */
		li	t0, 0
		li	t1, CACHE_SIZE

		/* Invalidate 4 cache entries at addr. */
		/* We assume CACHE_SIZE is divisible by 4*ENTRY_SIZE */
	2:	sb	zero, 0(t0)
	  	sb	zero, 4(t0)
	  	sb	zero, 8(t0)
	  	sb	zero, 12(t0)

		/* Increment addr by the size of 4 cache entries. */
		addi	t0, t0, (4*ENTRY_SIZE)

		/* If we have more left to do, then loop. */
		bne	t1, t0, 2b

		/* Un-isolate/swap caches */
		UnIsolateAndSwap

		/* And return */
		jr	ra
		.end ClearICache

/*---------------------------------------------------------------------------*/

		.globl VerySimpleRoutine
		.ent VerySimpleRoutine
		.set noreorder
VerySimpleRoutine:
		addi	s3, zero, 3		/* s3 = 3 */
		addi	s4, zero, 4		/* s4 = 4 */
		jr	ra			/* And return. */
		nop
		.set reorder
		.end VerySimpleRoutine

/*---------------------------------------------------------------------------*/

		.globl entry
		.ent entry
entry:
		/* Save return address */
		move	s0, ra

		/* Clear I-Cache */
		jal	ClearICache

		/* Copy VerySimpleRoutine to cached RAM at address BASE */
		/* Assume it is 16 bytes */
		li	s1, BASE
		li	s2, BASE+16
		la	t0, VerySimpleRoutine
	1:	lw	t1, 0(t0)
		sw	t1, 0(s1)
		addiu	t0, t0, 4
		addiu	s1, s1, 4
		bne	s1, s2, 1b

		/* Call VerySimpleRoutine in cached RAM */
		/* This will load some predictable words into the I-Cache */
		/* which is otherwise empty. */
		li	s1, BASE
		jalr	s1

		/* s2 = BASE2 */
		li	s2, BASE2

		/* Isolate/swap caches */
		IsolateAndSwap

		/* Read words from BASE2 into registers */
		/* to make sure they are correct. */
		lw	t5, 0(s2)
		lw	t6, 4(s2)
		lw	t7, 8(s2)
		lw	t8, 12(s2)

		/* Un-isolate/swap caches */
		UnIsolateAndSwap

		/* Restore return address */
		move	ra, s0

		/* And return. */
		jr	ra
		.end entry
