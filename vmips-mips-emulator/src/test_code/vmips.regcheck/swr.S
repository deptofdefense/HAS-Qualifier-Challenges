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

/* on L.E., memval1 <- aabbccdd; on B.E., memval1 <- dd223344 */
la $2, memval1
swr $8, 0($2)
/* on L.E., memval2 <- bbccdd44; on B.E., memval2 <- ccdd3344 */
la $2, memval2
swr $8, 1($2)
/* on L.E., memval3 <- ccdd3344; on B.E., memval3 <- bbccdd44 */
la $2, memval3
swr $8, 2($2)
/* on L.E., memval4 <- dd223344; on B.E., memval4 <- aabbccdd */
la $2, memval4
swr $8, 3($2)

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

