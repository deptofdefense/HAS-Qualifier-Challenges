/* C++ interface to the GNU disassembler library (libopcodes).
   Copyright 2001, 2003, 2004 Brian R. Gaeke.

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

#include "stub-dis.h"

Disassembler::Disassembler (bool host_is_bigendian, FILE *stream) {
  if (host_is_bigendian) {
    insn_printer_func = print_insn_big_mips;
  } else {
    insn_printer_func = print_insn_little_mips;
  }
  INIT_DISASSEMBLE_INFO(disasm_info, stream, fprintf);
  disasm_info.buffer_length = 4;
}

void Disassembler::disassemble (uint32 pc, uint32 instr) {
  // Point libopcodes at the instruction.
  disasm_info.buffer_vma = pc;
  disasm_info.buffer = (bfd_byte *) &instr;

  // Disassemble the instruction, which is in *host* byte order.
  insn_printer_func(pc, &disasm_info);
  putc('\n', (FILE *)disasm_info.stream);   // End the line.
}
