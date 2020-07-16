/*
** Purpose: Define configurations for the Eyassat_if application.
**
** Notes:
**   1. These macros can only be built with the application and can't
**      have a platform scope because the same file name is used for
**      all applications following the object-based application design.
**
** License:
**   Template written by David McComas and licensed under the GNU
**   Lesser General Public License (LGPL).
**
** References:
**   1. OpenSatKit Object-based Application Developers Guide.
**   2. cFS Application Developer's Guide.
**
*/

#ifndef _app_cfg_
#define _app_cfg_

/*
** Includes
*/

#include "cfe.h"
#include "eyassat_if_platform_cfg.h"
#include "osk_app_fw.h"

/******************************************************************************
** Eyassat_if Application Macros
*/

#define  EYASSAT_IF_MAJOR_VERSION      0
#define  EYASSAT_IF_MINOR_VERSION      9
#define  EYASSAT_IF_REVISION           0
#define  EYASSAT_IF_MISSION_REV        0

/******************************************************************************
** Command Macros
**
*/

#define EYASSATTBL_LOAD_CMD_FC  (CMDMGR_APP_START_FC + 0)
#define EYASSATTBL_DUMP_CMD_FC  (CMDMGR_APP_START_FC + 1)
#define EYASSATOBJ_UINT8_CMD_FC  (CMDMGR_APP_START_FC + 2)
#define EYASSATOBJ_UINT16_CMD_FC  (CMDMGR_APP_START_FC + 3)
#define EYASSATOBJ_FLOAT_CMD_FC  (CMDMGR_APP_START_FC + 4)
#define EYASSATOBJ_DISCRETE_CMD_FC  (CMDMGR_APP_START_FC + 5)
#define EYASSATOBJ_CONNECT_CMD_FC  (CMDMGR_APP_START_FC + 6)
#define EYASSATOBJ_DISCONNECT_CMD_FC  (CMDMGR_APP_START_FC + 7)


/******************************************************************************
** Event Macros
** 
** Define the base event message IDs used by each object/component used by the
** application. There are no automated checks to ensure an ID range is not
** exceeded so it is the developer's responsibility to verify the ranges. 
*/

#define EYASSAT_IF_BASE_EID      (APP_FW_APP_BASE_EID +  0)
#define EYASSATTBL_BASE_EID      (APP_FW_APP_BASE_EID + 10)
#define EYASSATOBJ_BASE_EID      (APP_FW_APP_BASE_EID + 20)


/******************************************************************************
** Example Table Configurations
**
*/

#define EYASSATTBL_MAX_ENTRY_ID 32


// Buffer size for incoming telemetry on the UART
#define EYASSATOBJ_TLM_BUFFER_SIZE 800
#define EYASSATOBJ_CMD_BUFFER_SIZE 100
#define EYASSATOBJ_CONSOLE_NAME_SIZE 32

#endif /* _app_cfg_ */
