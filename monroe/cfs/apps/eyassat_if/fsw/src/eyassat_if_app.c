/* 
** Purpose: Implement a Eyassat_if application.
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

/*
** Includes
*/

#include <string.h>
#include "eyassat_if_app.h"


/*
** Local Function Prototypes
*/

static int32 InitApp(void);
static void ProcessCommands(void);

/*
** Global Data
*/

EYASSAT_IF_Class  Eyassat_if;
EYASSAT_IF_HkPkt  Eyassat_ifHkPkt;
EYASSAT_IF_InternalPkt Eyassat_ifInternalPkt;
EYASSAT_IF_TempPkt   Eyassat_ifTempPkt;
EYASSAT_IF_PowerPkt  Eyassat_ifPowerPkt;
EYASSAT_IF_UnscaledPowerPkt Eyassat_ifUnscaledPowerPkt;
EYASSAT_IF_ADCSPkt   Eyassat_ifADCSPkt;

/*
** Convenience Macros
*/

#define  CMDMGR_OBJ      (&(Eyassat_if.CmdMgr))
#define  TBLMGR_OBJ      (&(Eyassat_if.TblMgr))
#define  EYASSAT_OBJ     (&(Eyassat_if.EyasSatObj))
#define  EYASSAT_TBL     (&(Eyassat_if.EyasSatTbl))

/******************************************************************************
** Function: EYASSAT_IF_AppMain
**
*/
void EYASSAT_IF_AppMain(void)
{

   int32  Status    = CFE_SEVERITY_ERROR;
   uint32 RunStatus = CFE_ES_APP_ERROR;


   CFE_ES_PerfLogEntry(EYASSAT_IF_MAIN_PERF_ID);
   Status = CFE_ES_RegisterApp();
   CFE_EVS_Register(NULL,0,0);


   /*
   ** Perform application specific initialization
   */
   if (Status == CFE_SUCCESS)
   {
       Status = InitApp();
   }

   /*
   ** At this point many flight apps use CFE_ES_WaitForStartupSync() to
   ** synchronize their startup timing with other apps. This is not
   ** needed for this simple app.
   */

   if (Status == CFE_SUCCESS) RunStatus = CFE_ES_APP_RUN;

   /*
   ** Main process loop
   */
   while (CFE_ES_RunLoop(&RunStatus))
   {

      /*
      ** This is just a an example loop. There are many ways to control the
      ** main loop execution flow.
      */
     
	  CFE_ES_PerfLogExit(EYASSAT_IF_MAIN_PERF_ID);
      OS_TaskDelay(EYASSAT_IF_RUNLOOP_DELAY);
      CFE_ES_PerfLogEntry(EYASSAT_IF_MAIN_PERF_ID);
      // OS_time_t LocalTime;
      // CFE_PSP_GetTime(&LocalTime);
      // printf("Execute start at: %d.%d\n", LocalTime.seconds, LocalTime.microsecs);
      EYASSATOBJ_Execute();
      // CFE_PSP_GetTime(&LocalTime);
      // printf("Execute complete at: %d.%d\n", LocalTime.seconds, LocalTime.microsecs);
      ProcessCommands();

   } /* End CFE_ES_RunLoop */


   /* Write to system log in case events not working */

   CFE_ES_WriteToSysLog("EYASSAT_IF Terminating, RunLoop status = 0x%08X\n", RunStatus);

   CFE_EVS_SendEvent(EYASSAT_IF_EXIT_ERR_EID, CFE_EVS_CRITICAL, "EYASSAT_IF Terminating,  RunLoop status = 0x%08X", RunStatus);

   CFE_ES_PerfLogExit(EYASSAT_IF_MAIN_PERF_ID);
   CFE_ES_ExitApp(RunStatus);  /* Let cFE kill the task (and any child tasks) */

} /* End of EYASSAT_IF_Main() */


/******************************************************************************
** Function: EYASSAT_IF_NoOpCmd
**
** Function signature must match CMDMGR_CmdFuncPtr typedef 
*/

