/* Simple code to exercise ETestDev and DeviceMap shim routines. */
#include "sample_code/asm_regnames.h"

#define TEST_BASE 0xa2010000

    .text
    .globl __start

    .ent __start
__start:

    li s0, TEST_BASE

/* Word store test */
    li t0, 0xaabbccdd
    sw t0, 0(s0)

/* Half word store test */
    li t0, 0xa1b2
    sh t0, 0(s0)
    sh t0, 2(s0)

/* Byte store test */
    li t0, 0xc3
    sb t0, 0(s0)
    sb t0, 1(s0)
    sb t0, 2(s0)
    sb t0, 3(s0)

    break

    .end __start

