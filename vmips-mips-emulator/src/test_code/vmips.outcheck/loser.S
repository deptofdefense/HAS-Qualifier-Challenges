/* Using this to test something about what happens when you
 * have an address trans or inst fetch exception w/ delay state NORMAL
 */

	.text
	.globl __start
__start:
a:	addu $0, $0, $0

/* the next instruction just isn't here (bus error on inst fetch).
 * (that's why the makefile has an extra rule for this one -- it
 *  needs not to be page-size-padded, it produces a 4-byte ROM file.)
 * it should cause a fault with EPC = a + 4
 */