boolean EYASSAT_IF_NoOpCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr)
{

   CFE_EVS_SendEvent (EYASSAT_IF_CMD_NOOP_INFO_EID,
                      CFE_EVS_INFORMATION,
                      "No operation command received for EYASSAT_IF version %d.%d",
                      EYASSAT_IF_MAJOR_VERSION,EYASSAT_IF_MINOR_VERSION);

   return TRUE;


} /* End EYASSAT_IF_NoOpCmd() */


/******************************************************************************
** Function: EYASSAT_IF_ResetAppCmd
**
** Function signature must match CMDMGR_CmdFuncPtr typedef 
*/

boolean EYASSAT_IF_ResetAppCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr)
{

   CMDMGR_ResetStatus(CMDMGR_OBJ);
   TBLMGR_ResetStatus(TBLMGR_OBJ);
   EYASSATTBL_ResetStatus();
   EYASSATOBJ_ResetStatus();

   return TRUE;

} /* End EYASSAT_IF_ResetAppCmd() */


/******************************************************************************
** Function: EYASSAT_IF_SendHousekeepingPkt
**
*/
void EYASSAT_IF_SendHousekeepingPkt(void)
{

   /* Good design practice in case app expands to more than one table */
   const TBLMGR_Tbl* LastTbl = TBLMGR_GetLastTblStatus(TBLMGR_OBJ);

   
   /*
   ** CMDMGR Data
   */

   Eyassat_ifHkPkt.ValidCmdCnt   = Eyassat_if.CmdMgr.ValidCmdCnt;
   Eyassat_ifHkPkt.InvalidCmdCnt = Eyassat_if.CmdMgr.InvalidCmdCnt;

   
   /*
   ** EXTBL/EXOBJ Data
   ** - At a minimum all OBJECT variables effected by a reset must be included
   */

   Eyassat_ifHkPkt.LastAction       = LastTbl->LastAction;
   Eyassat_ifHkPkt.LastActionStatus = LastTbl->LastActionStatus;

   Eyassat_ifHkPkt.EyasSatObjExecCnt = Eyassat_if.EyasSatObj.ExecCnt;

   CFE_SB_TimeStampMsg((CFE_SB_Msg_t *) &Eyassat_ifHkPkt);
   CFE_SB_SendMsg((CFE_SB_Msg_t *) &Eyassat_ifHkPkt);

} /* End EYASSAT_IF_SendHousekeepingPkt() */

/******************************************************************************
** Function: EYASSAT_IF_SendInternalPkt
**
*/
void EYASSAT_IF_SendInternalPkt(void)
{

   Eyassat_ifInternalPkt.PacketId = Eyassat_if.EyasSatObj.InternalPkt.PacketId;
   strncpy(Eyassat_ifInternalPkt.CallSign, Eyassat_if.EyasSatObj.InternalPkt.CallSign, sizeof(Eyassat_ifInternalPkt.CallSign));
   strncpy(Eyassat_ifInternalPkt.TimeString, Eyassat_if.EyasSatObj.InternalPkt.TimeString, sizeof(Eyassat_ifInternalPkt.TimeString));
   Eyassat_ifInternalPkt.TimeDelay = Eyassat_if.EyasSatObj.InternalPkt.TimeDelay;
   Eyassat_ifInternalPkt.CmdTimeOut = Eyassat_if.EyasSatObj.InternalPkt.CmdTimeOut;
   Eyassat_ifInternalPkt.PwrTlm = Eyassat_if.EyasSatObj.InternalPkt.PwrTlm;
   Eyassat_ifInternalPkt.AdcsTlm = Eyassat_if.EyasSatObj.InternalPkt.AdcsTlm;
   Eyassat_ifInternalPkt.ExpTlm = Eyassat_if.EyasSatObj.InternalPkt.ExpTlm;
   

   CFE_SB_TimeStampMsg((CFE_SB_Msg_t *) &Eyassat_ifInternalPkt);
   CFE_SB_SendMsg((CFE_SB_Msg_t *) &Eyassat_ifInternalPkt);

} /* End EYASSAT_IF_SendInternalPkt() */


