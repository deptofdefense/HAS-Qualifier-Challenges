/* Constants and bitmasks for DS1287-based DEC 5000/200 clock chip emulation.
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

#ifndef _DECRTCREG_H_
#define _DECRTCREG_H_

/* Default physical address for the DEC RTC */
#define DECRTC_BASE 0x1fe80000

#define RTC_SEC  0  /* Seconds; range 0 .. 59 */
#define RTC_ALMS 1  /* Alarm Seconds; range 0 .. 59 */
#define RTC_MIN  2  /* Minutes; range 0 .. 59 */
#define RTC_ALMM 3  /* Alarm Minutes; range 0 .. 59 */
#define RTC_HOUR 4  /* Hours; range 0 .. 23 */
#define RTC_ALMH 5  /* Alarm Hours; range 0 .. 23 */
#define RTC_DOW  6  /* Day of week; range 1 .. 7 */
#define RTC_DAY  7  /* Day of month; range 1 .. 31 */
#define RTC_MON  8  /* Month of year; range 1 .. 12 */
#define RTC_YEAR 9  /* Year; range 0 .. 99 (not y2k compliant!) */
#define RTC_REGA 10 /* Register A */
#define RTC_REGB 11 /* Register B */
#define RTC_REGC 12 /* Register C */
#define RTC_REGD 13 /* Register D */
#define RTC_RAM  14 /* Base of battery-backed-up RAM */

#define REGA_UIP  0x80  /* Update in Progress */
#define REGA_DVX  0x70  /* Timebase Divisor */
#define REGA_RSX  0x0f  /* Rate Select */

#define REGB_SET  0x80  /* Set Time */
#define REGB_PIE  0x40  /* Periodic Interrupt Enable */
#define REGB_AIE  0x20  /* Alarm Interrupt Enable */
#define REGB_UIE  0x10  /* Update Interrupt Enable */
#define REGB_SQWE 0x08  /* Square Wave Enable */
#define REGB_DM   0x04  /* Date Mode */
#define REGB_2412 0x02  /* Hours Format */
#define REGB_DSE  0x01  /* Daylight Savings Enable */

#define REGC_IRQF 0x80  /* Interrupt Request */
#define REGC_PF   0x40  /* Periodic Interrupt Flag */
#define REGC_AF   0x20  /* Alarm Interrupt Flag */
#define REGC_UF   0x10  /* Update Interrupt Flag */
#define REGC_RAZ  0x0f  /* Not used; read as zero */

#define REGD_VRT  0x80  /* Valid RAM/Time */
#define REGD_RAZ  0x7f  /* Not used; read as zero */

#endif /* _DECRTCREG_H_ */
