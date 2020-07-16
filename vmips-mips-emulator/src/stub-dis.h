/* Interface to: Stub functions to interface to the GNU disassembler library
    (libopcodes).
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

#ifndef _STUB_DIS_H_
#define _STUB_DIS_H_

#include "types.h"
#include <cstdio>
extern "C" {
#include "bfd.h"
#include "dis-asm.h"
}

class Disassembler {
  struct disassemble_info disasm_info;
  int (*insn_printer_func) (unsigned long, struct disassemble_info *);
public:
  Disassembler (bool host_is_bigendian, FILE *stream);
  ~Disassembler () { }
  void disassemble (uint32 pc, uint32 instr); 
};

#endif /* _STUB_DIS_H_ */
