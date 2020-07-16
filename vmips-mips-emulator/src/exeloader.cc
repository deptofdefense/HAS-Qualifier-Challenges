/* Load executable files into virtual machine's memory.
   Copyright 2004 Brian R. Gaeke.

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

#include <string>
#include <cstring>
#include <cerrno>
#include <cstdio>
#include "vmips.h"
#include "cpzeroreg.h"
#include "memorymodule.h"
#include "error.h"

struct coff_file_header
{
  unsigned short magic;
  unsigned short no_sections;
  char extras[20];
  /* traditional header stuff follows: */
  unsigned long text_size;
  unsigned long data_size;
  unsigned long bss_size;
  unsigned long entry_addr;
  unsigned long text_start;
  unsigned long data_start;
  unsigned long bss_start;
  char extras2[20];
  unsigned long gp_value;
};

struct coff_section_header
{
  char section_name[8];
  unsigned long section_phys_addr;
  unsigned long section_virt_addr;
  unsigned long section_size;
  unsigned long section_file_loc;
  char extras[16];
};

struct coff_info
{
  struct coff_file_header file_header;
  unsigned long text_addr;
  unsigned long text_offset;
  unsigned long text_size;
  unsigned long data_addr;
  unsigned long data_offset;
  unsigned long data_size;
  unsigned long bss_addr;
  unsigned long bss_size;
};

#define MIPSEBMAGIC 0x0160
#define MIPSELMAGIC 0x0162

static inline bool good_ecoff_magic (struct coff_file_header *fhdr) {
  return ((fhdr->magic == MIPSEBMAGIC) || (fhdr->magic == MIPSELMAGIC));
}

static bool file_is_ecoff (FILE *fp) {
  fseek (fp, 0, SEEK_SET);
  coff_file_header hdr;
  if (fread (&hdr, sizeof (coff_file_header), 1, fp) != 1)
    return false;
  return good_ecoff_magic (&hdr);
}

static bool file_is_elf (FILE *fp) {
  fseek (fp, 0, SEEK_SET);
  char buf[4];
  if (fread (&buf, sizeof(char), 4, fp) != 4)
    return false;
  return (buf[0] == 0x7f) && (buf[1] == 'E') && (buf[2] == 'L')
         && (buf[3] == 'F');
}

/// Translate vaddr to a physical address, then return a host-machine
/// pointer to where it is in the simulated machine's RAM. vaddr must be in
/// one of the non-mapped kernel-mode segments (KSEG0 or KSEG1), and it must
/// be within the bounds of the simulated machine's physical RAM. Otherwise
/// a null pointer is returned.
///
char *vmips::translate_to_host_ram_pointer (uint32 vaddr) {
  // Translate vaddr to physical address.
  uint32 paddr;
  if ((vaddr & KSEG_SELECT_MASK) == KSEG0) {
    paddr = vaddr - KSEG0_CONST_TRANSLATION;
  } else if ((vaddr & KSEG_SELECT_MASK) == KSEG1) {
    paddr = vaddr - KSEG1_CONST_TRANSLATION;
  } else {
    error ("Virtual address 0x%x is not in KSEG0 or KSEG1", vaddr);
    return 0;
  }

  // Get pointer to where physaddr is in RAM and return it.
  if (memmod->incorporates(paddr)) {
    return (char *) memmod->getAddress() + (paddr - memmod->getBase());
  } else {
    error ("Virtual address 0x%x is not within physical RAM", vaddr);
    return 0;
  }
}

