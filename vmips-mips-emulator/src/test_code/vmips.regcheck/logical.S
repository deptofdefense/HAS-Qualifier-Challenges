
.text
.globl __start
.ent __start
__start:
li $2, 0xaaaaaaaa
li $3, 0x55555555

/* $8 <- $2 (0xaaaaaaaa) */
or $8, $0, $2
/* $9 <- $8 | $3 (0xffffffff) */
or $9, $8, $3

/* $10 <- ~$2 (0x55555555) */
nor $10, $0, $2
/* $11 <- ~($10 | $3) (0xaaaaaaaa) */
nor $11, $10, $3

/* $13 <- ($2 & $3) (0x0) */
and $13, $2, $3
/* $14 <- ($2 & $2) == $2 (0xaaaaaaaa) */
and $14, $2, $2

/* $15 <- ~$2  (0x55555555) */
not $15, $2
/* $16 <- ~$0  (0xffffffff) */
not $16, $0

break
.end __start

