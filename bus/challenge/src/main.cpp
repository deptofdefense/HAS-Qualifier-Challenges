/*******************************************************************************

 This challenge runs for two minutes and simulates an I2C bus with the
following devices attached:

 - OBC (Onboard computer - bus master)
 - EEP (Some kind of device which contains "juicy data" + the flag)
 - EPS (Electrical power system controller)

 The OBC, while on, polls the bus every ten seconds, providing clues, and 
 generally tying up the bus most of the time. The bus data rate is 
 artificially limited to ensure this.

 We need to dump the EEP, but there are two problems:

 1) EEP power is turned off between updates.
 2) The OBC is tying up the bus most of the time.

 By looking at the traffic, we see the OBC enabling power to the device,
 reading from it (in random areas that don't contain the flag), and
 turning it off afterwards. After that, there's a short pause
 (a few seconds) before the polling starts again.

 Ideally, the contestant will use that pause to issue I2C requests to
 turn off the power to the OBC, freeing up the bus so the EEP can
 be dumped in the time allotted.

 At regular intervals in the EEP are strings saying "Juicy Data XX" where
 XX is an increasing number.  Also in the EEP is a null-terminated string
 which reads THE_FLAG_IS:"..."

 The EPS memory space comprises seven four-byte values. The first are
 active-high control bits indicating which power rails are turned on.
 Bit 0 corresponds to rail 0, etc. The rest are float values indicating
 the current voltages of rails 0 through 5, respectively. If
 the rail is turned off, the voltage will be close to zero.

 Things that are randomized based on the challenge container's SEED
 environment variable:

 - I2C slave addresses of EPS and EEP
 - Location of challenge flag in the EEP
 - Order of the power rails in the EPS

 The input / output format is a text representation of
 what happens on the bus, e.g.

 ^a1+00+00+3f+.

 Where ^. are control characters, +- are status flags, and the rest are
 octets.

 Control:
 - '^' = I2C bus START
 - '.' = I2C STOP

 Status:
 - '+' = ACK from a slave device
 - '-' = NAK from a slave device

 Note that the first octet after a START is a slave device address,
 where the high seven bits choose the slave, and the low bit indicates
 whether we wish to READ or WRITE.

 If the provided slave address matches a device on the bus, an ACK (+) will
 appear after the input. Else a (-) will appear.

 The next two octets are a 16-bit big-endian address in the slave's memory.

 After that, some indeterminate number of octets are sent:

 For a WRITE, the sent octets are written to the device starting with the
 specified address, and those same octets appear in the output, each followed
 by ACK's, or in the case of out-of-bounds, NAK's.

 For a READ, dummy octets are sent. For each one, the output will by the
 next byte read followed by ACK. If the read is out-of=bounds, the
 output will instead show the value of the dummy byte followed by a NAK.

******************************************************************************/
#include <signal.h>
#include "common.h"
#include "helpers.h"
#include "Eeprom.h"
#include "Eps.h"
#include "Obc.h"
#include "I2CBus.h"
// -----------------------------------------------------------------------------
#define TAG     "MAI"
// -----------------------------------------------------------------------------
bool      g_mainloop=true;        // mainloop repeats while true

Eeprom    *g_eep = NULL;
Eps       *g_eps = NULL;
Obc       *g_obc = NULL;
I2CBus    *g_bus = NULL;
struct termios orig_termios;