/******************************************************************************
** Function: EYASSAT_IF_SendTempPkt
**
*/
void EYASSAT_IF_SendTempPkt(void)
{

   Eyassat_ifTempPkt.PacketId = Eyassat_if.EyasSatObj.TempPkt.PacketId;
   strncpy(Eyassat_ifTempPkt.CallSign, Eyassat_if.EyasSatObj.TempPkt.CallSign, sizeof(Eyassat_ifTempPkt.CallSign));
   strncpy(Eyassat_ifTempPkt.TimeString, Eyassat_if.EyasSatObj.TempPkt.TimeString, sizeof(Eyassat_ifTempPkt.TimeString));
   Eyassat_ifTempPkt.DHTemp = Eyassat_if.EyasSatObj.TempPkt.DHTemp;
   Eyassat_ifTempPkt.ExpTemp = Eyassat_if.EyasSatObj.TempPkt.ExpTemp;
   Eyassat_ifTempPkt.RefTemp = Eyassat_if.EyasSatObj.TempPkt.RefTemp;
   Eyassat_ifTempPkt.PanelATemp = Eyassat_if.EyasSatObj.TempPkt.PanelATemp;
   Eyassat_ifTempPkt.PanelBTemp = Eyassat_if.EyasSatObj.TempPkt.PanelBTemp;
   Eyassat_ifTempPkt.BaseTemp = Eyassat_if.EyasSatObj.TempPkt.BaseTemp;
   Eyassat_ifTempPkt.TopATemp = Eyassat_if.EyasSatObj.TempPkt.TopATemp;
   Eyassat_ifTempPkt.TopBTemp = Eyassat_if.EyasSatObj.TempPkt.TopBTemp;

   CFE_SB_TimeStampMsg((CFE_SB_Msg_t *) &Eyassat_ifTempPkt);
   CFE_SB_SendMsg((CFE_SB_Msg_t *) &Eyassat_ifTempPkt);

} /* End EYASSAT_IF_SendTempPkt() */

/******************************************************************************
** Function: EYASSAT_IF_SendPowerPkt
**
*/
void EYASSAT_IF_SendPowerPkt(void)
{

   Eyassat_ifPowerPkt.PacketId = Eyassat_if.EyasSatObj.PowerPkt.PacketId;
   strncpy(Eyassat_ifPowerPkt.CallSign, Eyassat_if.EyasSatObj.PowerPkt.CallSign, sizeof(Eyassat_ifPowerPkt.CallSign));
   strncpy(Eyassat_ifPowerPkt.TimeString, Eyassat_if.EyasSatObj.PowerPkt.TimeString, sizeof(Eyassat_ifPowerPkt.TimeString));
   Eyassat_ifPowerPkt.SepStatus = Eyassat_if.EyasSatObj.PowerPkt.SepStatus;
   Eyassat_ifPowerPkt.VBatt = Eyassat_if.EyasSatObj.PowerPkt.VBatt;
   Eyassat_ifPowerPkt.IBatt = Eyassat_if.EyasSatObj.PowerPkt.IBatt;
   Eyassat_ifPowerPkt.VSA = Eyassat_if.EyasSatObj.PowerPkt.VSA;
   Eyassat_ifPowerPkt.ISA = Eyassat_if.EyasSatObj.PowerPkt.ISA;
   Eyassat_ifPowerPkt.IMB = Eyassat_if.EyasSatObj.PowerPkt.IMB;
   Eyassat_ifPowerPkt.V5V = Eyassat_if.EyasSatObj.PowerPkt.V5V;
   Eyassat_ifPowerPkt.I5V = Eyassat_if.EyasSatObj.PowerPkt.I5V;
   Eyassat_ifPowerPkt.V3V = Eyassat_if.EyasSatObj.PowerPkt.V3V;
   Eyassat_ifPowerPkt.I3V = Eyassat_if.EyasSatObj.PowerPkt.I3V;
   Eyassat_ifPowerPkt.SwitchStatus = Eyassat_if.EyasSatObj.PowerPkt.SwitchStatus;
   Eyassat_ifPowerPkt.BattTemp = Eyassat_if.EyasSatObj.PowerPkt.BattTemp;
   Eyassat_ifPowerPkt.SA1Temp = Eyassat_if.EyasSatObj.PowerPkt.SA1Temp;
   Eyassat_ifPowerPkt.SA2Temp = Eyassat_if.EyasSatObj.PowerPkt.SA2Temp;

   CFE_SB_TimeStampMsg((CFE_SB_Msg_t *) &Eyassat_ifPowerPkt);
   CFE_SB_SendMsg((CFE_SB_Msg_t *) &Eyassat_ifPowerPkt);

} /* End EYASSAT_IF_SendPowerPkt() */

