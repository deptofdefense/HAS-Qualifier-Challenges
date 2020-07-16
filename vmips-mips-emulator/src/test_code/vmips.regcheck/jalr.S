/* tests instructions: jalr */
/* should end with: R04=00000001 R02=00000002 */

.text
.globl __start
.ent __start
__start:
la $8, proc
li $4, 1
li $2, 0
jalr $8
break
.end __start

.globl proc
.ent proc
proc:
addi $2, $4, 1
jr $31
.end proc

