/* Stubs for floating-point coprocessor.
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

#include "fpu.h"
#include "cpu.h"
#include "vmips.h"
#include "excnames.h"
#include "stub-dis.h"
#include <cstdio>

void FPU::cpone_emulate (uint32 instr, uint32 pc)
{
    fprintf (stderr, "FPU instruction %x not implemented at pc=0x%x:\n",
        instr, pc);
    machine->disasm->disassemble (pc, instr);
    cpu->exception (CpU, ANY, 1);
}

uint32 FPU::read_reg (uint16 regno)
{
    fprintf (stderr, "FPU read from register %u unimplemented\n", regno);
    return 0xffffffff;
}

void FPU::write_reg (uint16 regno, uint32 word)
{
    fprintf (stderr, "FPU write to register %u unimplemented\n", regno);
}