/******************************************************************************
** Function: EYASSAT_IF_SendPowerPkt
**
*/
void EYASSAT_IF_SendUnscaledPowerPkt(void)
{

   Eyassat_ifUnscaledPowerPkt.PacketId = Eyassat_if.EyasSatObj.UnscaledPowerPkt.PacketId;
   strncpy(Eyassat_ifUnscaledPowerPkt.CallSign, Eyassat_if.EyasSatObj.UnscaledPowerPkt.CallSign, sizeof(Eyassat_ifUnscaledPowerPkt.CallSign));
   strncpy(Eyassat_ifUnscaledPowerPkt.TimeString, Eyassat_if.EyasSatObj.UnscaledPowerPkt.TimeString, sizeof(Eyassat_ifUnscaledPowerPkt.TimeString));
   Eyassat_ifUnscaledPowerPkt.SepStatus = Eyassat_if.EyasSatObj.UnscaledPowerPkt.SepStatus;
   Eyassat_ifUnscaledPowerPkt.VBatt = Eyassat_if.EyasSatObj.UnscaledPowerPkt.VBatt;
   Eyassat_ifUnscaledPowerPkt.IBatt = Eyassat_if.EyasSatObj.UnscaledPowerPkt.IBatt;
   Eyassat_ifUnscaledPowerPkt.VSA = Eyassat_if.EyasSatObj.UnscaledPowerPkt.VSA;
   Eyassat_ifUnscaledPowerPkt.ISA = Eyassat_if.EyasSatObj.UnscaledPowerPkt.ISA;
   Eyassat_ifUnscaledPowerPkt.IMB = Eyassat_if.EyasSatObj.UnscaledPowerPkt.IMB;
   Eyassat_ifUnscaledPowerPkt.V5V = Eyassat_if.EyasSatObj.UnscaledPowerPkt.V5V;
   Eyassat_ifUnscaledPowerPkt.I5V = Eyassat_if.EyasSatObj.UnscaledPowerPkt.I5V;
   Eyassat_ifUnscaledPowerPkt.V3V = Eyassat_if.EyasSatObj.UnscaledPowerPkt.V3V;
   Eyassat_ifUnscaledPowerPkt.I3V = Eyassat_if.EyasSatObj.UnscaledPowerPkt.I3V;
   Eyassat_ifUnscaledPowerPkt.SwitchStatus = Eyassat_if.EyasSatObj.UnscaledPowerPkt.SwitchStatus;
   Eyassat_ifUnscaledPowerPkt.BattTemp = Eyassat_if.EyasSatObj.UnscaledPowerPkt.BattTemp;
   Eyassat_ifUnscaledPowerPkt.SA1Temp = Eyassat_if.EyasSatObj.UnscaledPowerPkt.SA1Temp;
   Eyassat_ifUnscaledPowerPkt.SA2Temp = Eyassat_if.EyasSatObj.UnscaledPowerPkt.SA2Temp;

   CFE_SB_TimeStampMsg((CFE_SB_Msg_t *) &Eyassat_ifUnscaledPowerPkt);
   CFE_SB_SendMsg((CFE_SB_Msg_t *) &Eyassat_ifUnscaledPowerPkt);

} /* End EYASSAT_IF_SendUnscaledPowerPkt() */