bool vmips::load_ecoff (FILE *fp) {
  coff_section_header *sections = 0;
  bool rv = true;
  try {

  if (fseek (fp, 0, SEEK_SET) < 0)
    throw std::string ("Can't seek to file header");
  coff_info header;
  if (fread (&header.file_header, sizeof (coff_file_header), 1, fp) != 1)
    throw std::string ("Can't read file header");

  if (fseek (fp, 76, SEEK_SET) < 0)
    throw std::string ("Can't seek to section headers");
  int nsects = header.file_header.no_sections;
  sections = new coff_section_header[nsects];
  for (int i = 0; i < nsects; ++i)
    if (fread (&sections[i], sizeof (coff_section_header), 1, fp) != 1)
      throw std::string ("Can't read section headers");

  coff_section_header *section = sections;
  for (int i = 0; i < header.file_header.no_sections; i++) {
    if (strlen(section->section_name) != 0)  {
      if (strcmp(section->section_name, ".text") == 0) {
        header.text_addr = section->section_virt_addr;
        header.text_offset = section->section_file_loc;
        header.text_size = section->section_size;
      } else if (strcmp(section->section_name, ".data") == 0) {
        header.data_addr = section->section_virt_addr;
        header.data_offset = section->section_file_loc;
        header.data_size = section->section_size;
      } else if (strcmp(section->section_name, ".bss") == 0) {
        header.bss_addr = section->section_virt_addr;
        header.bss_size = section->section_size;
      }
    }
    section++;
  }
  printf
    ("size: text %lx data %lx bss %lx entry %lx\n"
     "base: text %lx data %lx bss %lx\n" "gp: %lx\n",
     header.file_header.text_size, header.file_header.data_size,
     header.file_header.bss_size, header.file_header.entry_addr,
     header.file_header.text_start, header.file_header.data_start,
     header.file_header.bss_start, header.file_header.gp_value);
  printf ("sections: .text@0x%x, %u bytes, at file offset %u\n",
	  (unsigned int) header.text_addr, (unsigned int) header.text_size,
	  (unsigned int) header.text_offset);
  printf ("          .data@0x%x, %u bytes, at file offset %u\n",
	  (unsigned int) header.data_addr, (unsigned int) header.data_size,
	  (unsigned int) header.data_offset);
  printf ("          .bss@0x%x, %u bytes\n", (unsigned int) header.bss_addr,
	  (unsigned int) header.bss_size);
  putchar ('\n');

  char *text_area_dst = translate_to_host_ram_pointer (header.text_addr);
  char *data_area_dst = translate_to_host_ram_pointer (header.data_addr);
  char *bss_area_dst = translate_to_host_ram_pointer (header.bss_addr);
  printf ("host ptrs; text=%p data=%p bss=%p\n", text_area_dst, data_area_dst,
          bss_area_dst);
  
  if (fseek (fp, header.text_offset, SEEK_SET) < 0)
    throw std::string ("Can't seek to text offset");
  if (fread (text_area_dst, 1, header.text_size, fp) != header.text_size)
    throw std::string ("Can't read text");
  if (fseek (fp, header.data_offset, SEEK_SET) < 0)
    throw std::string ("Can't seek to data offset");
  if (fread (data_area_dst, 1, header.data_size, fp) != header.data_size)
    throw std::string ("Can't read data");
  memset (bss_area_dst, 0, header.bss_size);
  //cpu->debug_set_pc (header.file_header.entry_addr);
  
  } catch (std::string &errorstr) {
    error ("%s", errorstr.c_str ());
    rv = false;
  }

  fclose (fp);
  if (sections) delete sections;
  return rv;
}

bool vmips::load_elf (FILE *fp) {
  error ("Can't load elf files yet");
  fclose (fp);
  return false;
}

bool
vmips::setup_exe ()
{
  // Open executable file.
  if (strcmp (opt_execname, "none") == 0)
    return true;
  FILE *fp = fopen (opt_execname, "rb");
  if (!fp) {
    error ("Could not open executable `%s': %s", opt_execname,
           strerror (errno));
    return false;
  }
  if (file_is_ecoff (fp)) {
    return load_ecoff (fp);
  } else if (file_is_elf (fp)) {
    return load_elf (fp);
  } else {
    error ("Could not determine type of executable `%s'", opt_execname);
    return false;
  }
}

