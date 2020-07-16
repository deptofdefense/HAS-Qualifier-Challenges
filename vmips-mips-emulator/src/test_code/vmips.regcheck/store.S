
.data
word1: .word 0, 0, 0

.text
.globl entry
.ent entry
entry:
	la $2, word1
	li $8, 0x12345678
	sw $8, 0($2)
	sh $8, 4($2)
	sb $8, 8($2)
	lw $8, 0($2)
	lw $9, 4($2)
	lw $10, 8($2)
	jr $31
.end entry