/******************************************************************************
** Function: EYASSAT_IF_SendADCSPkt
**
*/
void EYASSAT_IF_SendADCSPkt(void)
{

   Eyassat_ifADCSPkt.PacketId = Eyassat_if.EyasSatObj.ADCSPkt.PacketId;
   strncpy(Eyassat_ifADCSPkt.CallSign, Eyassat_if.EyasSatObj.ADCSPkt.CallSign, sizeof(Eyassat_ifADCSPkt.CallSign));
   strncpy(Eyassat_ifADCSPkt.TimeString, Eyassat_if.EyasSatObj.ADCSPkt.TimeString, sizeof(Eyassat_ifADCSPkt.TimeString));
   Eyassat_ifADCSPkt.SunTop = Eyassat_if.EyasSatObj.ADCSPkt.SunTop;
   Eyassat_ifADCSPkt.SunBottom = Eyassat_if.EyasSatObj.ADCSPkt.SunBottom;
   Eyassat_ifADCSPkt.Sun0 = Eyassat_if.EyasSatObj.ADCSPkt.Sun0;
   Eyassat_ifADCSPkt.Sun90 = Eyassat_if.EyasSatObj.ADCSPkt.Sun90;
   Eyassat_ifADCSPkt.Sun180 = Eyassat_if.EyasSatObj.ADCSPkt.Sun180;
   Eyassat_ifADCSPkt.Sun270 = Eyassat_if.EyasSatObj.ADCSPkt.Sun270;
   Eyassat_ifADCSPkt.YawAng = Eyassat_if.EyasSatObj.ADCSPkt.YawAng;
   Eyassat_ifADCSPkt.SunOffset = Eyassat_if.EyasSatObj.ADCSPkt.SunOffset;
   Eyassat_ifADCSPkt.MagX = Eyassat_if.EyasSatObj.ADCSPkt.MagX;
   Eyassat_ifADCSPkt.MagY = Eyassat_if.EyasSatObj.ADCSPkt.MagY;
   Eyassat_ifADCSPkt.MagZ = Eyassat_if.EyasSatObj.ADCSPkt.MagZ;
   Eyassat_ifADCSPkt.AccX = Eyassat_if.EyasSatObj.ADCSPkt.AccX;
   Eyassat_ifADCSPkt.AccY = Eyassat_if.EyasSatObj.ADCSPkt.AccY;
   Eyassat_ifADCSPkt.AccZ = Eyassat_if.EyasSatObj.ADCSPkt.AccZ;
   Eyassat_ifADCSPkt.XRod = Eyassat_if.EyasSatObj.ADCSPkt.XRod;
   Eyassat_ifADCSPkt.YRod = Eyassat_if.EyasSatObj.ADCSPkt.YRod;
   Eyassat_ifADCSPkt.ActWheelSpd = Eyassat_if.EyasSatObj.ADCSPkt.ActWheelSpd;
   Eyassat_ifADCSPkt.CmdWheelSpd = Eyassat_if.EyasSatObj.ADCSPkt.CmdWheelSpd;
   Eyassat_ifADCSPkt.PWM = Eyassat_if.EyasSatObj.ADCSPkt.PWM;
   Eyassat_ifADCSPkt.CtrlAlg = Eyassat_if.EyasSatObj.ADCSPkt.CtrlAlg;
   Eyassat_ifADCSPkt.PConst = Eyassat_if.EyasSatObj.ADCSPkt.PConst;
   Eyassat_ifADCSPkt.IConst = Eyassat_if.EyasSatObj.ADCSPkt.IConst;
   Eyassat_ifADCSPkt.DConst = Eyassat_if.EyasSatObj.ADCSPkt.DConst;
   Eyassat_ifADCSPkt.DeltaT = Eyassat_if.EyasSatObj.ADCSPkt.DeltaT;
   Eyassat_ifADCSPkt.DeadBand = Eyassat_if.EyasSatObj.ADCSPkt.DeadBand;
   Eyassat_ifADCSPkt.Slope = Eyassat_if.EyasSatObj.ADCSPkt.Slope;
   Eyassat_ifADCSPkt.Offset = Eyassat_if.EyasSatObj.ADCSPkt.Offset;
   Eyassat_ifADCSPkt.Extra = Eyassat_if.EyasSatObj.ADCSPkt.Extra;
   Eyassat_ifADCSPkt.RPSHyst = Eyassat_if.EyasSatObj.ADCSPkt.RPSHyst;

   CFE_SB_TimeStampMsg((CFE_SB_Msg_t *) &Eyassat_ifADCSPkt);
   CFE_SB_SendMsg((CFE_SB_Msg_t *) &Eyassat_ifADCSPkt);

} /* End EYASSAT_IF_SendADCSPkt() */

