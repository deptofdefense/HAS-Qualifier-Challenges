/* Useful constants for system control coprocessor registers.
   Copyright 2001, 2002 Brian R. Gaeke.

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

#ifndef _CPZEROREG_H_
#define _CPZEROREG_H_

/* Constants for virtual address translation.
 *
 * Some of these are used as masks and some are used as constant
 * translations (i.e., the address of something is the address of
 * something else plus or minus a translation). The desired effect is
 * to reduce the number of random "magic numbers" floating around...
 */

#define KSEG_SELECT_MASK 0xe0000000 /* bits of address which determine seg. */
#define KUSEG 0            /* not really a mask, but user space begins here */
#define KERNEL_SPACE_MASK 0x80000000           /* beginning of kernel space */
#define KSEG0 0x80000000     /* beginning of unmapped cached kernel segment */
#define KSEG0_CONST_TRANSLATION 0x80000000 /* kseg0 v->p address difference */
#define KSEG1 0xa0000000   /* beginning of unmapped uncached kernel segment */
#define KSEG1_CONST_TRANSLATION 0xa0000000 /* kseg1 v->p address difference */
#define KSEG2 0xc0000000       /* beginning of mapped cached kernel segment */
#define KSEG2_top 0xe0000000    /* 2nd half of mapped cached kernel segment */

/* CP0 register names and masks
 *
 * A table of names for CP0's registers follows. After that follow a
 * series of masks by which fields of these registers can be isolated.
 * The masks are convenient for Boolean flags but are slightly less so
 * for numbers being extracted from the middle of a word because they
 * still need to be shifted. At least, it makes clear which field is
 * being accessed, and the bit numbers are clearly indicated in every mask
 * below.  The naming convention is as follows: Mumble is the name of some
 * CP0 register, Mumble_MASK is the bit mask which controls reading and
 * writing of the register (0 -> bit is always zero and ignores writes,
 * 1 -> normal read/write) and Mumble_Field_MASK is the mask used to
 * access the "Field" portion of register Mumble. For more information
 * on these fields consult "MIPS RISC Architecture", chapters 4 and 6.
 */

#define Index 0		/* selects TLB entry for r/w ops & shows probe success */ 
#define Random 1	/* continuously decrementing number (range 8..63) */
#define EntryLo 2	/* low word of a TLB entry */
#define EntryLo0 2	/* R4k uses this for even-numbered virtual pages */
#define EntryLo1 3	/* R4k uses this for odd-numbered virtual pages */
#define Context 4	/* TLB refill handler's kernel PTE entry pointer */
#define PageMask 5	/* R4k page number bit mask (impl. variable page sizes) */
#define Wired 6		/* R4k lower bnd for Random (controls randomness of TLB) */
#define Error 7		/* R6k status/control register for parity checking */
#define BadVAddr 8	/* "bad" virt. addr (VA of last failed v->p translation) */
#define Count 9		/* R4k r/w reg - continuously incrementing counter */
#define EntryHi 10	/* High word of a TLB entry */
#define ASID 10		/* R6k uses this to store the ASID (only) */
#define Compare 11	/* R4k traps when this register equals Count */
#define Status 12	/* Kernel/User mode, interrupt enb., & diagnostic states */
#define Cause 13	/* Cause of last exception */
#define EPC 14		/* Address to return to after processing this exception */
#define PRId 15		/* Processor revision identifier */
#define Config 16	/* R4k config options for caches, etc. */
#define LLAdr 17	/* R4k last instruction read by a Load Linked */
#define LLAddr 17	/* Inconsistencies in naming... sigh. */
#define WatchLo 18	/* R4k hardware watchpoint data */
#define WatchHi 19	/* R4k hardware watchpoint data */
/* 20-25 - reserved */
#define ECC 26		/* R4k cache Error Correction Code */
#define CacheErr 27	/* R4k read-only cache error codes */
#define TagLo 28	/* R4k primary or secondary cache tag and parity */
#define TagHi 29	/* R4k primary or secondary cache tag and parity */
#define ErrorEPC 30	/* R4k cache error EPC */
/* 31 - reserved */

/* (0) Index fields */
#define Index_P_MASK 0x80000000         /* Last TLB Probe instr failed (31) */
#define Index_Index_MASK 0x00003f00  /* TLB entry to read/write next (13-8) */
#define Index_MASK 0x80003f00

/* (1) Random fields */
#define Random_Random_MASK 0x00003f00   /* TLB entry to replace next (13-8) */
#define Random_MASK 0x00003f00
/* Random register upper and lower bounds (R3000) */
#define Random_UPPER_BOUND 63
#define Random_LOWER_BOUND 8

/* (2) EntryLo fields */
#define EntryLo_PFN_MASK 0xfffff000            /* Page frame number (31-12) */
#define EntryLo_N_MASK 0x00000800                      /* Noncacheable (11) */
#define EntryLo_D_MASK 0x00000400                             /* Dirty (10) */
#define EntryLo_V_MASK 0x00000200                              /* Valid (9) */
#define EntryLo_G_MASK 0x00000100                             /* Global (8) */
#define EntryLo_MASK 0xffffff00

