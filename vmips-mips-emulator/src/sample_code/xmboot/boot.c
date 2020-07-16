/* vmips boot monitor
 * $Date: 2013/04/08 05:48:45 $
 * by Brian R. Gaeke
 */

#include "lib.h"
#include "coff.h"
#include "serial.h"
#include "xmrcv.h"
#include "cpzeroreg.h"
#include "set_status.h"
#include "bootenv.h"

/* Maximum number of arguments to a command in the boot monitor. */
#define MAXARGS 10

/* Where in memory a received file should be stored. */
#define BASE_ADDR 0x80000000

/* Type definitions. */

/* Defines a command-handling function: */
typedef int (*func) (int argc, char **argv);

/* Defines a program being called by the booter: */
/* typedef void (*entry_type) (void); */
typedef func entry_type;

/* An entry in the command table: */
struct command_table_entry
{
  char *command;
  char *help;
  func handler;
};

/* Results of parsing a command line: */
struct parsed_command
{
  func handler;
  int argc;
  char *argv[MAXARGS];
};

/* Function prototypes. */
int receive (int argc, char **argv);
int info (int argc, char **argv);
int boot (int argc, char **argv);
int quit (int argc, char **argv);
int str_to_command (char *input, struct parsed_command *output);
int help (int argc, char **argv);
int peek (int argc, char **argv);
int poke (int argc, char **argv);
int load_rom (int argc, char **argv);
int do_printenv (int argc, char **argv);
int do_setenv (int argc, char **argv);
int do_unsetenv (int argc, char **argv);
int do_call (int argc, char **argv);
void entry (void);
void set_bev (int yesOrNo);
void set_interrupts (int yesOrNo);

/* Global variables. */

/* True if the command processor should halt. */
int halted;

/* Table of commands understood by the command processor. */
struct command_table_entry command_table[] = {
  {"rx", "Receive file via Xmodem protocol", receive},
  {"quit", "Halt the boot monitor", quit},
  {"help", "Print list of commands", help},
  {"peek", "Read and print value at address", peek},
  {"poke", "Write value to address", poke},
  {"info", "Print information about loaded program", info},
  {"boot", "Run a program which has previously been loaded", boot},
  {"rom", "Load a file from ROM", load_rom},
  {"printenv", "Print the boot environment", do_printenv},
  {"setenv", "Set an environment variable", do_setenv},
  {"unsetenv", "Delete an environment variable", do_unsetenv},
  {"call", "Call procedure at address", do_call},
  {0, 0}
};

/* Buffer in which to store a received file. */
unsigned char *recv_buffer = (unsigned char *) BASE_ADDR;
unsigned char *orig_recv_buffer = (unsigned char *) BASE_ADDR;

/* Size in bytes of last file received, or -1 if none yet received. */
static long recv_size = -1;

/* These functions support the XModem receive code (xmrcv.c). */
int
receive_byte (unsigned char *ch)
{
  return ((read (0, ch, 1) < 1) ? -1 : 0);
}

int
send_byte (unsigned char ch)
{
  return ((write (1, &ch, 1) < 1) ? -1 : 0);
}

/* Receive an XMODEM file from the remote end. */
int
receive (int argc, char **argv)
{
  int rv;

  recv_buffer = orig_recv_buffer; /* if we ROM'd something before */
  puts ("Ready to receive file.");
  term_disable(COOKED);
  rv = xmrcv (&recv_size, recv_buffer);
  term_enable(COOKED);
  if (rv < 0)
    {
      recv_size = -1;
      puts ("Receive failed.");
      return -1;
    }
  puts ("Received file.");
  return 0;
}

/* Print information about a coff file which has been previously transferred. */
int
info (int argc, char **argv)
{
  struct coff_info h;

  if (recv_size < 0)
    {
      puts ("No file loaded.");
      return -1;
    }

  if (coff_analyze (recv_buffer, &h) < 0)
    {
      puts ("File not bootable.");
      return -1;
    }

  print_coff_header (&h);
  return 0;
}

