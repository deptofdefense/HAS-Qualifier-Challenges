/*
** Purpose: Define an example object.
**
** Notes:
**   1. This object is to show how an object is integrated into 
**      the opensat application framework.
**
** License:
**   Template written by David McComas and licensed under the GNU
**   Lesser General Public License (LGPL).
**
** References:
**   1. OpenSatKit Object-based Application Developer's Guide.
**   2. cFS Application Developer's Guide.
*/

#ifndef _eyassatobj_
#define _eyassatobj_

/*
** Includes
*/
#include <termios.h>
#include "app_cfg.h"
#include "eyassat_tbl.h"

/*
** Event Message IDs
*/

#define EYASSATOBJ_CMD_ENA_INFO_EID  (EYASSATOBJ_BASE_EID + 0)
#define EYASSATOBJ_CMD_INFO_EID (EYASSATOBJ_BASE_EID + 1)
#define EYASSATOBJ_DEBUG_EID    (EYASSATOBJ_BASE_EID + 2)
#define EYASSATOBJ_CONNECT_EID    (EYASSATOBJ_BASE_EID + 3)
/*
** Type Definitions
*/
typedef struct
{
   uint8    PacketId;
   char     CallSign[3];
   char     TimeString[8];
   uint8    TimeDelay;
   uint16   CmdTimeOut;
   uint8    PwrTlm;
   uint8    AdcsTlm;
   uint8    ExpTlm;

} EYASSATOBJ_InternalPkt;
#define EYASSATOBJ_INTERNAL_LEN sizeof (EYASSATOBJ_InternalPkt)

typedef struct
{
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


} EYASSATOBJ_TempPkt;
#define EYASSATOBJ_TEMP_LEN sizeof (EYASSATOBJ_TempPkt)

typedef struct
{
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

} EYASSATOBJ_PowerPkt;
#define EYASSATOBJ_POWER_LEN sizeof (EYASSATOBJ_PowerPkt)

typedef struct
{
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

} EYASSATOBJ_UnscaledPowerPkt;
#define EYASSATOBJ_UNSCALED_POWER_LEN sizeof (EYASSATOBJ_UnscaledPowerPkt)

typedef struct
{
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
   float  RPSHyst;

} EYASSATOBJ_ADCSPkt;

#define EYASSATOBJ_ADCS_LEN sizeof (EYASSATOBJ_ADCSPkt)



/******************************************************************************
** EyasSatObj_Class
*/

typedef struct {

   uint16       ExecCnt;

   EYASSATTBL_Struct Tbl;
   EYASSATOBJ_InternalPkt InternalPkt;
   EYASSATOBJ_TempPkt TempPkt;
   EYASSATOBJ_PowerPkt PowerPkt;
   EYASSATOBJ_UnscaledPowerPkt UnscaledPowerPkt;
   EYASSATOBJ_ADCSPkt ADCSPkt;

   struct termios term;
   char telemetryBuffer[EYASSATOBJ_TLM_BUFFER_SIZE];
   char commandBuffer[EYASSATOBJ_CMD_BUFFER_SIZE];
   int fd; // File descriptor for telemetry UART connection
   char ConsoleName[EYASSATOBJ_CONSOLE_NAME_SIZE];
   int DisconnectCount;
   bool connected;

} EYASSATOBJ_Class;


/******************************************************************************
** Command Functions
*/

typedef struct
{

   uint8   CmdHeader[CFE_SB_CMD_HDR_SIZE];
   uint16  Parameter;

} EYASSATOBJ_DemoCmdMsg;
#define EYASSATOBJ_DEMO_CMD_DATA_LEN  (sizeof(EYASSATOBJ_DemoCmdMsg) - CFE_SB_CMD_HDR_SIZE)

typedef struct
{

   uint8   CmdHeader[CFE_SB_CMD_HDR_SIZE];
   char    CmdCode[2];

} OS_PACK EYASSATOBJ_DiscreteCmdMsg;
#define EYASSATOBJ_DISCRETE_CMD_DATA_LEN  (sizeof(EYASSATOBJ_DiscreteCmdMsg) - CFE_SB_CMD_HDR_SIZE)

