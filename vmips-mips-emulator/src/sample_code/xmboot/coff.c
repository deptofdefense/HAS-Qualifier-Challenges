#ifdef TESTING
#include <stdio.h>
#include <string.h>
#else
#include "lib.h"
#endif
#include "coff.h"

int
coff_analyze (unsigned char *buf, struct coff_info *header)
{
  int i;
  struct coff_section_header *section = NULL;

  memcpy (&header->file_header, buf, sizeof (struct coff_file_header));
  if (!((header->file_header.magic == MIPSEBMAGIC)
        || (header->file_header.magic == MIPSELMAGIC)))
    return -1;
  section = ((struct coff_section_header *) &buf[76]);
  for (i = 0; i < header->file_header.no_sections; i++) {
      if (strlen(section->section_name) != 0)  {
        if (strcmp(section->section_name, ".text") == 0) {
          header->text_addr = section->section_virt_addr;
          header->text_offset = section->section_file_loc;
          header->text_size = section->section_size;
        } else if (strcmp(section->section_name, ".data") == 0) {
          header->data_addr = section->section_virt_addr;
          header->data_offset = section->section_file_loc;
          header->data_size = section->section_size;
        } else if (strcmp(section->section_name, ".bss") == 0) {
          header->bss_addr = section->section_virt_addr;
          header->bss_size = section->section_size;
        }
      }
      section++;
    }
  return 0;
}

void
print_coff_header (struct coff_info *header)
{
  if (header->file_header.magic == MIPSEBMAGIC)
    puts ("Big-Endian mips coff binary");
  else if (header->file_header.magic == MIPSELMAGIC)
    puts ("Little-Endian mips coff binary");

  printf
    ("size: text %lx data %lx bss %lx entry %lx\n"
     "base: text %lx data %lx bss %lx\n" "gp: %lx\n",
     header->file_header.text_size, header->file_header.data_size,
     header->file_header.bss_size, header->file_header.entry_addr,
     header->file_header.text_start, header->file_header.data_start,
     header->file_header.bss_start, header->file_header.gp_value);
  printf ("sections: .text@0x%x, %u bytes, at file offset %u\n",
	  (unsigned int) header->text_addr, (unsigned int) header->text_size,
	  (unsigned int) header->text_offset);
  printf ("          .data@0x%x, %u bytes, at file offset %u\n",
	  (unsigned int) header->data_addr, (unsigned int) header->data_size,
	  (unsigned int) header->data_offset);
  printf ("          .bss@0x%x, %u bytes\n", (unsigned int) header->bss_addr,
	  (unsigned int) header->bss_size);
  putchar ('\n');
}
