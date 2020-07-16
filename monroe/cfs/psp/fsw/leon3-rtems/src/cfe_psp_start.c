/*
**  GSC-18128-1, "Core Flight Executive Version 6.6"
**
**  Copyright (c) 2006-2019 United States Government as represented by
**  the Administrator of the National Aeronautics and Space Administration.
**  All Rights Reserved.
**
**  Licensed under the Apache License, Version 2.0 (the "License");
**  you may not use this file except in compliance with the License.
**  You may obtain a copy of the License at
**
**    http://www.apache.org/licenses/LICENSE-2.0
**
**  Unless required by applicable law or agreed to in writing, software
**  distributed under the License is distributed on an "AS IS" BASIS,
**  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
**  See the License for the specific language governing permissions and
**  limitations under the License.
*/

/******************************************************************************
** File:  cfe_psp_start.c
**
** Purpose:
**   cFE BSP main entry point.
**
**
******************************************************************************/
#define _USING_RTEMS_INCLUDES_

/*
**  Include Files
*/
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <rtems.h>
#include <rtems/mkrootfs.h>
#include <rtems/bdbuf.h>
#include <rtems/blkdev.h>
#include <rtems/diskdevs.h>
#include <rtems/bdpart.h>
#include <rtems/error.h>
#include <rtems/ramdisk.h>
#include <rtems/dosfs.h>
#include <rtems/fsmount.h>
#include <rtems/shell.h>
#include <rtems/untar.h>
#include <rtems/rtems_bsdnet.h>
#include <rtems/rtems_dhcp_failsafe.h>
#include <rtems/rtl/dlfcn-shell.h>
#include <bsp.h>

#include "eeprom-tar.h"
#include "fs-root-tar.h"


/*
** cFE includes 
*/
#include "common_types.h"
#include "osapi.h"
#include "cfe_psp.h" 
#include "cfe_psp_memory.h"
#include "cfe_psp_module.h"

// extern int rtems_leon_greth_driver_attach(struct rtems_bsdnet_ifconfig *config, int attach);
/* configuration information */

/*
** RTEMS OS Configuration defintions
*/
#define TASK_INTLEVEL 0
#define CONFIGURE_INIT
rtems_task Init (rtems_task_argument argument);
#define CONFIGURE_INIT_TASK_ATTRIBUTES  (RTEMS_FLOATING_POINT | RTEMS_PREEMPT | RTEMS_NO_TIMESLICE | RTEMS_ASR | RTEMS_INTERRUPT_LEVEL(TASK_INTLEVEL))
#define CONFIGURE_INIT_TASK_STACK_SIZE  (64*1024)
#define CONFIGURE_INIT_TASK_PRIORITY    120


/*
 * Note that these resources are shared with RTEMS itself (e.g. the init task, the shell)
 * so they should be allocated slightly higher than the user limits in osconfig.h
 *
 * Many RTEMS services use tasks internally, including the idle task, BSWP, ATA driver,
 * low level console I/O, the shell, TCP/IP network stack, and DHCP (if enabled).
 * Many of these also use semaphores for synchronization.
 *
 * Budgeting for additional:
 *   8 internal tasks
 *   2 internal timers
 *   4 internal queues
 *   16 internal semaphores
 *
 */
#define CONFIGURE_MAXIMUM_TASKS                      (OS_MAX_TASKS + 8)
#define CONFIGURE_MAXIMUM_TIMERS                     (OS_MAX_TIMERS + 2)
#define CONFIGURE_MAXIMUM_SEMAPHORES                 (OS_MAX_BIN_SEMAPHORES + OS_MAX_COUNT_SEMAPHORES + OS_MAX_MUTEXES + 16)
#define CONFIGURE_MAXIMUM_MESSAGE_QUEUES             (OS_MAX_QUEUES + 4)

/*
 * The amount of RAM reserved for the executive workspace.
 * This is for the kernel, and is separate from the C program heap.
 */
#define CONFIGURE_EXECUTIVE_RAM_SIZE    (2*1024*1024)

#define CONFIGURE_RTEMS_INIT_TASKS_TABLE
#define CONFIGURE_APPLICATION_NEEDS_CONSOLE_DRIVER
#define CONFIGURE_APPLICATION_NEEDS_CLOCK_DRIVER
#define CONFIGURE_APPLICATION_EXTRA_DRIVERS RAMDISK_DRIVER_TABLE_ENTRY


#define CONFIGURE_USE_IMFS_AS_BASE_FILESYSTEM
#define CONFIGURE_MAXIMUM_FILE_DESCRIPTORS     (OS_MAX_NUM_OPEN_FILES + 8)

#define CONFIGURE_FILESYSTEM_RFS
#define CONFIGURE_FILESYSTEM_IMFS
#define CONFIGURE_FILESYSTEM_DOSFS
#define CONFIGURE_IMFS_MEMFILE_BYTES_PER_BLOCK    512

