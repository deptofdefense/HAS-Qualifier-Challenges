#ifndef SPIM_CONSOLE
#define SPIM_CONSOLE 1
#endif
#ifndef DZ_CONSOLE
#define DZ_CONSOLE 0
#endif

#include "spimconsreg.h"
#include "decserialreg.h"
#include "serial.h"

volatile long *keyboard_control_reg;
volatile long *display_control_reg;
volatile long *keyboard_data_reg;
volatile long *display_data_reg;
volatile long *control_status_reg;

int
spim_console_is_ready(volatile long *ctrl)
{
  return (((*(ctrl)) & CTL_RDY) != 0);
}

int
keyboard_ready (void)
{
  if (SPIM_CONSOLE)
    return spim_console_is_ready (keyboard_control_reg);
  else if (DZ_CONSOLE)
    return (((*control_status_reg) & DZ_CSR_RDONE) != 0);
}

int
display_ready (void)
{
  if (SPIM_CONSOLE)
    return spim_console_is_ready (display_control_reg);
  else if (DZ_CONSOLE)
    return (((*control_status_reg) & DZ_CSR_TRDY) != 0);
}

static unsigned char
internal_read_byte (void)
{
  while (!keyboard_ready ()) { }
  return (char) (*keyboard_data_reg) & 0x0ff;
}

static void
internal_write_byte (char out)
{
  while (!display_ready ()) { }
  *display_data_reg = (long) out;
}

int
read (int fd, void *buf, unsigned int count)
{
  int i;
  char *b = buf;

  if (fd != 0)
    return 0;
  for (i = 0; i < count; i++)
    *b++ = internal_read_byte ();
  return count;
}

int
write (int fd, const void *buf, unsigned int count)
{
  int i;
  const char *b = buf;

  if (fd != 1)
    return 0;
  for (i = 0; i < count; i++)
    internal_write_byte (*b++);
  return count;
}

void
serial_init (void)
{
  if (SPIM_CONSOLE) {
    keyboard_control_reg = (long *)(SPIM_ADDR+KEYBOARD_1_CONTROL);
    display_control_reg = (long *)(SPIM_ADDR+DISPLAY_1_CONTROL);
    keyboard_data_reg = (long *)(SPIM_ADDR+KEYBOARD_1_DATA);
    display_data_reg = (long *)(SPIM_ADDR+DISPLAY_1_DATA);
  } else if (DZ_CONSOLE) {
    keyboard_control_reg = (long *)(DECSERIAL_ADDR+DZ_TCR);
    control_status_reg = (long *)(DECSERIAL_ADDR+DZ_CSR);
    keyboard_data_reg = (long *)(DECSERIAL_ADDR+DZ_RBUF);
    display_data_reg = (long *)(DECSERIAL_ADDR+DZ_TDR);

    *control_status_reg |= DZ_CSR_CLR;
    while (*control_status_reg & DZ_CSR_CLR) { }
    *control_status_reg |= DZ_CSR_MSE;
    *control_status_reg |= 3 << 8; /* set TLINE */
    *keyboard_control_reg |= DZ_TCR_LNENB3;
  }
}
