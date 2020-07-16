/*  ../vmips -o haltdumpcpu -o haltbreak bgezal.rom */
/*  should end with: R10=00000001 R11=00000001 R12=00000000 */
/*  tests instructions: bgezal */

	.text
	.globl __start
__start:
	li $10, 0
	li $11, 0
	li $12, 0
	li $4, 1
	bgezal $4, foo
	li $4, 0
	bgezal $4, bar
	li $4, -1
	bgezal $4, baz
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

