/*  ../vmips -o haltdumpcp0 -o haltdumpcpu tlbwr.rom */
/*  should end with:   R08=01234000  R09=00000200 R10=00000000 
/*  R11=80000000 PC=bfc00180 NEXT_EPC = bfc00108 */
/*  tests instructions: tlbwr tlbwi tlbr tlbp */

#include "asm_regnames.h"
    .text
    .globl entry
    .ent entry
entry:
    li t0, 0
    li t1, 0

    /* test tlbwr */
    li t2, 0x0          /* VPN = 0 */
    mtc0 t2, $10        /* set EntryHi */
    li t2, 0x00000700   /* PPN = 0, Valid, Global, Dirty bits set */
    mtc0 t2, $2         /* set EntryLo */
    tlbwr               /* write random tlb entry */
    /* try a load and store to VPN 0 */
    sw t2, 0(zero)
    lw t3, 0(zero)
    /* we will have halted by now if tlbwr failed, */
    /* causing t0 and t1 to compare wrong */

    /* test tlbwi */
    li t2, 0x01234000   /* VPN = 0x01234 */
    mtc0 t2, $10        /* set EntryHi */
    li t2, 0x00000200   /* PPN = 0, Valid bit set */
    mtc0 t2, $2         /* set EntryLo */
    mtc0 zero, $0       /* set Index = [probe succeeded] 0 */
    tlbwi               /* write tlb entry 0 */
    /* Now entry 0 should be 0123400000000200 [V=01234 A=000 P=00000 ndVg] */

    /* test tlbp */
    li t2, 0x80003f00
    mtc0 t2, $0         /* set Index = [probe failed] 0x3f */
    tlbp                /* probe the tlb */
    mfc0 t2, $0         /* read out Index */
    beqz t2, 1f         /* now, Index should be [probe succeeded] 0 */
                        /* (i.e., t2 should be 00000000) if it worked */
    break               /* halt if tlbp failed; t2 will compare wrong */

1:  li t3, 0x06666000   /* load a bogus VPN */
    mtc0 t3, $10        /* set EntryHi */
    tlbp
    mfc0 t3, $0         /* read out Index */
    lui t4, 0x8000
    and t3, t3, t4      /* only want to know whether it failed, as it should have */
    
    /* test tlbr */
    tlbr                /* see if we can read out the entry we just read in */
    mfc0 t0, $10        /* read out entryHi */
    mfc0 t1, $2         /* read out entryLo */
    /* now, t0 should be 01234000 and t1 should be 00000200 */

    /* we're done */
    jr ra
    /* This return to the setup code will result in a halt on a break */
    /* instruction. */
    .end entry