/******************************************************************************
** Function: InitApp
**
*/
static int32 InitApp(void)
{
    int32 Status = CFE_SUCCESS;

    
    /*
    ** Initialize 'entity' objects
    */

    EYASSATTBL_Constructor(EYASSAT_TBL, EYASSATOBJ_GetTblPtr, EYASSATOBJ_LoadTbl, EYASSATOBJ_LoadTblEntry);
    EYASSATOBJ_Constructor(EYASSAT_OBJ, EYASSAT_CONSOLE_NAME);

    /*
    ** Initialize cFE interfaces 
    */

    CFE_SB_CreatePipe(&Eyassat_if.CmdPipe, EYASSAT_IF_CMD_PIPE_DEPTH, EYASSAT_IF_CMD_PIPE_NAME);
    CFE_SB_Subscribe(EYASSAT_IF_CMD_MID, Eyassat_if.CmdPipe);
    CFE_SB_Subscribe(EYASSAT_IF_SEND_HK_MID, Eyassat_if.CmdPipe);

    /*
    ** Initialize App Framework Components 
    */

    CMDMGR_Constructor(CMDMGR_OBJ);
    CMDMGR_RegisterFunc(CMDMGR_OBJ, CMDMGR_NOOP_CMD_FC,  NULL, EYASSAT_IF_NoOpCmd,     0);
    CMDMGR_RegisterFunc(CMDMGR_OBJ, CMDMGR_RESET_CMD_FC, NULL, EYASSAT_IF_ResetAppCmd, 0);
    
    CMDMGR_RegisterFunc(CMDMGR_OBJ, EYASSATTBL_LOAD_CMD_FC,  TBLMGR_OBJ,      TBLMGR_LoadTblCmd,      TBLMGR_LOAD_TBL_CMD_DATA_LEN);
    CMDMGR_RegisterFunc(CMDMGR_OBJ, EYASSATTBL_DUMP_CMD_FC,  TBLMGR_OBJ,      TBLMGR_DumpTblCmd,      TBLMGR_DUMP_TBL_CMD_DATA_LEN);
    CMDMGR_RegisterFunc(CMDMGR_OBJ, EYASSATOBJ_DISCRETE_CMD_FC,  EYASSAT_OBJ, EYASSATOBJ_DiscreteCmd,     EYASSATOBJ_DISCRETE_CMD_DATA_LEN);
    CMDMGR_RegisterFunc(CMDMGR_OBJ, EYASSATOBJ_UINT8_CMD_FC,   EYASSAT_OBJ,   EYASSATOBJ_Uint8Cmd,     EYASSATOBJ_UINT8_CMD_DATA_LEN);
    CMDMGR_RegisterFunc(CMDMGR_OBJ, EYASSATOBJ_UINT16_CMD_FC,  EYASSAT_OBJ,   EYASSATOBJ_Uint16Cmd,    EYASSATOBJ_UINT16_CMD_DATA_LEN);
    CMDMGR_RegisterFunc(CMDMGR_OBJ, EYASSATOBJ_FLOAT_CMD_FC,  EYASSAT_OBJ,   EYASSATOBJ_FloatCmd,    EYASSATOBJ_FLOAT_CMD_DATA_LEN);
    CMDMGR_RegisterFunc(CMDMGR_OBJ, EYASSATOBJ_CONNECT_CMD_FC,  EYASSAT_OBJ,   EYASSATOBJ_ConnectCmd,    EYASSATOBJ_CONNECT_CMD_DATA_LEN);
    CMDMGR_RegisterFunc(CMDMGR_OBJ, EYASSATOBJ_DISCONNECT_CMD_FC,  EYASSAT_OBJ,   EYASSATOBJ_DisconnectCmd,    EYASSATOBJ_DISCONNECT_CMD_DATA_LEN);



    TBLMGR_Constructor(TBLMGR_OBJ);
    TBLMGR_RegisterTblWithDef(TBLMGR_OBJ, EYASSATTBL_LoadCmd, EYASSATTBL_DumpCmd, EYASSAT_IF_EXTBL_DEF_LOAD_FILE);
                         
    CFE_SB_InitMsg(&Eyassat_ifHkPkt, EYASSAT_IF_TLM_HK_MID, EYASSAT_IF_TLM_HK_LEN, TRUE);
    CFE_SB_InitMsg(&Eyassat_ifInternalPkt, EYASSAT_IF_TLM_INTERNAL_MID, EYASSAT_IF_TLM_INTERNAL_LEN, TRUE);
    CFE_SB_InitMsg(&Eyassat_ifTempPkt, EYASSAT_IF_TLM_TEMP_MID, EYASSAT_IF_TLM_TEMP_LEN, TRUE);
    CFE_SB_InitMsg(&Eyassat_ifPowerPkt, EYASSAT_IF_TLM_POWER_MID, EYASSAT_IF_TLM_POWER_LEN, TRUE);
    CFE_SB_InitMsg(&Eyassat_ifUnscaledPowerPkt, EYASSAT_IF_TLM_UNSCALED_POWER_MID, EYASSAT_IF_TLM_UNSCALED_POWER_LEN, TRUE);
    CFE_SB_InitMsg(&Eyassat_ifADCSPkt, EYASSAT_IF_TLM_ADCS_MID, EYASSAT_IF_TLM_ADCS_LEN, TRUE);
                        
    /*
    ** Application startup event message
    */
    Status = CFE_EVS_SendEvent(EYASSAT_IF_INIT_INFO_EID,
                               CFE_EVS_INFORMATION,
                               "EYASSAT_IF Initialized. Version %d.%d.%d.%d",
                               EYASSAT_IF_MAJOR_VERSION,
                               EYASSAT_IF_MINOR_VERSION,
                               EYASSAT_IF_REVISION,
                               EYASSAT_IF_MISSION_REV);

    return(Status);

} /* End of InitApp() */