void timeout_func(int signo) 
{

  exit(-1);

}
// -----------------------------------------------------------------------------
void reset_terminal_mode()
{
  tcsetattr(0, TCSANOW, &orig_termios);
}
// -----------------------------------------------------------------------------
void set_conio_terminal_mode()
{
  struct termios new_termios;
  /* take two copies - one for now, one for later */
  tcgetattr(0, &orig_termios);
  memcpy(&new_termios, &orig_termios, sizeof(new_termios));
  /* register cleanup handler, and set the new terminal mode */
  atexit(reset_terminal_mode);
  cfmakeraw(&new_termios);
  tcsetattr(0, TCSANOW, &new_termios);
}
// -----------------------------------------------------------------------------
int kbhit()
{
  struct timeval tv = { 0L, 0L };
  fd_set fds;
  FD_ZERO(&fds);
  FD_SET(0, &fds);
  return select(1, &fds, NULL, NULL, &tv);
}
// -----------------------------------------------------------------------------
int getch()
{
  int r;
  unsigned char c;
  if ((r = read(0, &c, sizeof(c))) < 0) {
      return r;
  } else {
      return c;
  }
}
// -----------------------------------------------------------------------------
// if the OBC is powered on, it does all this stuff each polling interval.
// this will tie up the bus for most of each interval. The expectation is that
// the contestant will need to turn off the obc to have time to power on and
// read from the device containing the flag.
// -----------------------------------------------------------------------------
void doPoll()
{
  _li("Polling operation started.");

  // read eps to show power rails and how one is tuned off

  g_bus->start();
  uint8_t b = g_eps->devAdrs()|MEM_READ;
  uint8_t rb;
  uint8_t railbits;
  // dev adrs
  g_bus->putByte(b,&rb);
  // mem adrs
  b=0x00;
  g_bus->putByte(b,&rb);
  b=0x00;
  g_bus->putByte(b,&rb);
  // mem xfer
  for(unsigned i=0;i<EPS_MEM_SIZE;i++)
  {
    g_bus->putByte(b,&rb);
    if(!i)
      railbits=rb;
  }
  g_bus->stop();

  // write eps to turn that rail on

  g_bus->start();
  b = g_eps->devAdrs()|MEM_WRITE;
  // dev adrs
  g_bus->putByte(b,&rb);
  // mem adrs
  b=0x00;
  g_bus->putByte(b,&rb);
  b=0x00;
  g_bus->putByte(b,&rb);
  // mem xfer
  b=railbits|g_eps->eepBit();
  g_bus->putByte(b,&rb);
  g_bus->stop();

  // read eps to show that that power rail is now on

  g_bus->start();
  b = g_eps->devAdrs()|MEM_READ;
  // dev adrs
  g_bus->putByte(b,&rb);
  // mem adrs
  b=0x00;
  g_bus->putByte(b,&rb);
  b=0x00;
  g_bus->putByte(b,&rb);
  // mem xfer
  for(unsigned i=0;i<EPS_MEM_SIZE;i++)
    g_bus->putByte(b,&rb);
  g_bus->stop();

  // read some random thing from the eeprom (but not the flag)

  unsigned eep_read_len = rand()%32+32;
  g_bus->start();
  b = g_eep->devAdrs()|MEM_READ;
  unsigned eep_read_adrs = g_eep->adrsNotFlag(eep_read_len);
  g_eep->memDumpSegment(eep_read_adrs,eep_read_len);
  // dev adrs
  g_bus->putByte(b,&rb);
  // mem adrs
  b=(eep_read_adrs>>8)&0xff;
  g_bus->putByte(b,&rb);
  b=eep_read_adrs&0xff;
  g_bus->putByte(b,&rb);
  // mem xfer
  for(unsigned i=0;i<eep_read_len;i++)
    g_bus->putByte(b,&rb);
  g_bus->stop();

  // write eps to turn that one rail back off

  g_bus->start();
  b = g_eps->devAdrs()|MEM_WRITE;
  // dev adrs
  g_bus->putByte(b,&rb);
  // mem adrs
  b=0x00;
  g_bus->putByte(b,&rb);
  b=0x00;
  g_bus->putByte(b,&rb);
  // mem xfer
  b=railbits&~g_eps->eepBit();

  // pause obc for debug
  //b=railbits&~g_eps->obcBit();

  g_bus->putByte(b,&rb);
  g_bus->stop();

  // read eps to show it is turned off

  g_bus->start();
  b = g_eps->devAdrs()|MEM_READ;
  // dev adrs
  g_bus->putByte(b,&rb);
  // mem adrs
  b=0x00;
  g_bus->putByte(b,&rb);
  b=0x00;
  g_bus->putByte(b,&rb);
  // mem xfer
  for(unsigned i=0;i<EPS_MEM_SIZE;i++)
    g_bus->putByte(b,&rb);
  g_bus->stop();

  _li("Polling operation ended.");

  // trash any keystrokes sent while polling
  while (kbhit()) getch();
}
// -----------------------------------------------------------------------------
// translate keyboard input to bus traffic
// -----------------------------------------------------------------------------
const char * valid_keys = "0123456789abcdefABCDEF.^";
const char * octet_keys = "0123456789abcdefABCDEF";
const char * ctrl_keys = ".^";
typedef enum {
  KS_IDLE,
  KS_IN_OCTET
} t_key_state;
t_key_state ks=KS_IDLE;
char obuf[3]="\0";
// -----------------------------------------------------------------------------
void handleKeystroke()
{
  char c=getch();
  char s[2]="\0";
  s[0]=c;
  if(strstr(valid_keys,s))
  {
    if(strstr(ctrl_keys,s))
    {
      if(ks==KS_IDLE)
      {
        if(c=='^')
          g_bus->start();
        else if(c=='.')
          g_bus->stop();
      } else
      {
        ks=KS_IDLE;
        obuf[0]='\0';
      }
    } else
    {
      strcat(obuf,s);
      if(strlen(obuf)<2)
      {
        ks=KS_IN_OCTET;
      } else
      {
        ks=KS_IDLE;
        uint8_t b;
        sscanf(obuf, "%2hhx", &b);
        //printf("%02x",b);
        obuf[0]='\0';
        uint8_t rb;
        g_bus->putByte(b,&rb);
      }
    }
  } else
  {
    ks=KS_IDLE;
  }
  fflush(stdout);
}
// -----------------------------------------------------------------------------
int main(int argc, char * argv[])
{
  set_conio_terminal_mode();
  _lw("Hack the Sat - Bus Challenge");

  // get challenge flag and rand() seed
  char * flag = getenv("FLAG");
  char * sseed = getenv("SEED");
  char * stimeout = getenv("TIMEOUT");

  int seed;
  int timeout;

  if(sseed)
  {
    seed=atoi(sseed);
  } else
  {
    fprintf(stderr, "*** NO ENV SEED. Using default.\r\n");
    seed=123;    
  }

  if (!flag)
  {
    fprintf(stderr, "*** NO ENV FLAG. Using default.\r\n");
    flag=(char *)"this_is_the_flag";
  }

  if (stimeout ) 
  {
    timeout=atoi(stimeout);
  }
  else {
    timeout=120;
  }

  // setup a signal handler for the hard timeout feature
  signal(SIGALRM, timeout_func);

  // give a couple of extra seconds for it to end on its own
  alarm(timeout+2);

  srand(seed);

  _lw("Flag: \"%s\"",flag);
  _lw("Seed: %d",seed);

  // setup I2C devices and bus
  g_eps = new Eps("Electronic Power System",EPS_MEM_SIZE);
  g_eep = new Eeprom("EEPROM",EEP_MEM_SIZE,flag);
  g_obc = new Obc("Onboard Computer",OBC_MEM_SIZE);

  g_bus = new I2CBus();
  g_bus->addDevice(g_eps);
  g_bus->addDevice(g_eep);
  g_bus->addDevice(g_obc);

  struct timespec tm;
  tm.tv_sec = 0;
  tm.tv_nsec = 250000;
  time_t tlast=0, tnow;
  unsigned polls = 0;

  //fcntl(0, F_SETFL, fcntl(0, F_GETFL) | O_NONBLOCK);

  while(g_mainloop)
  {
    time(&tnow);
    int dt = tnow-tlast;

    if(dt>=POLL_INTERVAL)
    {
      tlast=tnow;
      if(++polls>(timeout/POLL_INTERVAL))
      {
        g_mainloop=false;
      } else
      {
        if(g_eps->obcPowered())
          doPoll();
      }
    } // poll interval

    if(kbhit())
      handleKeystroke();

    nanosleep(&tm,NULL);
  }

  delete(g_bus);

  const char * bye = "\r\n\r\n+++\r\n\r\r\r\r\r\r\r\r\r\r\r\r\r\rNO CARRIER\r\n";
  tm.tv_sec = 0;
  tm.tv_nsec = 40000000;

  for(unsigned i = 0; i<strlen(bye);i++)
  {
    printf("%c",bye[i]);
    fflush(stdout);
    nanosleep(&tm,NULL);
  }
  return 0;
}
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
