/*  ../vmips -o noinstdump -o haltdumpcpu -o haltbreak addi.rom */
/*  should end w/ pc=bfc00180, next_epc=bfc00180, and R04=00000001  */
/*  R05=00000003  R06=00000007  R07=00000006  R08=7fffffff */
/*  tests instructions: addi */

	.text
	.globl __start

__start:
	addi $4, $0, 1
	addi $5, $4, 2
	addi $6, $5, 4
	addi $7, $6, 0xffff
	li $8, 0x7fffffff
	addi $8, $8, 0x7fff
	break

	.org 0x180
	break

