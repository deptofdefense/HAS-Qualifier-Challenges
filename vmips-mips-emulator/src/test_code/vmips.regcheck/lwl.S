

.text
.globl __start
.ent __start
__start:

/* Load the address of the "memory" value into $2 */
la $2, memval
/* Put the same value (the "register" value) in regs $8 - $11 */
li $8, 0xaabbccdd
li $9, 0xaabbccdd
li $10, 0xaabbccdd
li $11, 0xaabbccdd
/* on L.E.,  $8 <- 44bbccdd; on B.E.,  $8 <- 11223344 */
lwl $8, 0($2)
/* on L.E.,  $9 <- 3344ccdd; on B.E.,  $9 <- 223344dd */
lwl $9, 1($2)
/* on L.E., $10 <- 223344dd; on B.E., $10 <- 3344ccdd */
lwl $10, 2($2)
/* on L.E., $11 <- 11223344; on B.E., $11 <- 44bbccdd */
lwl $11, 3($2)
break
.end __start
memval: .word 0x11223344

