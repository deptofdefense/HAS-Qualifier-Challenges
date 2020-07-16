/*  ../vmips -o haltdumpcpu -o haltbreak bc0.rom */
/*  should end with R04=00000001  R05=00000001  R06=00000000 */
/*  tests instructions: bc0f bc0t */

	.text
	.globl __start

__start:
	addiu $4, $0, 0
	addiu $5, $0, 0
	addiu $6, $0, 0
	addiu $4, $0, 1
	bc0f 1f
	addiu $5, $0, 1
1:	bc0t 2f
	addiu $6, $0, 1
2:	break

	.org 0x180
	break

