/*  ../vmips -o haltdumpcpu -o haltbreak bltz.rom */
/*  should end with: R10=00000001 R11=00000001 R12=00000000 */
/*  tests instructions: bltz */

	.text
	.globl __start
__start:
	li $10, 0
	li $11, 0
	li $12, 0
	li $4, 1
	bltz $4, 1f
	addiu $10, $10, 1
1:	li $4, 0
	bltz $4, 2f
	addiu $11, $11, 1
2:	li $4, -1
	bltz $4, 3f
	addiu $12, $12, 1
3:	break

	.org 0x180
	break

