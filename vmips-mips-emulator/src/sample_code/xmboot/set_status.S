#include "asm_regnames.h"


.globl get_status
.ent get_status
get_status:
	mfc0 v0, Status
	jr ra
.end get_status

.globl set_status
.ent set_status
set_status:
	mtc0 a0, Status
	jr ra
.end set_status

.globl get_cause
.ent get_cause
get_cause:
	mfc0 v0, Cause
	jr ra
.end get_cause

.globl set_cause
.ent set_cause
set_cause:
	mtc0 a0, Cause
	jr ra
.end set_cause


