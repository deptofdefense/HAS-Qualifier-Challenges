
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

int coff_analyze(unsigned char *buf, struct coff_info *header);
void print_coff_header(struct coff_info *header);

