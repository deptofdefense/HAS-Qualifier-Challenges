
/* This doesn't test overflow exceptions; exception.S does that. */
.text
.globl __start
.ent __start
__start:
li $2, -1
li $3, 1
add $8, $3, $2
add $9, $3, $0
add $10, $3, $3
add $11, $2, $2
add $12, $2, $0
add $13, $0, $0
break
.end __start