typedef struct
{

   uint8   CmdHeader[CFE_SB_CMD_HDR_SIZE];
   char    CmdCode[2];
   uint8   CmdParameter;

} OS_PACK EYASSATOBJ_Uint8CmdMsg;
#define EYASSATOBJ_UINT8_CMD_DATA_LEN  (sizeof(EYASSATOBJ_Uint8CmdMsg) - CFE_SB_CMD_HDR_SIZE)

typedef struct
{

   uint8   CmdHeader[CFE_SB_CMD_HDR_SIZE];
   char    CmdCode[2];
   uint16  CmdParameter;

} OS_PACK EYASSATOBJ_Uint16CmdMsg;
#define EYASSATOBJ_UINT16_CMD_DATA_LEN  (sizeof(EYASSATOBJ_Uint16CmdMsg) - CFE_SB_CMD_HDR_SIZE)

typedef struct
{

   uint8   CmdHeader[CFE_SB_CMD_HDR_SIZE];
   char    CmdCode[2];
   float   CmdParameter;

} OS_PACK EYASSATOBJ_FloatCmdMsg;
#define EYASSATOBJ_FLOAT_CMD_DATA_LEN  (sizeof(EYASSATOBJ_FloatCmdMsg) - CFE_SB_CMD_HDR_SIZE)

typedef struct
{

   uint8   CmdHeader[CFE_SB_CMD_HDR_SIZE];

} OS_PACK EYASSATOBJ_ConnectCmdMsg;
#define EYASSATOBJ_CONNECT_CMD_DATA_LEN  (sizeof(EYASSATOBJ_ConnectCmdMsg) - CFE_SB_CMD_HDR_SIZE)

typedef struct
{

   uint8   CmdHeader[CFE_SB_CMD_HDR_SIZE];

} OS_PACK EYASSATOBJ_DisconnectCmdMsg;
#define EYASSATOBJ_DISCONNECT_CMD_DATA_LEN  (sizeof(EYASSATOBJ_DisconnectCmdMsg) - CFE_SB_CMD_HDR_SIZE)

/*
** Exported Functions
*/

/******************************************************************************
** Function: EYASSATOBJ_Constructor
**
** Initialize the example object to a known state
**
** Notes:
**   1. This must be called prior to any other function.
**   2. The table values are not populated. This is done when the table is 
**      registered with the table manager.
**
*/
void EYASSATOBJ_Constructor(EYASSATOBJ_Class *EyasSatObjPtr, const char* ConsoleName);


/******************************************************************************
** Function: EYASSATOBJ_Execute
**
** Execute main object function.
**
*/
void EYASSATOBJ_Execute(void);

/******************************************************************************
** Function: EYASSATOBJ_ConsoleConnect
**
** Connect to EyasSat console.
**
*/
void EYASSATOBJ_ConsoleConnect(void);

/******************************************************************************
** Function: EYASSATOBJ_ConsoleDisconnect
**
** Closes EyasSat console file descriptor
**
*/
void EYASSATOBJ_ConsoleDisconnect(void);

/******************************************************************************
** Function: EYASSATOBJ_ProcessTelemetry
**
** Process telemetry messages from EyasSat C&DH board.
**
*/
void EYASSATOBJ_ProcessTelemetry(void);

/******************************************************************************
** Function: ProcessPacketGroup
** 
** Receives an entire group of EyasSat packets per processing cycle
** Based on the packet id, it calls the appropriate processing function
**
*/
void EYASSATOBJ_ProcessPacketGroup(char *tlmBuffer, int totalBytesRead);

/******************************************************************************
** Function: EYASSATOBJ_ProcessInternalPacket
** 
** Processes the EyasSat Internal telemetry packet and populates the appropriate structure
**
*/
void EYASSATOBJ_ProcessInternalPacket(char *packetBuffer);

