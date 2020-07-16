/* Definitions for stub floating-point coprocessor.
   Copyright 2004, 2009 Brian R. Gaeke.

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

#ifndef _FPU_H_
#define _FPU_H_

#include "types.h"

class CPU;

class FPU
{
        CPU *cpu;
public:
	FPU (CPU *m) : cpu (m) { }
        void cpone_emulate (uint32 instr, uint32 pc);
        uint32 read_reg (uint16 regno);
	void write_reg (uint16 regno, uint32 word);
};

#endif /* _FPU_H_ */