// #define CONFIGURE_FILESYSTEM_DEVFS
#define CONFIGURE_DRIVER_AMBAPP_GAISLER_GRETH

#define CONFIGURE_APPLICATION_NEEDS_LIBBLOCK

#define CONFIGURE_MICROSECONDS_PER_TICK              10000

#define CONFIGURE_MAXIMUM_DRIVERS                   10

// #define CONFIGURE_APPLICATION_NEEDS_IDE_DRIVER
// #define CONFIGURE_APPLICATION_NEEDS_ATA_DRIVER
// #define CONFIGURE_ATA_DRIVER_TASK_PRIORITY         9

#define CONFIGURE_MAXIMUM_POSIX_KEYS               4

/* Configure RTEMS */
#include <rtems/confdefs.h>

#include <drvmgr/drvmgr.h>

/* Configure Driver manager */
#if defined(RTEMS_DRVMGR_STARTUP) && defined(LEON3) /* if --drvmgr was given to configure */
 /* Add Timer and UART Driver for this example */
 #ifdef CONFIGURE_APPLICATION_NEEDS_CLOCK_DRIVER
  #define CONFIGURE_DRIVER_AMBAPP_GAISLER_GPTIMER
 #endif
 #ifdef CONFIGURE_APPLICATION_NEEDS_CONSOLE_DRIVER
  #define CONFIGURE_DRIVER_AMBAPP_GAISLER_APBUART
 #endif
#endif
#define CONFIGURE_DRIVER_AMBAPP_GAISLER_GRETH


#define CONFIGURE_SHELL_COMMANDS_INIT
#define CONFIGURE_SHELL_COMMANDS_ALL
#define CONFIGURE_SHELL_MOUNT_MSDOS
#define CONFIGURE_SHELL_MOUNT_RFS

#include <drvmgr/drvmgr_confdefs.h>

#define RTEMS_NUMBER_OF_RAMDISKS 1

#define ENABLE_NETWORK

/* Include driver configurations and system initialization */
#include "config.h"

/*
 * The preferred way to obtain the CFE tunable values at runtime is via
 * the dynamically generated configuration object.  This allows a single build
 * of the PSP to be completely CFE-independent.
 */
#include <target_config.h>

#define CFE_PSP_MAIN_FUNCTION        (*GLOBAL_CONFIGDATA.CfeConfig->SystemMain)
#define CFE_PSP_NONVOL_STARTUP_FILE  (GLOBAL_CONFIGDATA.CfeConfig->NonvolStartupFile)
#define RTEMS_DRIVER_AUTO_MAJOR (0)

/*
** Global variables
*/

/*
 * The RAM Disk configuration.
 */
rtems_ramdisk_config rtems_ramdisk_configuration[RTEMS_NUMBER_OF_RAMDISKS];
// rtems_ramdisk_config rtems_ramdisk_configuration[] =
// {
//   {
//     .block_size = 512,
//     .block_num = 1024
//   }
// };

/*
 * The number of RAM Disk configurations.
*/
size_t rtems_ramdisk_configuration_size = RTEMS_NUMBER_OF_RAMDISKS;

/*
** RAM Disk IO op table.
*/
// rtems_driver_address_table rtems_ramdisk_io_ops =
// {
//   .initialization_entry = ramdisk_initialize,
//   .open_entry =           rtems_blkdev_generic_open,
//   .close_entry =          rtems_blkdev_generic_close,
//   .read_entry =           rtems_blkdev_generic_read,
//   .write_entry =          rtems_blkdev_generic_write,
//   .control_entry =        rtems_blkdev_generic_ioctl
// };

rtems_id          RtemsTimerId;

/*
** 1 HZ Timer "ISR"
*/
int timer_count = 0;

