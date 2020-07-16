/* Smoketest of data cache isolation */
#include "asm_regnames.h"

/* base + cachesize = base2.
   base and base2 map to the same cache entry. */
#define BASE 0x80001000
#define CACHE_SIZE 0x10000
#define BASE2 (BASE+CACHE_SIZE)

/* cache isolation bit in cp0 status register */
#define ISC 0x10000

		.text

		.globl entry
		.ent entry

entry:
		li	t0, BASE	/* get base into t0 */
		li	t1, BASE2	/* get base2 into t1 */

		/* Do some cached stores */
		sw	t1, 0(t1)	/* store some bits to base2 */
		li	t2, 0x12345678
		sw	t2, 0(t0)	/* store 0x12345678 to base */

		/* Isolate data cache */
		li	t3, ISC
		mfc0	t4, Status
		or	t4, t4, t3
		mtc0	t4, Status

		/* Load word and make sure it is correct */
		lw	t6, 0(t0)	/* Read word back from base */
		/* We should have gotten the word we wrote to base */

		/* Load word from (base + sizeof cache) and make sure
		 * they match (base) */
		lw	t5, 0(t1)	/* Read word back from base2 */
		/* We should have gotten the word we wrote to base */

		/* Un-isolate data cache */
		li	t3, ~ISC
		mfc0	t4, Status
		and	t4, t4, t3
		mtc0	t4, Status

		/* And we're done. */
		jr	ra
		.end entry

