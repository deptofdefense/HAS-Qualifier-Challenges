/*  ../vmips -o noinstdump -o haltdumpcpu -o haltbreak sub.rom */
/*  should end w/ pc=bfc00180, next_epc=bfc00180, and R04=00000001      */
/*  R05=ffffffff  R06=00000000  R07=00000002  R08=80000001 R09=7fffffff */
/*  R10=00000002  R11=fffffffe  R12=00000000  R13=fffffffe R14=00000000 */
/*  tests instructions: sub */

	.text
	.globl __start

__start:
	addi $4, $0, 1
	addi $5, $0, -1
	addi $6, $0, 0

	sub $7, $4, $5   /* $7 <- 2  POS - NEG */
	sub $13, $5, $4   /* $13 <- -2  NEG - POS */
	sub $14, $4, $4   /* $14 <- 0  POS - POS */

    subu $10, $4, $5 /* $10 <- 2 */
    subu $11, $5, $4 /* $11 <- -2 */
    subu $12, $4, $4 /* $12 <- 0 */

	li $8, 0x80000001
	li $9, 0x7fffffff
	sub $8, $8, $9
	break

	.org 0x180
	break

