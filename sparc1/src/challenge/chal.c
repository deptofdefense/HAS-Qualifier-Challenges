/*
 *  Simple test program -- simplified version of sample test hello.
 */

#include <bsp.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include "io.h"
#include "crc.h"
#include "asm.h"


//#define DEBUG
#define SLEEP_TIME 1
#define HEADER_LEN 8

const char COOKIE[] = {0xDE,0xAD,0xBE,0xEF};
char ver[64]    = "Space Message Broker v3.1";
char serial[64] = "L54-8012-5511-0";
char flag[150]  = "FLAG{No, It's not in the firmware, that would have been too easy. But in the patched version it will be located here, so good that should help...?}";

static int lastId = 0;

char *lookupStr(unsigned x)
{
  switch (x)
  {
    case 1:
      return ver;
    case 2:
      return serial;
    case 3:
      return flag;
  }
  return NULL;
}


int __attribute__ ((noinline)) handleHeader(char *msg)
{
  if(check_checksum(msg+2))
    hangup("Bad Checksum");

  uint32_t cookie = *(uint32_t *)(msg+4);
  if (cookie != *(uint32_t*)COOKIE)
    hangup("Bad Cookie");

  int id = getMsgId(msg);
  if (id != lastId + 1)
    hangup("Unexpected Msg Id");
  lastId = id;

  return 1;
}

char * __attribute__ ((noinline)) handleGetInfo(char *msg)
{
  unsigned idx  = clipStrIdx(getStrIdx(msg));
  char * str    = lookupStr(idx);
  if (!str)
  {
    hangup("Invalid Config Option");
  }
  return str;
}

void __attribute__ ((noinline)) getFlag(char *msg)
{
  printf("You fell for it...\n");
  hangup("Not trying hard enough!");
}

char * msgHandler(char *stream, int totalLen)
{
  bool hasHeader = false;
  int len = 0; 
  int type;
  char *res;
  //rtems_interrupt_level level;
  
  //rtems_interrupt_disable(level);
  while (totalLen > 0)
  {
    len  = getCmdLen(stream);
    type = getCmdType(stream);

    if (!hasHeader && type != 0)
    {
      hangup("Missing Header");
    }

    switch (type)
    {
      case 0: 
        handleHeader(stream);
        hasHeader = true; 
        break;
      case 1:
        res = handleGetInfo(stream);
        printf("%s\n", res);
        break;
       case 2:
        hangup("Shutdown Requested");
        break;
      case 3: 
        getFlag(stream);
        break;
      default: 
        hangup("Unexpected Message Section");
        break;
    }
    stream   += len;
    totalLen -= len;
    
  }
  //rtems_interrupt_enable(level);
  printf("ACK\n");
  return stream;
}

char msg[256];
rtems_task Init(
  rtems_task_argument ignored
)
{
  lastId = 0;
  printf("Configuration Server: Running\n");
#ifdef DEBUG
  // { Header Len | Header Type || Checksum | Checksum Len || Cookie_32 || msgId } { Section Len | Get Config Type | Str Index } || CRC Fix 
  msgHandler("\x0a\x00\x0b\x4a\xde\xad\xbe\xef\x00\x01\x03\x01\x01\x02\x02", 0x10);
#else
  int len = 0;
  while (true)
  {
    sleep(SLEEP_TIME);

    // Read Message
    len = readMsg(msg, 64);
    
    // Handle message, starting from header
    msgHandler(msg, len);

  }
#endif
  exit(0);
}

/* configuration information */

#define CONFIGURE_APPLICATION_NEEDS_CONSOLE_DRIVER
#define CONFIGURE_APPLICATION_NEEDS_CLOCK_DRIVER
//#define CONFIGURE_APPLICATION_DOES_NOT_NEED_CLOCK_DRIVER

#define CONFIGURE_RTEMS_INIT_TASKS_TABLE

#define CONFIGURE_MAXIMUM_TASKS 1

#define CONFIGURE_INIT
#include <rtems/confdefs.h>
/* end of file */
