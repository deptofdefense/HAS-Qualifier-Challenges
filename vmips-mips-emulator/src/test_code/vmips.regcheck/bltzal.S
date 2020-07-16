/*  ../vmips -o haltdumpcpu -o haltbreak bltzal.rom */
/*  should end with: R10=00000000 R11=00000000 R12=00000001 */
/*  tests instructions: bltzal */

	.text
	.globl __start
__start:
	li $10, 0
	li $11, 0
	li $12, 0
	li $4, 1
	bltzal $4, foo
	li $4, 0
	bltzal $4, bar
	li $4, -1
	bltzal $4, baz
	break

foo: 
	addiu $10, $10, 1
	jr $31
bar: 
	addiu $11, $11, 1
	jr $31
baz: 
	addiu $12, $12, 1
	jr $31

	.org 0x180
	break