/******************************************************************************
**  Function:  CFE_PSP_Setup()
**
**  Purpose:
**    Perform initial setup.
**
**    This function is invoked before OSAL is initialized.
**      NO OSAL CALLS SHOULD BE USED YET.
**
**    The root file system is created, and mount points are created and mounted:
**     - /ram as ramdisk (RFS), read-write
**     - /boot from /dev/hda1, read-only, contain the boot executable(s) (CFE core)
**
**  Arguments:
**    (none)
**
**  Return:
**    OS error code.  RTEMS_SUCCESSFUL if everything worked.
**
**  Note:
**    If this fails then CFE will not run properly, so a non-success here should
**    stop the boot so the issue can be fixed.  Trying to continue booting usually
**    just obfuscates the issue when something does not work later on.
*/
int CFE_PSP_Setup(void)
{
   int status;
   
   printf( "\n\n*** RTEMS Info ***\n" );
   printf("%s", _Copyright_Notice );
   printf("%s\n\n", _RTEMS_version );
   printf(" Stack size=%d\n", (int)Configuration.stack_space_size );
   printf(" Workspace size=%d\n",   (int) Configuration.work_space_size );
   printf("\n");
   printf( "*** End RTEMS info ***\n\n" );
  
  // /*
  //  * Register the RAM Disk driver.
  //  */
  // printf ("Register RAM Disk Driver: ");
  // sc = rtems_io_register_driver (RTEMS_DRIVER_AUTO_MAJOR,
  //                                &rtems_ramdisk_io_ops,
  //                                &major);
  // if (sc != RTEMS_SUCCESSFUL)
  // {
  //   printf ("error: ramdisk driver not initialised: %s\n",
  //           rtems_status_text (sc));
  //   return 1;
  // }
  // printf ("successful\n");

   /*
   ** Create the RTEMS Root file system
   */
   status = rtems_create_root_fs();
   if (status != RTEMS_SUCCESSFUL)
   {
       printf("Creating Root file system failed: %s\n",rtems_status_text(status));
       return status;
   }

   /*
   ** create the directory mountpoints
   */
   status = mkdir("/ram", S_IFDIR |S_IRWXU | S_IRWXG | S_IRWXO); /* For ramdisk mountpoint */
   if (status != RTEMS_SUCCESSFUL)
   {
       printf("mkdir failed: %s\n", strerror (errno));
       return status;
   }

  //  status = mkdir("/eeprom", S_IFDIR |S_IRWXU | S_IRWXG | S_IRWXO); /* For EEPROM mountpoint */
  //  if (status != RTEMS_SUCCESSFUL)
  //  {
  //      printf("mkdir failed: %s\n", strerror (errno));
  //      return status;
  //  }
   
   /*
    * Register the IDE partition table.
    * This is _optional_ depending on whether a block device is present.
    */
  //  status = rtems_bdpart_register_from_disk("/dev/hda");
  //  if (status != RTEMS_SUCCESSFUL)
  //  {
  //    printf ("Not mounting block device /dev/hda: %s / %s\n",
  //            rtems_status_text (status),strerror(errno));
  //  }
  //  else
  //  {
  //      printf ("Mounting block device /dev/hda1 on /eeprom\n");
  //      status = mount("/dev/hda1", "/eeprom",
  //            RTEMS_FILESYSTEM_TYPE_DOSFS,
  //            RTEMS_FILESYSTEM_READ_ONLY,
  //            NULL);
  //      if (status < 0)
  //      {
  //        printf ("Mount /eeprom failed: %s\n", strerror (errno));
  //        return status;
  //      }
  //  }

   return RTEMS_SUCCESSFUL;
}

/******************************************************************************
**  Function:  CFE_PSP_SetupSystemTimer
**
**  Purpose:
**    BSP system time base and timer object setup.
**    This does the necessary work to start the 1Hz time tick required by CFE
**
**  Arguments:
**    (none)
**
**  Return:
**    (none)
**
** NOTE:
**      The handles to the timebase/timer objects are "start and forget"
**      as they are supposed to run forever as long as CFE runs.
**
**      If needed for e.g. additional timer creation, they can be recovered
**      using an OSAL GetIdByName() call.
**
**      This is preferred anyway -- far cleaner than trying to pass the uint32 value
**      up to the application somehow.
*/

void CFE_PSP_SetupSystemTimer(void)
{
    uint32 SystemTimebase;
    int32  Status;

    Status = OS_TimeBaseCreate(&SystemTimebase, "cFS-Master", NULL);
    if (Status == OS_SUCCESS)
    {
        Status = OS_TimeBaseSet(SystemTimebase, 250000, 250000);
    }


    /*
     * If anything failed, cFE/cFS will not run properly, so a panic is appropriate
     */
    if (Status != OS_SUCCESS)
    {
        OS_printf("CFE_PSP: Error configuring cFS timing: %d\n", (int)Status);
        CFE_PSP_Panic(Status);
    }
}

/**
 * Run the /shell-init script.
 */
void shell_init_script(void)
{
  rtems_status_code sc;
  printf("Running /shell-init....\n\n");
  sc = rtems_shell_script("SHLL", 60 * 1024, 160, "/shell-init", "stdout",
                           0, 1, 1);
  if (sc != RTEMS_SUCCESSFUL)
    printf("error: running shell script: %s (%d)\n",
             rtems_status_text (sc), sc);
}

