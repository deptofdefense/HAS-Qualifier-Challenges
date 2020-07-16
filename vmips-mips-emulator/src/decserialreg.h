/* Constants, registers & bitmasks for DZ11 DEC 5000/200 serial chip emulation.
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

#ifndef _DECSERIALREG_H_
#define _DECSERIALREG_H_

#define DECSERIAL_BASE 0x1fe00000
#define DECSERIAL_ADDR 0xbfe00000
#define DZ_CSR  0x00  /* R/W; Control and status register */
#define DZ_CSR_TRDY  0x8000 /* Transmitter ready */
#define DZ_CSR_TIE   0x4000 /* Transmitter interrupt enable */
#define DZ_CSR_TLINE 0x0300 /* Transmitter line select (0...3) */
#define DZ_CSR_RDONE 0x0080 /* Receiver done (ready) */
#define DZ_CSR_RIE   0x0040 /* Receiver Interrupt Enable */
#define DZ_CSR_MSE   0x0020 /* Master Scan Enable */
#define DZ_CSR_CLR   0x0010 /* Master Clear */
#define DZ_CSR_MAINT 0x0008 /* Maintenance mode - loopback output->input. */

#define DZ_RBUF 0x08  /* R; Receiver buffer */
#define DZ_RBUF_DVAL  0x8000 /* Data valid */
#define DZ_RBUF_OERR  0x4000 /* Overrun error */
#define DZ_RBUF_FERR  0x2000 /* Framing error */
#define DZ_RBUF_PERR  0x1000 /* Parity error */
#define DZ_RBUF_RLINE 0x0300 /* Received line number */
#define DZ_RBUF_RBUF  0x00ff /* Received character */

#define DZ_LPR  0x08  /* W; Line parameters */
#define DZ_LPR_RXENAB 0x1000
#define DZ_LPR_SC     0x0f00
#define DZ_LPR_ODDPAR 0x0080
#define DZ_LPR_PARENB 0x0040
#define DZ_LPR_STOP   0x0020
#define DZ_LPR_CHAR   0x0018
#define DZ_LPR_LINE   0x0003

#define DZ_TCR  0x10  /* R/W; Transmitter control */
#define DZ_TCR_RTS2   0x0800
#define DZ_TCR_DTR2   0x0400
#define DZ_TCR_RTS3   0x0200
#define DZ_TCR_DTR3   0x0100
#define DZ_TCR_LNENB3 0x0008
#define DZ_TCR_LNENB2 0x0004
#define DZ_TCR_LNENB1 0x0002
#define DZ_TCR_LNENB0 0x0001

#define DZ_MSR  0x18  /* R; Modem status */
#define DZ_MSR_RI2  0x0800
#define DZ_MSR_CD2  0x0400
#define DZ_MSR_DSR2 0x0200
#define DZ_MSR_CTS2 0x0100
#define DZ_MSR_RI3  0x0008
#define DZ_MSR_CD3  0x0004
#define DZ_MSR_DSR3 0x0002
#define DZ_MSR_CTS3 0x0001

#define DZ_TDR  0x18  /* W; Transmit data */
#define DZ_TDR_BRK  0x0f00 /* break on line 3 ... 0 */
#define DZ_TDR_TBUF 0x00ff /* Transmitter buffer */

#endif /* _DECSERIALREG_H_ */