/******************************************************************************
** Function: ProcessCommands
**
*/
static void ProcessCommands(void)
{

   int32           Status;
   CFE_SB_Msg_t*   CmdMsgPtr;
   CFE_SB_MsgId_t  MsgId;

   Status = CFE_SB_RcvMsg(&CmdMsgPtr, Eyassat_if.CmdPipe, CFE_SB_POLL);

   if (Status == CFE_SUCCESS)
   {

      MsgId = CFE_SB_GetMsgId(CmdMsgPtr);

      switch (MsgId)
      {
         case EYASSAT_IF_CMD_MID:
            CMDMGR_DispatchFunc(CMDMGR_OBJ, CmdMsgPtr);
            break;

         case EYASSAT_IF_SEND_HK_MID:
            EYASSAT_IF_SendHousekeepingPkt();
            EYASSAT_IF_SendInternalPkt();
            EYASSAT_IF_SendTempPkt();
            EYASSAT_IF_SendPowerPkt();
            EYASSAT_IF_SendADCSPkt();
            EYASSAT_IF_SendUnscaledPowerPkt();
            break;

         default:
            CFE_EVS_SendEvent(EYASSAT_IF_CMD_INVALID_MID_ERR_EID, CFE_EVS_ERROR,
                              "Received invalid command packet,MID = 0x%4X",MsgId);

            break;

      } /* End Msgid switch */

   } /* End if SB received a packet */

} /* End ProcessCommands() */


/* end of file */