/*
** A simple entry point to start from the BSP loader
**
** This entry point is used when building an RTEMS+CFE monolithic
** image, which is a single executable containing the RTEMS
** kernel and Core Flight Executive in one file.  In this mode
** the RTEMS BSP invokes the "Init" function directly.
**
** This sets up the root fs and the shell prior to invoking CFE via
** the CFE_PSP_Main() routine.
**
** In a future version this code may be moved into a separate bsp
** integration unit to be more symmetric with the VxWorks implementation.
*/
rtems_task Init(
  rtems_task_argument ignored
)
{

  void *object_id = NULL;
  
  /* Initialize Driver manager and Networking, in config.c */
	system_init();

  	/* Print device topology */	
	drvmgr_print_topo();

	/* Set object_id from GRMON in order print info about a device, the
	 * object ID can be seen in the topology printout.
	 */
	if (object_id != NULL)
		drvmgr_info(object_id, OPTION_INFO_ALL);

   if (CFE_PSP_Setup() != RTEMS_SUCCESSFUL)
   {
       CFE_PSP_Panic(CFE_PSP_ERROR);
   }
   
  //  printf("Unpacking tar filesystem\nThis may take awhile...\n");
  //  if(Untar_FromMemory((char*) fs_root_tar, fs_root_tar_size) != 0) 
  //  {
  //    printf("Can't unpack tar filesystem\n");
  //    exit(1);
  //  }

   printf("Unpacking eeprom filesystem\nThis may take awhile...\n");
   if(Untar_FromMemory((char*) eeprom_tar, eeprom_tar_size) != 0) {
      printf("Can't unpack tar eeprom\n");
      exit(1);
   }

  // printf("Running shell-init script\n");
  // shell_init_script();

   /*
   ** Start the shell early, so it can be be used in case a problem occurs
   */
   if (rtems_shell_init("SHLL", RTEMS_MINIMUM_STACK_SIZE * 4, 100, "/dev/console", false, false, NULL) < 0)
   {
     printf ("shell init failed: %s\n", strerror (errno));
   }

   /* give a small delay to let the shell start,
      avoids having the login prompt show up mid-test,
      and gives a little time for pending output to actually
      be sent to the console in case of a slow port */
   rtems_task_wake_after(50);
   printf("\n\n\n\n");

   /*
   ** Run the PSP Main - this will return when init is complete
   */
   CFE_PSP_Main();

   /*
   ** Wait for anything interesting to happen
   **  (any real work should be done by threads spawned during startup)
   */
   OS_IdleLoop();
}

/******************************************************************************
**  Function:  CFE_PSP_Main()
**
**  Purpose:
**    Application entry point.
**
**    The basic RTEMS system including the root FS and shell (if used) should
**    be running prior to invoking this function.
**
**    This entry point is used when building a separate RTEMS kernel/platform
**    boot image and Core Flight Executive image.  This is the type of deployment
**    used on e.g. VxWorks platforms.
**
**  Arguments:
**    (none)
**
**  Return:
**    (none)
*/

void CFE_PSP_Main(void)
{
   uint32            reset_type;
   uint32            reset_subtype;
   int32 Status;



   /*
   ** Initialize the OS API
   */
   Status = OS_API_Init();
   if (Status != OS_SUCCESS)
   {
       /* irrecoverable error if OS_API_Init() fails. */
       /* note: use printf here, as OS_printf may not work */
       printf("CFE_PSP: OS_API_Init() failure\n");
       CFE_PSP_Panic(Status);
   }

   /*
   ** Initialize the statically linked modules (if any)
   */
   CFE_PSP_ModuleInit();

   /* Prepare the system timing resources */
   CFE_PSP_SetupSystemTimer();

   /*
   ** Determine Reset type by reading the hardware reset register.
   */
   reset_type = CFE_PSP_RST_TYPE_POWERON;
   reset_subtype = CFE_PSP_RST_SUBTYPE_POWER_CYCLE;

   /*
   ** Initialize the reserved memory 
   */
   CFE_PSP_InitProcessorReservedMemory(reset_type);

   /*
   ** Call cFE entry point. This will return when cFE startup
   ** is complete.
   */
   CFE_PSP_MAIN_FUNCTION(reset_type,reset_subtype, 1, CFE_PSP_NONVOL_STARTUP_FILE);

}



extern int rtems_rtl_shell_command (int argc, char* argv[]);
rtems_shell_cmd_t rtems_shell_RTL_Command = {
  .name = "rtl",
  .usage = "rtl COMMAND...",
  .topic = "misc",
  .command = rtems_rtl_shell_command
};
rtems_shell_cmd_t rtems_shell_dlopen_Command = {
  .name = "dlopen",
  .usage = "dlopen COMMAND...",
  .topic = "misc",
  .command = shell_dlopen
};
rtems_shell_cmd_t rtems_shell_dlsym_Command = {
  .name = "dlsym",
  .usage = "dlsym COMMAND...",
  .topic = "misc",
  .command = shell_dlsym
};
#define CONFIGURE_SHELL_USER_COMMANDS   \
    &rtems_shell_RTL_Command,           \
    &rtems_shell_dlopen_Command,           \
    &rtems_shell_dlsym_Command


#include <rtems/shellconfig.h>


