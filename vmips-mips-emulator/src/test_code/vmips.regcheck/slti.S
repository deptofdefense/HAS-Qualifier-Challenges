/* should end with R08=ffffffff R10=00000001 R11=00000000 */
.text
.globl __start
.ent __start
__start:
li $8, -1 
/* $10 should get 1 , because -1 < 0 */
slti $10, $8, 0
/* $11 should get 0, because ffffffff > 0 */
sltiu $11, $8, 0
break
.end __start
.org 0x180
break