/* Boot a file which has been transferred. */
int
boot (int argc, char **argv)
{
  struct coff_info h;
  entry_type harry = NULL;

  if (recv_size < 0)
    {
      puts ("No file loaded.");
      return -1;
    }

  if (coff_analyze (recv_buffer, &h) < 0)
    {
      puts ("File not bootable.");
      return -1;
    }

  printf ("Moving %lu bytes of text from %lx-%lx to %lx-%lx...", h.text_size,
	  (unsigned long) recv_buffer + h.text_offset, (unsigned long) recv_buffer + h.text_offset+h.text_size,
	  (unsigned long) h.text_addr, h.text_addr+h.text_size);
  memmove ((void *) h.text_addr, recv_buffer + h.text_offset, h.text_size);
  puts ("ok.");
  printf ("Moving %lu bytes of data from %lx-%lx to %lx-%lx...", h.data_size,
	  (unsigned long) recv_buffer + h.data_offset, (unsigned long) recv_buffer + h.data_offset+h.data_size,
	  (unsigned long) h.data_addr, h.data_addr+h.data_size);
  memmove ((void *) h.data_addr, recv_buffer + h.data_offset, h.data_size);
  puts ("ok.");
  printf ("Zeroing out bss (%lu bytes at %lx)...", h.bss_size, h.bss_addr);
  memset ((void *) h.bss_addr, 0, h.bss_size);
  puts ("ok.");

  puts("When you walk through the storm");
  puts("hold your head up high");
  puts("And don't ... be afraid ... of the dark!");

  harry = (entry_type) (h.file_header.entry_addr);

  /* Turn off boot-time exception handler on the way out */
  set_bev (0);

  /* Jump to the program */
  harry(argc - 1, argv + 1);

  /* What, we're back here again?! */
  set_bev (1);
  puts ("\n\nProgram terminated");
  return 0;
}

/* Signal the command processor to halt. */
int
quit (int argc, char **argv)
{
  halted = 1;
  return 0;
}

/* Parse command line INPUT and look up appropriate handler, if this
 * command has one. Place results in OUTPUT.
 */
int
str_to_command (char *input, struct parsed_command *output)
{
  char *p = input;
  int i;
  struct command_table_entry *c;

  for (i = 0; i < MAXARGS; i++)
    {
      output->argv[i] = p;
      while ((*p != ' ') && (*p != '\0'))
        p++;
      if (*p == '\0')
        break;
      *p++ = '\0';
    }
  output->argc = i + 1;
  output->handler = (func) 0;
  for (c = command_table; c->command != 0; c++)
    {
      if (strcmp (output->argv[0], c->command) == 0)
        {
          output->handler = c->handler;
          break;
        }
    }
  return (output->handler == ((func) 0)) ? -1 : 0;
}

/* Display documentation about supported commands. */
int
help (int argc, char **argv)
{
  struct command_table_entry *c;

  puts ("Help:");
  for (c = command_table; c->command != 0; c++)
    {
      if (argc == 2 && (strcmp (argv[1], c->command) != 0))
        continue;
      puts_nonl (c->command);
      puts_nonl (" - ");
      puts (c->help);
    }
  return 0;
}

void
print_mem(unsigned long address, unsigned long value)
{
  char *c = (char *) &value;
#define printify(x) (isprint(x) ? (x) : '.')
  printf("%lx: %lx [%c%c%c%c]\n", address, value, printify(c[0]),
    printify(c[1]), printify(c[2]), printify(c[3]));
#undef printify
}

int
peek (int argc, char **argv)
{
  unsigned long address, length, value, i;

  if (argc < 3)
    {
      puts ("Usage: peek addr nwords");
      return -1;
    }
  address = (unsigned long) strtol (argv[1], NULL, 0);
  length = (unsigned long) strtol (argv[2], NULL, 0);
  for (i = 0; i < length; i++) {
    value = *((volatile unsigned long *)address);
    print_mem(address, value);
    address += 4;
  }
  return 0;
}