/* (4) Context fields */
#define Context_PTEBase_MASK 0xffe00000          /* Page Table Base (31-21) */
#define Context_BadVPN_MASK 0x001ffffc      /* Bad Virtual Page num. (20-2) */
#define Context_MASK 0xfffffffc

/* (5) PageMask is only on the R4k */
#define PageMask_MASK 0x00000000

/* (6) Wired is only on the R4k */
#define Wired_MASK 0x00000000

/* (7) Error is only on the R6k */
#define Error_MASK 0x00000000

/* (8) BadVAddr has only one field */
#define BadVAddr_MASK 0xffffffff

/* (9) Count is only on the R4k */
#define Count_MASK 0x00000000

/* (10) EntryHi fields */
#define EntryHi_VPN_MASK 0xfffff000             /* Virtual page no. (31-12) */
#define EntryHi_ASID_MASK 0x00000fc0                 /* Current ASID (11-6) */
#define EntryHi_MASK 0xffffffc0

/* (11) Compare is only on the R4k */
#define Compare_MASK 0x00000000

/* (12) Status fields */
#define Status_CU_MASK 0xf0000000      /* Coprocessor (3..0) Usable (31-28) */
#define Status_CU3_MASK 0x80000000             /* Coprocessor 3 Usable (31) */
#define Status_CU2_MASK 0x40000000             /* Coprocessor 2 Usable (30) */
#define Status_CU1_MASK 0x20000000             /* Coprocessor 1 Usable (29) */
#define Status_CU0_MASK 0x10000000             /* Coprocessor 0 Usable (28) */
#define Status_RE_MASK 0x02000000     /* Reverse Endian (R3000A/R6000) (25) */
#define Status_DS_MASK 0x01ff0000              /* Diagnostic Status (24-16) */
#define Status_DS_BEV_MASK 0x00400000    /* Bootstrap Exception Vector (22) */
#define Status_DS_TS_MASK 0x00200000                   /* TLB Shutdown (21) */
#define Status_DS_PE_MASK 0x00100000             /* Cache Parity Error (20) */
#define Status_DS_CM_MASK 0x00080000                     /* Cache miss (19) */
#define Status_DS_PZ_MASK 0x00040000    /* Cache parity forced to zero (18) */
#define Status_DS_SwC_MASK 0x00020000      /* Data/Inst cache switched (17) */
#define Status_DS_IsC_MASK 0x00010000                /* Cache isolated (16) */
#define Status_IM_MASK 0x0000ff00                  /* Interrupt Mask (15-8) */
#define Status_IM_Ext_MASK 0x0000fc00 /* Extrn. (HW) Interrupt Mask (15-10) */
#define Status_IM_SW_MASK 0x00000300       /* Software Interrupt Mask (9-8) */
#define Status_KU_IE_MASK 0x0000003f /* Kernel/User & Int Enable bits (5-0) */
#define Status_KUo_MASK 0x00000020            /* Old Kernel/User status (5) */
#define Status_IEo_MASK 0x00000010       /* Old Interrupt Enable status (4) */
#define Status_KUp_MASK 0x00000008       /* Previous Kernel/User status (3) */
#define Status_IEp_MASK 0x00000004  /* Previous Interrupt Enable status (2) */
#define Status_KUc_MASK 0x00000002        /* Current Kernel/User status (1) */
#define Status_IEc_MASK 0x00000001   /* Current Interrupt Enable status (0) */
#define Status_MASK 0xf27fff3f

/* (13) Cause fields */
#define Cause_BD_MASK 0x80000000                       /* Branch Delay (31) */
#define Cause_CE_MASK 0x30000000               /* Coprocessor Error (29-28) */
#define Cause_IP_MASK 0x0000ff00                /* Interrupt Pending (15-8) */
#define Cause_IP_Ext_MASK 0x0000fc00  /* External (HW) ints IP(7-2) (15-10) */
#define Cause_IP_SW_MASK 0x00000300          /* Software ints IP(1-0) (9-8) */
#define Cause_ExcCode_MASK 0x0000007c               /* Exception Code (6-2) */
#define Cause_MASK 0xb000ff7c

/* (14) EPC has only one field */
#define EPC_MASK 0xffffffff

/* (15) PRId fields */
#define PRId_Imp_MASK 0x0000ff00                   /* Implementation (15-8) */
#define PRId_Rev_MASK 0x000000ff                          /* Revision (7-0) */
#define PRId_MASK 0x0000ffff

/* (16) Config is only on the R4k */
#define Config_MASK 0x00000000

/* (17) LLAddr is only on the R4k */
#define LLAddr_MASK 0x00000000

/* (18) WatchLo is only on the R4k */
#define WatchLo_MASK 0x00000000

/* (19) WatchHi is only on the R4k */
#define WatchHi_MASK 0x00000000

/* (20-25) reserved */

/* (26) ECC is only on the R4k */
#define ECC_MASK 0x00000000

/* (27) CacheErr is only on the R4k */
#define CacheErr_MASK 0x00000000

/* (28) TagLo is only on the R4k */
#define TagLo_MASK 0x00000000

/* (29) TagHi is only on the R4k */
#define TagHi_MASK 0x00000000

/* (30) ErrorEPC is only on the R4k */
#define ErrorEPC_MASK 0x00000000

/* (31) reserved */

#endif /* _CPZEROREG_H_ */