/******************************************************************************
** Function: EYASSATOBJ_ProcessTempPacket
** 
** Processes the EyasSat Temperature telemetry packet and populates the appropriate structure
**
*/
void EYASSATOBJ_ProcessTempPacket(char *packetBuffer);

/******************************************************************************
** Function: EYASSATOBJ_ProcessPowerPacket
** 
** Processes the EyasSat Power telemetry packet and populates the appropriate structure
**
*/
void EYASSATOBJ_ProcessPowerPacket(char *packetBuffer);

/******************************************************************************
** Function: EYASSATOBJ_ProcessADCSPacket
** 
** Processes the EyasSat ADCS telemetry packet and populates the appropriate structure
**
*/
void EYASSATOBJ_ProcessADCSPacket(char *packetBuffer);

/******************************************************************************
** Function: EYASSATOBJ_SendCommands
**
** Send command to EyasSat C&DH board.
**
*/
void EYASSATOBJ_SendCommand(int cmdLength);

/******************************************************************************
** Function: EYASSATOBJ_ResetStatus
**
** Reset counters and status flags to a known reset state.
**
** Notes:
**   1. Any counter or variable that is reported in HK telemetry that doesn't
**      change the functional behavior should be reset.
**
*/
void EYASSATOBJ_ResetStatus(void);

/******************************************************************************
** Function: EYASSATOBJ_GetTblPtr
**
** Get pointer to EyasSatObj's table data
**
** Note:
**  1. This function must match the EXTBL_GetTblPtr definition.
**  2. Supplied as a callback to ExTbl.
*/
const EYASSATTBL_Struct* EYASSATOBJ_GetTblPtr(void);


/******************************************************************************
** Function: EYASSATOBJ_LoadTbl
**
** Load data into EyasSatObj's example table.
**
** Note:
**  1. This function must match the EXTBL_LoadTblFunc definition.
**  2. Supplied as a callback to ExTbl.
*/
boolean EYASSATOBJ_LoadTbl (EYASSATTBL_Struct* NewTbl);


/******************************************************************************
** Function: EYASSATOBJ_LoadEntry
**
** Load data into EyasSatObj's example table.
**
** Note:
**  1. This function must match the EXTBL_LoadEntryFunc definition.
**  2. Supplied as a callback to ExTbl.
*/
boolean EYASSATOBJ_LoadTblEntry (uint16 EntryId, EYASSATTBL_Entry* TblEntry);


/******************************************************************************
** Function: EYASSATOBJ_DemoCmd
**
** Demonstrate an 'entity' object having a command.
**
** Note:
**  1. This function must comply with the CMDMGR_CmdFuncPtr definition
*/
boolean EYASSATOBJ_DemoCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr);

/******************************************************************************
** Function: EYASSATOBJ_DiscreteCmd
**
** Process EyasSat command messages with no command parameters
**
*/
boolean EYASSATOBJ_DiscreteCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr);

/******************************************************************************
** Function: EYASSATOBJ_Uint8Cmd
**
** Process EyasSat command messages with uint8 command parameters
**
*/
boolean EYASSATOBJ_Uint8Cmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr);

/******************************************************************************
** Function: EYASSATOBJ_Uint16Cmd
**
** Process EyasSat command messages with uint16 command parameters
**
*/
boolean EYASSATOBJ_Uint16Cmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr);

/******************************************************************************
** Function: EYASSATOBJ_FloatCmd
**
** Process EyasSat command messages with float command parameters
**
*/
boolean EYASSATOBJ_FloatCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr);

/******************************************************************************
** Function: EYASSATOBJ_ConnectCmd
**
** Command to connect to the EyasSat UART port. Connection occurs on startup
** This commmand is only required if a disconnect has been performed manually
** or for some reason we have been connnected and then disconnected and exceeded
** a reconnect count of 5. 
**
*/
boolean EYASSATOBJ_ConnectCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr);

/******************************************************************************
** Function: EYASSATOBJ_DisconnectCmd
**
** Command to disconnect from the EyasSat UART port.
**
*/
boolean EYASSATOBJ_DisconnectCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr);

#endif /* _eyassatobj_ */