int
poke (int argc, char **argv)
{
  unsigned long address, value;

  if (argc < 3)
    {
      puts ("Usage: poke addr value");
      return -1;
    }
  address = (unsigned long) strtol (argv[1], NULL, 0);
  value = (unsigned long) strtol (argv[2], NULL, 0);
  *((volatile unsigned long *)address) = value;
  value = *((volatile unsigned long *)address);
  print_mem(address, value);
  return 0;
}

int
do_printenv (int argc, char **argv)
{
  printenv ();
  return 0;
}

int
do_setenv (int argc, char **argv)
{
  char *varname, *value;
  if (argc != 3) {
	puts ("Usage: setenv varname value");
	return -1;
  }
  varname = argv[1];
  value = argv[2];
  setenv (varname, value);
  return 0;
}

int
do_unsetenv (int argc, char **argv)
{
  char *varname;
  if (argc != 2) {
	puts ("Usage: unsetenv varname");
	return -1;
  }
  varname = argv[1];
  unsetenv (varname);
  return 0;
}

int
do_call (int argc, char **argv)
{
  unsigned long address;
  entry_type harry;
  if (argc < 2)
    {
      puts ("Usage: call addr [args...]");
      return -1;
    }
  address = (unsigned long) strtol (argv[1], NULL, 0);
  harry = (entry_type) address;
  set_bev (0);
  return harry(argc - 2, argv + 2);
}

int
load_rom (int argc, char **argv)
{
  unsigned long address, nwords;

  if (argc != 3)
    {
      puts ("Usage: rom addr nwords");
      return -1;
    }
  address = (unsigned long) strtol (argv[1], NULL, 0);
  nwords = (unsigned long) strtol (argv[2], NULL, 0);
  /* Don't actually copy, just make-believe it was received into ROM. */
  recv_buffer = (unsigned char *) address;
  recv_size = nwords * 4;
  puts ("Ok.");
  return 0;
}

/* Main entry point of the command processor. */
void
entry (void)
{
  char buf[80];
  struct parsed_command cmd;

  /* You can turn this on to try out the microsecond clock. */
  /* turn_on_clock_interrupts(); */
  halted = 0;
  serial_init ();
  term_enable (COOKED);
  initbootenv ();
  puts ("\n\nVmips boot monitor");
  set_status (Status_CU0_MASK | Status_DS_BEV_MASK);
  set_cause (0);
  if ((recv_buffer != orig_recv_buffer) && (recv_size != -1))
    {
      char *newargv[] = { "boot", "5/rz0/netbsd", NULL };
      printf ("Autobooting preloaded ROM file at %x\n",
              (unsigned int) recv_buffer);
      boot (2, newargv);
    }
  while (!halted)
    {
      puts_nonl ("> ");
      gets (buf);
      if (!buf[0])
        continue;
      if (str_to_command (buf, &cmd) < 0)
        {
          puts ("Unrecognized command");
          continue;
        }
      cmd.handler (cmd.argc, cmd.argv);
    }
  puts ("Halting.");
  return;
}

void set_bev (int yesOrNo)
{
	int t = get_status ();
	if (yesOrNo) {
		t |= Status_DS_BEV_MASK;
	} else {
		t &= ~Status_DS_BEV_MASK;
	}
	set_status (t);
}

void set_interrupts (int yesOrNo)
{
	int t = get_status ();
	if (yesOrNo) {
		t |= Status_IEc_MASK;
		t |= Status_IM_MASK;
	} else {
		t &= ~Status_IEc_MASK;
		t &= ~Status_IM_MASK;
	}
	set_status (t);
}

void turn_on_clock_interrupts (void)
{
	int t = get_status ();
	t |= (Status_IEc_MASK | 0x08000 /* clock interrupt line */);
	set_status (t);
}
