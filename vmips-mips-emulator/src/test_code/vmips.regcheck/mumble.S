/*  should end with:  all registers equal to their own numbers */
/*  tests instructions: addiu */

	.text
	.globl __start
__start:
	addiu $0, $0, 0
	.set noat
	addiu $1, $0, 1
	.set at
	addiu $2, $0, 2
	addiu $3, $0, 3
	addiu $4, $0, 4
	addiu $5, $0, 5
	addiu $6, $0, 6
	addiu $7, $0, 7
	addiu $8, $0, 8
	addiu $9, $0, 9
	addiu $10, $0, 10
	addiu $11, $0, 11
	addiu $12, $0, 12
	addiu $13, $0, 13
	addiu $14, $0, 14
	addiu $15, $0, 15
	addiu $16, $0, 16
	addiu $17, $0, 17
	addiu $18, $0, 18
	addiu $19, $0, 19
	addiu $20, $0, 20
	addiu $21, $0, 21
	addiu $22, $0, 22
	addiu $23, $0, 23
	addiu $24, $0, 24
	addiu $25, $0, 25
	addiu $26, $0, 26
	addiu $27, $0, 27
	addiu $28, $0, 28
	addiu $29, $0, 29
	addiu $30, $0, 30
	addiu $31, $0, 31
	break

