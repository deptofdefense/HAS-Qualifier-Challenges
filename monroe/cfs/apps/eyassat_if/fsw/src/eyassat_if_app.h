/* 
** Purpose: Define a Eyassat_if application.
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
#ifndef _eyassat_if_app_
#define _eyassat_if_app_

/*
** Includes
*/

#include "app_cfg.h"
#include "eyassat_obj.h"
#include "eyassat_tbl.h"

/*
** Macro Definitions
*/

#define EYASSAT_IF_INIT_INFO_EID            (EYASSAT_IF_BASE_EID + 0)
#define EYASSAT_IF_EXIT_ERR_EID             (EYASSAT_IF_BASE_EID + 1)
#define EYASSAT_IF_CMD_NOOP_INFO_EID        (EYASSAT_IF_BASE_EID + 2)
#define EYASSAT_IF_CMD_INVALID_MID_ERR_EID  (EYASSAT_IF_BASE_EID + 3)

/*
** Type Definitions
*/

typedef struct
{

   CMDMGR_Class       CmdMgr;
   TBLMGR_Class       TblMgr;
   EYASSATOBJ_Class   EyasSatObj;
   EYASSATTBL_Class   EyasSatTbl;
   
   CFE_SB_PipeId_t CmdPipe;

} EYASSAT_IF_Class;

typedef struct
{

   uint8    Header[CFE_SB_TLM_HDR_SIZE];

   /*
   ** CMDMGR Data
   */
   uint16   ValidCmdCnt;
   uint16   InvalidCmdCnt;

   /*
   ** Example Table Data 
   ** - Loaded with status from the last table action 
   */

   uint8    LastAction;
   uint8    LastActionStatus;

   
   /*
   ** EXOBJ Data
   */

   uint16   EyasSatObjExecCnt;

} OS_PACK EYASSAT_IF_HkPkt;
#define EYASSAT_IF_TLM_HK_LEN sizeof (EYASSAT_IF_HkPkt)

typedef struct
{

   uint8    Header[CFE_SB_TLM_HDR_SIZE];
   uint8    PacketId;
   char     CallSign[3];
   char     TimeString[8];
   uint8    TimeDelay;
   uint16   CmdTimeOut;
   uint8    PwrTlm;
   uint8    AdcsTlm;
   uint8    ExpTlm;

} OS_PACK EYASSAT_IF_InternalPkt;
#define EYASSAT_IF_TLM_INTERNAL_LEN sizeof (EYASSAT_IF_InternalPkt)

typedef struct
{

   uint8    Header[CFE_SB_TLM_HDR_SIZE];
   uint8    PacketId;
   char     CallSign[3];
   char     TimeString[8];
   float    DHTemp;
   float    ExpTemp;
   float    RefTemp;
   float    PanelATemp;
   float    PanelBTemp;
   float    BaseTemp;
   float    TopATemp;
   float    TopBTemp;


} OS_PACK EYASSAT_IF_TempPkt;
#define EYASSAT_IF_TLM_TEMP_LEN sizeof (EYASSAT_IF_TempPkt)

typedef struct
{

   uint8    Header[CFE_SB_TLM_HDR_SIZE];
   uint8    PacketId;
   char     CallSign[3];
   char     TimeString[8];
   uint8    SepStatus;
   float    VBatt;
   float    IBatt;
   float    VSA;
   float    ISA;
   float    IMB;
   float    V5V;
   float    I5V;
   float    V3V;
   float    I3V;
   uint16   SwitchStatus;
   float    BattTemp;
   float    SA1Temp;
   float    SA2Temp;
   // PWR_3V, PWR_ADCS, PWR_EXP, PWR_HTR1, PWR_HTR2 are derived telemetry points

} OS_PACK EYASSAT_IF_PowerPkt;
#define EYASSAT_IF_TLM_POWER_LEN sizeof (EYASSAT_IF_PowerPkt)

typedef struct
{

   uint8    Header[CFE_SB_TLM_HDR_SIZE];
   uint8    PacketId;
   char     CallSign[3];
   char     TimeString[8];
   uint8    SepStatus;
   uint16   VBatt;
   uint16   IBatt;
   uint16   VSA;
   uint16   ISA;
   uint16   IMB;
   uint16   V5V;
   uint16   I5V;
   uint16   V3V;
   uint16   I3V;
   uint16   SwitchStatus;
   uint16   BattTemp;
   uint16   SA1Temp;
   uint16   SA2Temp;

} OS_PACK EYASSAT_IF_UnscaledPowerPkt;
#define EYASSAT_IF_TLM_UNSCALED_POWER_LEN sizeof (EYASSAT_IF_UnscaledPowerPkt)

typedef struct
{

   uint8    Header[CFE_SB_TLM_HDR_SIZE];
   uint8    PacketId;
   char     CallSign[3];
   char     TimeString[8];
   uint16   SunTop;
   uint16   SunBottom;
   uint16   Sun0;
   uint16   Sun90;
   uint16   Sun180;
   uint16   Sun270;
   float    YawAng;
   float    SunOffset;
   float    MagX;
   float    MagY;
   float    MagZ;
   float    AccX;
   float    AccY;
   float    AccZ;
   uint8    XRod;
   uint8    YRod;
   float    ActWheelSpd;
   float    CmdWheelSpd;
   uint16   PWM;
   uint16   CtrlAlg;
   float    PConst;
   float    IConst;
   float    DConst;
   float    DeltaT;
   float    DeadBand;
   float    Slope;
   float    Offset;
   float    Extra;
   float    RPSHyst;

} OS_PACK EYASSAT_IF_ADCSPkt;
#define EYASSAT_IF_TLM_ADCS_LEN sizeof (EYASSAT_IF_ADCSPkt)


/*
** Exported Data
*/

extern EYASSAT_IF_Class  Eyassat_if;

/*
** Exported Functions
*/

/******************************************************************************
** Function: EYASSAT_IF_AppMain
**
*/
void EYASSAT_IF_AppMain(void);

#endif /* _eyassat_if_app_ */
