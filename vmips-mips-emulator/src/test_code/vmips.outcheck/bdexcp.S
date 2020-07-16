
	.text
	.globl __start
__start:
/* It should perhaps be made explicit that these next two instructions must
 * result in exactly two instructions in the output, otherwise the expected
 * EPC will not check out and the test will fail. Hence, noreorder and nomacro.
 */
	.set noreorder
	.set nomacro
	addiu $3, $0, -1
	addiu $2, $0, 1
	beq $2, $2, loozer
	lw $0, 0($3) /* cause a branch delay slot bus error */
loozer: 
	break

