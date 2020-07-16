/*  ../vmips -o haltdumpcpu -o haltbreak mthi_lo.rom */
/*  should end with HI=00000123 LO=00004567 */
/*  tests instructions: mthi mtlo */

	.text
	.globl __start

__start:
	addiu $4, $0, 0x0123
	addiu $5, $0, 0x4567
	mthi $4
	mtlo $5
	break

	.org 0x180
	break

