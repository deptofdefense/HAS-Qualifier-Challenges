/*
 *  Simple test program -- simplified version of sample test hello.
 */

#include <bsp.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include "io.h"
#include "crc.h"
#include "msglib.h"
#include "mission.h"


const char flag[150]  = "FLAG{No, It's not in the firmware, that would have been too easy. But in the patched version it will be located here, so good that should help...?}";

rtems_task Init(
  rtems_task_argument ignored
)
{
  int err = 0;
  printf("Mission Server: Running\n");
  while (1) 
  {
    if (init_mission())
    {
      printf("Bad Mission Plan, Goodbye\n");
      break;
    }
    err = handlePacket();
    if (err){
      printf("Goodbye: %s %d\n", "Error", err);
      break;
    }
    if (check_mission())
    {
      printf("Bad Mission Plan, Goodbye\n");
      break;
    }
  }

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
