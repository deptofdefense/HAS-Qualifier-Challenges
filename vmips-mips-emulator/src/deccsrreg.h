/* Constants and bitmasks for DEC Control/Status Register emulation.
   Copyright 2003 Brian R. Gaeke.

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

#ifndef _DECCSRREG_H_
#define _DECCSRREG_H_

/* Default physical address for the DEC CSR */
#define DECCSR_BASE 0x1ff00000

/* Fields marked (read-only) should be written as zero. */
#define CSR_RSRVD   0xf0000000 /* Reserved (r/o) */
#define CSR_PSWARN  0x08000000 /* Overheat sensor warning (0=normal) (r/o) */
#define CSR_PRSVNVR 0x04000000 /* 0=reinitialize NVRAM, 1=normal (r/o) */
#define CSR_REFEVEN 0x02000000 /* Which DRAM bank to refresh next cycle (r/o) */
#define CSR_NRMMOD  0x01000000 /* 1=normal POST tests, 0=mfr tests (r/o) */

#define CSR_IOINTEN 0x00ff0000 /* I/O slot interrupt enables (r/w) */
#define CSR_ECCMD   0x0000c000 /* ECC logic operation mode (r/w) */
#define CSR_CORRECT 0x00002000 /* 0=ECC off, 1=ECC on (r/w) */
#define CSR_LEDIAG  0x00001000 /* ECC diagnostic data latch (r/w) */
#define CSR_TXDIS   0x00000800 /* Disable serial line EIA drivers (r/w) */
#define CSR_BNK32M  0x00000400 /* Memory bank stride: 0=8MB, 1=32MB (r/w) */
#define CSR_DIAGDN  0x00000200 /* Diagnostics done (r/w) */
#define CSR_BAUD38  0x00000100 /* 0=19.2Kbps, 1=38.4Kbps on DZ serial (r/w) */
#define CSR_RW_BITS 0x00ffff00 /* (all of the above r/w fields.) */

#define CSR_IOINT   0x000000ff /* I/O slot interrupt signals (r/o) */
#define CSR_LEDS    0x000000ff /* State of diagnostic LEDs (w/o) */

#endif /* _DECCSRREG_H_ */
