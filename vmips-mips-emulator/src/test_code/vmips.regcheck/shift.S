/*  ../vmips -o haltdumpcpu -o haltbreak shift.rom */
/*  should end with R10=00000000 */
/*  tests instructions: sllv srav srl srlv sra */

	.text
	.globl __start
__start:
	addiu $10, $0, 0      /* $10 = count of failures */

	addiu $4, $0, 4       /* $4 = shift amount */
	li $5, 0xa5a5a5a5     /* $5 = test pattern */
	li $6, 0x5a5a5a50     /* $6 = $5 << 4 */
	sllv $7, $5, $4       /* $7 = $5 << 4 */
	beq $7, $6, 1f        /* test result of sllv */
	addiu $10, $10, 1     /* if it doesn't match, fail */

1:	addiu $4, $0, 4       /* $4 = shift amount */
	li $5, 0xa5a5a5a5     /* $5 = test pattern */
	li $6, 0x5a5a5a50     /* $6 = $5 << 4 */
	sll $7, $5, 4         /* $7 = $5 << 4 */
	beq $7, $6, 1f        /* test result of sll */
	addiu $10, $10, 1     /* if it doesn't match, fail */

1:	addiu $4, $0, 4       /* $4 = shift amount */
	li $5, 0xa5a5a5a5     /* $5 = test pattern */
	li $6, 0x0a5a5a5a     /* $6 = $5 >> 4 */
	srlv $7, $5, $4       /* $7 = $5 >> 4 */
	beq $7, $6, 1f        /* test result of srlv */
	addiu $10, $10, 1     /* if it doesn't match, fail */

1:	addiu $4, $0, 4       /* $4 = shift amount */
	li $5, 0xa5a5a5a5     /* $5 = test pattern */
	li $6, 0x0a5a5a5a     /* $6 = $5 >> 4 */
	srl $7, $5, 4         /* $7 = $5 >> 4 */
	beq $7, $6, 1f        /* test result of srl */
	addiu $10, $10, 1     /* if it doesn't match, fail */

1:	addiu $4, $0, 4       /* $4 = shift amount */
	li $5, 0xa5a5a5a5     /* $5 = test pattern */
	li $6, 0xfa5a5a5a     /* $6 = $5 >>> 4 */
	srav $7, $5, $4       /* $7 = $5 >>> 4 */
	beq $7, $6, 1f        /* test result of srav */
	addiu $10, $10, 1     /* if it doesn't match, fail */

1:	addiu $4, $0, 4       /* $4 = shift amount */
	li $5, 0xa5a5a5a5     /* $5 = test pattern */
	li $6, 0xfa5a5a5a     /* $6 = $5 >>> 4 */
	sra $7, $5, 4         /* $7 = $5 >>> 4 */
	beq $7, $6, 1f        /* test result of sra */
	addiu $10, $10, 1     /* if it doesn't match, fail */

1:	break

	.org 0x180
	break
