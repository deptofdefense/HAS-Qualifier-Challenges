/*
** Purpose: Define platform configurations for the Eyassat_if application
**
** Notes:
**   None
**
** License:
**   Template written by David McComas and licensed under the GNU
**   Lesser General Public License (LGPL).
**
** References:
**   1. OpenSatKit Object-based Application Developer's Guide.
**   2. cFS Application Developer's Guide.
**
*/

#ifndef _eyassat_if_platform_cfg_
#define _eyassat_if_platform_cfg_

/*
** Includes
*/

#include "eyassat_if_mission_cfg.h"
#include "eyassat_if_msgids.h"
#include "eyassat_if_perfids.h"

/******************************************************************************
** Application Macros
*/

#define  EYASSAT_IF_RUNLOOP_DELAY     1000  /* Delay in milliseconds */

#define  EYASSAT_IF_CMD_PIPE_DEPTH    10
#define  EYASSAT_IF_CMD_PIPE_NAME     "EYASSAT_IF_CMD_PIPE"
// Using UART2 on the LEON3 for interfacing to the EyasSat C&DH board
#define  EYASSAT_CONSOLE_NAME         "/dev/console_b"

/******************************************************************************
** Example Object Macros
*/

#define  EYASSAT_IF_EXTBL_DEF_LOAD_FILE  "/cf/eyassat_if_extbl.json"
#define  EYASSAT_IF_EXTBL_DEF_DUMP_FILE  "/cf/eyassat_if_extbl_d.json"

#endif /* _eyassat_if_platform_cfg_ */
