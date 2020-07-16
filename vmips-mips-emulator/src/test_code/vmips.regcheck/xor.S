	.text
	.globl __start
__start:
	addiu $10, $0, 0
	li $4, 0xaaaaaaaa 
	li $5, 0x55555555
	li $6, 0xffffffff
	li $8, 0xaaaaffff
	li $9, 0x5555aaaa
	xor $7, $4, $5
	beq $7, $6, 1f
	addiu $10, $10, 1
1:	xor $7, $5, $6
	beq $7, $4, 2f
	addiu $10, $10, 1
2:	xor $7, $4, $4
	beq $7, $0, 3f
	addiu $10, $10, 1
3:	xori $7, $4,0x5555 
	beq $7, $8, 4f
	addiu $10, $10, 1
4:	xori $7, $5,0xffff
	beq $7, $9, 5f
	addiu $10, $10, 1
5:	break
	.org 0x180
	break
