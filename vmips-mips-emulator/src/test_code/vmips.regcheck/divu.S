/* tests instructions: div, divu */
.text
.globl __start
.set noreorder
__start:
li $8, 0xffffffff
.set nomacro
li $9, 0xf
div $0,$8, $9
/* $10 <- signed quotient (0x0) */
mflo $10
/* $11 <- signed remainder (0xe) */
mfhi $11
divu $0,$8, $9
/* $12 <- unsigned quotient (0x11111111) */
mflo $12
/* $13 <- unsigned remainder (0x0) */
mfhi $13
break
