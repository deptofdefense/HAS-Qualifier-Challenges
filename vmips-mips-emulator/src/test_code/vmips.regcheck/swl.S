.data
memval1: .word 0x11223344
memval2: .word 0x11223344
memval3: .word 0x11223344
memval4: .word 0x11223344

.text
.globl entry
.ent entry
entry:

/* Load the address of the "memory" value into $2 */
la $2, memval1
/* Put the same value (the "register" value) in regs $8 - $11 */
li $8, 0xaabbccdd

/* on L.E., memval1 <- 112233aa; on B.E., memval1 <- aabbccdd */
la $2, memval1
swl $8, 0($2)
/* on L.E., memval2 <- 1122aabb; on B.E., memval2 <- 11aabbcc */
la $2, memval2
swl $8, 1($2)
/* on L.E., memval3 <- 11aabbcc; on B.E., memval3 <- 1122aabb */
la $2, memval3
swl $8, 2($2)
/* on L.E., memval4 <- aabbccdd; on B.E., memval4 <- 112233aa */
la $2, memval4
swl $8, 3($2)

/* Load the results back into registers, for the benefit of regcheck. */
la $2, memval1
lw $9, 0($2)
la $2, memval2
lw $10, 0($2)
la $2, memval3
lw $11, 0($2)
la $2, memval4
lw $12, 0($2)

jr $31
.end entry

