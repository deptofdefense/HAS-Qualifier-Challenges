/* Useful constants for MIPS exception codes.
   Copyright 2001 Brian R. Gaeke.

This file is part of VMIPS.

VMIPS is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

VMIPS is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along
with VMIPS; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */

#ifndef _EXCNAMES_H_
#define _EXCNAMES_H_

/* Exceptions - Cause register ExcCode field */
#define Int 0		/* Interrupt */
#define Mod 1		/* TLB modification exception */
#define TLBL 2		/* TLB exception (load or instruction fetch) */
#define TLBS 3		/* TLB exception (store) */
#define AdEL 4		/* Address error exception (load or instruction fetch) */
#define AdES 5		/* Address error exception (store) */
#define IBE 6		/* Instruction bus error */
#define DBE 7		/* Data (load or store) bus error */
#define Sys 8		/* SYSCALL exception */
#define Bp 9		/* Breakpoint exception (BREAK instruction) */
#define RI 10		/* Reserved instruction exception */
#define CpU 11		/* Coprocessor Unusable */
#define Ov 12		/* Arithmetic Overflow */
#define Tr 13		/* Trap (R4k/R6k only) */
#define NCD 14		/* LDCz or SDCz to uncached address (R6k) */
#define VCEI 14		/* Virtual Coherency Exception (instruction) (R4k) */
#define MV 15		/* Machine check exception (R6k) */
#define FPE 15		/* Floating-point exception (R4k) */
/* 16-22 - reserved */
#define WATCH 23	/* Reference to WatchHi/WatchLo address detected (R4k) */
/* 24-30 - reserved */
#define VCED 31		/* Virtual Coherency Exception (data) (R4k) */

#endif /* _EXCNAMES_H_ */
