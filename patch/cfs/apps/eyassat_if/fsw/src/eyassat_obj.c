/*
** Purpose: Implement an example object.
**
** Notes:
**   1. This serves as an example object that uses a table. It does not perform
**      any realistic funcions.
**
** License:
**   Template written by David McComas and licensed under the GNU
**   Lesser General Public License (LGPL).
**
** References:
**   1. OpenSatKit Object-based Application Developers Guide.
**   2. cFS Application Developer's Guide.
*/

/*
** Include Files:
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <termios.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

#include "app_cfg.h"
#include "eyassat_obj.h"
#include <bsp.h>

/*
** Global File Data
*/

static EYASSATOBJ_Class*  EyasSatObj = NULL;

/*
** Local Function Prototypes
*/


/******************************************************************************
** Function: EYASSATOBJ_Constructor
**
*/
void EYASSATOBJ_Constructor(EYASSATOBJ_Class*  EyasSatObjPtr, const char* ConsoleName)
{
 
   EyasSatObj = EyasSatObjPtr;

   CFE_PSP_MemSet((void*)EyasSatObj, 0, sizeof(EYASSATOBJ_Class));

   strncpy(EyasSatObj->ConsoleName, ConsoleName, EYASSATOBJ_CONSOLE_NAME_SIZE);

   EyasSatObj->DisconnectCount = 0;
   EyasSatObj->connected = false;

   EYASSATOBJ_ConsoleConnect();
 

} /* End EYASSATOBJ_Constructor() */


/******************************************************************************
** Function: EYASSATOBJ_Execute
**
** Execute main object function.
**
*/
void EYASSATOBJ_Execute(void)
{
   // If we're connected process telemetry
   if (EyasSatObj->connected) {
      EYASSATOBJ_ProcessTelemetry();
   } else if (!EyasSatObj->connected && (EyasSatObj->DisconnectCount < 6)) {
      CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID,CFE_EVS_INFORMATION, "Not connected to EyasSat.  Attempting to reconnect. Attempt %d of 5.", EyasSatObj->DisconnectCount);
      EYASSATOBJ_ConsoleConnect();
   }
   EyasSatObj->ExecCnt++;

} /* EYASSATOBJ_Execute() */

/******************************************************************************
** Function: EYASSATOBJ_ConsoleConnect
**
** We'll attempt to connect to /dev/console_b on startup
** If we don't connect succesfully, the execute function will try again
**
*/
void EYASSATOBJ_ConsoleConnect(void)
{
   CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID,
                     CFE_EVS_INFORMATION,
                     "Attempting to connect to EyasSat on %s",
                     EyasSatObj->ConsoleName);
   
   EyasSatObj->fd = open(EyasSatObj->ConsoleName, O_RDWR);

   if (EyasSatObj->fd < 0) {
		CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID,
                     CFE_EVS_INFORMATION,
                     "Failed to connect to EyaSat on %s\n",
                     EyasSatObj->ConsoleName);
	} else {
      CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID,
                  CFE_EVS_INFORMATION,
                  "Successfully connected to EyasSat on %s. Configuring console.",
                  EyasSatObj->ConsoleName);
      //Successful connection.  Configure port
      tcgetattr(EyasSatObj->fd, &EyasSatObj->term);

      // /* Set Console baud to 19200, default is 38400 */
      cfsetospeed(&EyasSatObj->term, B19200);
      cfsetispeed(&EyasSatObj->term, B19200);

      // 	/* Cannonical Mode Off - Do not echo chars */
      EyasSatObj->term.c_lflag &= ~(ICANON|ECHO|ECHOE|ECHOK|ECHONL|ECHOPRT|ECHOCTL|ECHOKE);

      // 	/* Turn off flow control */
      EyasSatObj->term.c_cflag |= CLOCAL;

      // 	/* 8 bit*/
      EyasSatObj->term.c_cflag |= CS8;

      // 	/* Update driver's settings */
      tcsetattr(EyasSatObj->fd, TCSANOW, &EyasSatObj->term);
      // fflush(NULL);

      EyasSatObj->connected = true;

   }

} /* EYASSATOBJ_ConsoleConnect() */

/******************************************************************************
** Function: EYASSATOBJ_ConsoleDisconnect
**
** Closes EyasSat console file descriptor
**
*/
void EYASSATOBJ_ConsoleDisconnect(void)
{
   if (EyasSatObj->connected) {
      close(EyasSatObj->fd);
      CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID,
            CFE_EVS_INFORMATION,
            "Disconnected from EyasSat console on %s",
            EyasSatObj->ConsoleName);
      EyasSatObj->fd = 0;
      EyasSatObj->DisconnectCount += 1;
      EyasSatObj->connected = false;
   } else {
      CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID, CFE_EVS_INFORMATION,
            "Attempted to disconnect from disconnected EyasSat port");
   }
}

/******************************************************************************
** Function: EYASSATOBJ_ProcessTelemetry
**
** Processing incoming telemetry from the EyasSat C&DH board
** Populate EyasSat Object with EyasSat Telemetry values
**
*/
// JRl Update name to indicate we're just grabbing the packets
void EYASSATOBJ_ProcessTelemetry(void)
{
   int bytesRemaining = EYASSATOBJ_TLM_BUFFER_SIZE;
   int bytesRead = 0;
   int totalBytesRead = 0;
   int readIndex = 0;
   int readTryCount = 0;
   int readTryLimit = 200000; // At 19200 baud the packets usually arrive with a readTryCount ~100,000
   // OS_time_t LocalTime;

   memset(EyasSatObj->telemetryBuffer, '\0', sizeof(EyasSatObj->telemetryBuffer));

   // We read until we read an entire buffer or until we detect the end of a packet group
   // The entire packet group should be reached before we read the entire buffer
   while(bytesRemaining) {
      readTryCount++;
      bytesRead = read(EyasSatObj->fd,&EyasSatObj->telemetryBuffer[readIndex], EYASSATOBJ_TLM_BUFFER_SIZE);
      if (readTryCount == readTryLimit || (bytesRead < 0)) { //Exceeded read attempts or read error, bail out and disconnect
         CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID, CFE_EVS_CRITICAL,
            "Exceeded EyasSat read attempt counter.  Disconnecting from EyasSat console.");
         EYASSATOBJ_ConsoleDisconnect();
         break;
      } 
      else if (bytesRead == 0) {
         rtems_task_wake_after(RTEMS_YIELD_PROCESSOR); // If no data is present, yield the processor
      }
      else { //process new data
         // if (totalBytesRead == 0) {
         //    CFE_PSP_GetTime(&LocalTime);
         //    printf("packet arrived at: %d.%d\n", LocalTime.seconds, LocalTime.microsecs);
         //    printf("readTryCount when data arrived: %d\n", readTryCount);
         // }
         totalBytesRead += bytesRead;
         // Detects the end of a packet group. One packet group is sent every two seconds.
         if ((readIndex > 3) && (EyasSatObj->telemetryBuffer[readIndex-3] == 45) && (EyasSatObj->telemetryBuffer[readIndex-2] == 45) && (EyasSatObj->telemetryBuffer[readIndex-1] == 45) && (EyasSatObj->telemetryBuffer[readIndex] == 45)) 
         {
            // printf("readTryCount when packet compete: %d\n", readTryCount);
            // CFE_PSP_GetTime(&LocalTime);
            // printf("packet read complete at: %d.%d\n", LocalTime.seconds, LocalTime.microsecs);
            break;
         }
         readIndex += bytesRead;
         bytesRemaining -= bytesRead;
      }   
	}
	// printf("Received EyasSat Telemetry: %s Bytes Read: %d\n", EyasSatObj->telemetryBuffer, totalBytesRead);
   EYASSATOBJ_ProcessPacketGroup(EyasSatObj->telemetryBuffer, totalBytesRead);
   
} /* EYASSATOBJ_ProcessTelemetry() */

/******************************************************************************
** Function: ProcessPacketGroup
** 
** Receives an entire group of EyasSat packets per processing cycle
** Based on the packet id, it calls the appropriate processing function
**
*/
void EYASSATOBJ_ProcessPacketGroup(char *tlmBuffer, int totalBytesRead)
{
	char packetType;
	int packetTypeOffset = 13;

	for (int i = 0; i < (totalBytesRead - 1); i++) {
		if (strncmp(&tlmBuffer[i],"ES",2)==0) {
			packetType = tlmBuffer[i+packetTypeOffset];
			switch(packetType) {
				case 'I':
					// printf("Detected the start of an Internal packet at index %d\n", i);
               EYASSATOBJ_ProcessInternalPacket(&tlmBuffer[i]);
					break;
				case 'T':
               EYASSATOBJ_ProcessTempPacket(&tlmBuffer[i]);
					// printf("Detected the start of an Temp packet at index %d\n", i);
					break;
				case 'P':
               EYASSATOBJ_ProcessPowerPacket(&tlmBuffer[i]);
					// printf("Detected the start of an Power packet at index %d\n", i);
					break;
				case 'A':
               EYASSATOBJ_ProcessADCSPacket(&tlmBuffer[i]);
					// printf("Detected the start of an ADCS packet at index %d\n", i);
					break;
				case '-':
					// printf("Detected the start of an tail sequence packet at index %d\n", i);
					break;
				case 'R':
					// printf("Detected the start of a command response packet at index %d\n", i);
					break;
				default:
               CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID, CFE_EVS_INFORMATION, "Received unknown packet type on EyasSat IF");
					break;
			}
		}
	}
} /* EYASSATOBJ_ProcessPacketGroup */

/******************************************************************************
** Function: EYASSATOBJ_ProcessInternalPacket
** 
** Processes the EyasSat Internal telemetry packet and populates the appropriate structure
**
*/
void EYASSATOBJ_ProcessInternalPacket(char *packetBuffer)
{
   int   status;
   char  CallSign[3];
   char  TimeString[8];

   if ((status = sscanf(packetBuffer, "%3c %8c I: TelemDelay=%hhu CmdTimeOut=%hu Pwr=%hhu ADCS=%hhu Exp1=%hhu\n\n", 
   						CallSign, TimeString, &EyasSatObj->InternalPkt.TimeDelay, &EyasSatObj->InternalPkt.CmdTimeOut, 
                     &EyasSatObj->InternalPkt.PwrTlm, &EyasSatObj->InternalPkt.AdcsTlm, &EyasSatObj->InternalPkt.ExpTlm)) == 7) {

      EyasSatObj->InternalPkt.PacketId = 1;
      CFE_PSP_MemCpy(&(EyasSatObj->InternalPkt.CallSign), CallSign, sizeof(EyasSatObj->InternalPkt.CallSign));
      CFE_PSP_MemCpy(&(EyasSatObj->InternalPkt.TimeString), TimeString, sizeof(EyasSatObj->InternalPkt.TimeString));
   
   } else {
      CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID, CFE_EVS_CRITICAL, "EyasSat Internal Packet Conversion Error: %d", status);
      // printf("Received EyasSat Internal Telemetry: %s\n", packetBuffer);
   }

} /* EYASSATOBJ_ProcessInternalPacket */

/******************************************************************************
** Function: EYASSATOBJ_ProcessTempPacket
** 
** Processes the EyasSat Temperature telemetry packet and populates the appropriate structure
**
*/
void EYASSATOBJ_ProcessTempPacket(char *packetBuffer) {

   int   status;
   char  CallSign[3];
   char  TimeString[8];
   
   if ((status = sscanf(packetBuffer, "%3c %8c T: DH=%f Exp=%f Ref=%f Panel_A=%f Panel_B=%f Base=%f Top_A=%f Top_B=%f\n\n", 
   						CallSign, TimeString, &EyasSatObj->TempPkt.DHTemp, &EyasSatObj->TempPkt.ExpTemp, &EyasSatObj->TempPkt.RefTemp,
                      &EyasSatObj->TempPkt.PanelATemp, &EyasSatObj->TempPkt.PanelBTemp, &EyasSatObj->TempPkt.BaseTemp,
                       &EyasSatObj->TempPkt.TopATemp, &EyasSatObj->TempPkt.TopBTemp)) == 10) {

      EyasSatObj->TempPkt.PacketId = 2;
      CFE_PSP_MemCpy(&(EyasSatObj->TempPkt.CallSign), CallSign, sizeof(EyasSatObj->TempPkt.CallSign));
      CFE_PSP_MemCpy(&(EyasSatObj->TempPkt.TimeString), TimeString, sizeof(EyasSatObj->TempPkt.TimeString));
   
   } else {
      CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID, CFE_EVS_CRITICAL, "EyasSat Temperature Packet Conversion Error: %d", status);
      // printf("Received EyasSat Temp Telemetry: %s\n", packetBuffer);
   }
   
   
} /* EYASSATOBJ_ProcessTempPacket */

/******************************************************************************
** Function: EYASSATOBJ_ProcessPowerPacket
** 
** Processes the EyasSat Power telemetry packet and populates the appropriate structure
**
*/
void EYASSATOBJ_ProcessPowerPacket(char *packetBuffer) {
   
   int   status;
   char  CallSign[3];
   char  TimeString[8];

   if ((status = sscanf(packetBuffer, "%3c %8c P: Sep=%hhu, V_Batt=%f, I_Batt=%f, V_SA=%f, I_SA=%f, I_MB=%f,  V_5v=%f, I_5v=%f, V_3v=%f, I_3v=%f, S=%hx,  T_Batt=%f, T_SA1=%f, T_SA2=%f\n\n", 
   						CallSign, TimeString, &EyasSatObj->PowerPkt.SepStatus, &EyasSatObj->PowerPkt.VBatt, &EyasSatObj->PowerPkt.IBatt,
                      &EyasSatObj->PowerPkt.VSA, &EyasSatObj->PowerPkt.ISA, &EyasSatObj->PowerPkt.IMB,
                       &EyasSatObj->PowerPkt.V5V, &EyasSatObj->PowerPkt.I5V, &EyasSatObj->PowerPkt.V3V,
                       &EyasSatObj->PowerPkt.I3V, &EyasSatObj->PowerPkt.SwitchStatus, &EyasSatObj->PowerPkt.BattTemp,
                       &EyasSatObj->PowerPkt.SA1Temp, &EyasSatObj->PowerPkt.SA2Temp)) == 16) {

      EyasSatObj->PowerPkt.PacketId = 3;
      CFE_PSP_MemCpy(&(EyasSatObj->PowerPkt.CallSign), CallSign, sizeof(EyasSatObj->PowerPkt.CallSign));
      CFE_PSP_MemCpy(&(EyasSatObj->PowerPkt.TimeString), TimeString, sizeof(EyasSatObj->PowerPkt.TimeString));
   
   } else {
      CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID, CFE_EVS_CRITICAL, "EyasSat Power Packet Conversion Error: %d", status);
      // printf("Received EyasSat Power Telemetry: %s\n", packetBuffer);
   }
   
} /* EYASSATOBJ_ProcessPowerPacket */


/******************************************************************************
** Function: EYASSATOBJ_ProcessADCSPacket
** 
** Processes the EyasSat ADCS telemetry packet and populates the appropriate structure
**
*/
void EYASSATOBJ_ProcessADCSPacket(char *packetBuffer) {
   
   int status;
   char  CallSign[3];
   char  TimeString[8];

   if ((status = sscanf(packetBuffer, "%3c %8c A: s_T=%hu, s_B=%hu, s0=%hu, s90=%hu, s180=%hu, s270=%hu, yaw=%f, sa=%f, M_X=%f, M_Y=%f, M_Z=%f, A_X=%f, A_Y=%f, A_Z=%f, X=%hhu, Y=%hhu, rps_out=%f, rps_cmd=%f, PWM_out=%hu, alg=%hu, P=%f, I=%f, D=%f, deltaT=%f, db=%f, g=%f, offset=%f, e=%f, hyst=%f\n\n", 
   						CallSign, TimeString, &EyasSatObj->ADCSPkt.SunTop, &EyasSatObj->ADCSPkt.SunBottom, &EyasSatObj->ADCSPkt.Sun0, &EyasSatObj->ADCSPkt.Sun90, &EyasSatObj->ADCSPkt.Sun180,
                     &EyasSatObj->ADCSPkt.Sun270, &EyasSatObj->ADCSPkt.YawAng, &EyasSatObj->ADCSPkt.SunOffset, &EyasSatObj->ADCSPkt.MagX, &EyasSatObj->ADCSPkt.MagY,
                     &EyasSatObj->ADCSPkt.MagZ, &EyasSatObj->ADCSPkt.AccX, &EyasSatObj->ADCSPkt.AccY, &EyasSatObj->ADCSPkt.AccZ, &EyasSatObj->ADCSPkt.XRod,
                     &EyasSatObj->ADCSPkt.YRod, &EyasSatObj->ADCSPkt.ActWheelSpd, &EyasSatObj->ADCSPkt.CmdWheelSpd, &EyasSatObj->ADCSPkt.PWM, &EyasSatObj->ADCSPkt.CtrlAlg,
                     &EyasSatObj->ADCSPkt.PConst, &EyasSatObj->ADCSPkt.IConst, &EyasSatObj->ADCSPkt.DConst, &EyasSatObj->ADCSPkt.DeltaT, &EyasSatObj->ADCSPkt.DeadBand,
                     &EyasSatObj->ADCSPkt.Slope, &EyasSatObj->ADCSPkt.Offset, &EyasSatObj->ADCSPkt.Extra, &EyasSatObj->ADCSPkt.RPSHyst)) == 31) {

      EyasSatObj->TempPkt.PacketId = 5;
      CFE_PSP_MemCpy(&(EyasSatObj->ADCSPkt.CallSign), CallSign, sizeof(EyasSatObj->ADCSPkt.CallSign));
      CFE_PSP_MemCpy(&(EyasSatObj->ADCSPkt.TimeString), TimeString, sizeof(EyasSatObj->ADCSPkt.TimeString));


   } else {
      CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID, CFE_EVS_CRITICAL, "EyasSat ADCS Packet Conversion Error: %d", status);
      // printf("Received EyasSat ADCS Telemetry: %s\n", packetBuffer);
   }
   
} /* EYASSATOBJ_ProcessADCSPacket */

/******************************************************************************
** Function: EYASSATOBJ_SendCommand
** Process incoming commands from the SB message and forward them to the
** EyasSat C&DH board via /dev/console_b (UART2)
**
*/
void EYASSATOBJ_SendCommand(int cmdLength)
{
   if (EyasSatObj->connected) {
      /* Send the string */
      for(int i=0; i<cmdLength; i++) {
         /* Send 1 char */
         if (write(EyasSatObj->fd, &EyasSatObj->commandBuffer[i], 1) != 1 ) {
            CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID, CFE_EVS_CRITICAL, "EyasSat command write failure");
         }
      }
   } else {
      CFE_EVS_SendEvent (EYASSATOBJ_CONNECT_EID, CFE_EVS_CRITICAL, "EyasSat command failure.  UART not connected.");
   }
} /* EYASSATOBJ_SendCommands */

/******************************************************************************
** Function:  EYASSATOBJ_ResetStatus
**
*/
void EYASSATOBJ_ResetStatus(void)
{

   EyasSatObj->ExecCnt = 0;
   
} /* End EYASSATOBJ_ResetStatus() */


/******************************************************************************
** Function: EYASSATOBJ_GetTblPtr
**
*/
const EYASSATTBL_Struct* EYASSATOBJ_GetTblPtr(void)
{

   return &(EyasSatObj->Tbl);

} /* End EYASSATOBJ_GetTblPtr() */


/******************************************************************************
** Function: EYASSATOBJ_LoadTbl
**
*/
boolean EYASSATOBJ_LoadTbl(EYASSATTBL_Struct* NewTbl)
{

   boolean  RetStatus = TRUE;

   CFE_EVS_SendEvent (EYASSATOBJ_DEBUG_EID, CFE_EVS_DEBUG,"EYASSATOBJ_LoadTbl() Entered");

   /*
   ** This is a simple table copy. More complex table loads may have pass/fail 
   ** criteria.
   */

   CFE_PSP_MemCpy(&(EyasSatObj->Tbl), NewTbl, sizeof(EYASSATTBL_Struct));

   return RetStatus;

} /* End EYASSATOBJ_LoadTbl() */


/******************************************************************************
** Function: EYASSATOBJ_LoadTblEntry
**
*/
boolean EYASSATOBJ_LoadTblEntry(uint16 EntryId, EYASSATTBL_Entry* NewEntry)
{

   boolean  RetStatus = TRUE;

   /* 
   ** This is a simple table entry copy. More complex table load may have 
   ** pass/fail criteria.
   */

   CFE_PSP_MemCpy(&(EyasSatObj->Tbl.Entry[EntryId]),NewEntry,sizeof(EYASSATTBL_Entry));

   return RetStatus;

} /* End EYASSATOBJ_LoadTblEntry() */


/******************************************************************************
** Function: EYASSATOBJ_DemoCmd
**
** Send an event message showing that the example object's command is executed.
**
*/
boolean EYASSATOBJ_DemoCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr)
{

   const EYASSATOBJ_DemoCmdMsg *CmdMsg = (const EYASSATOBJ_DemoCmdMsg *) MsgPtr;

   CFE_EVS_SendEvent (EYASSATOBJ_CMD_INFO_EID,
                      CFE_EVS_INFORMATION,
                      "Example demo command received with parameter %d",
                      CmdMsg->Parameter);

   return TRUE;

} /* End EYASSATOBJ_DemoCmd() */

/******************************************************************************
** Function: EYASSATOBJ_DiscreteCmd
**
** Process EyasSat command messages with no command parameters
**
*/
boolean EYASSATOBJ_DiscreteCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr) {
   
   const EYASSATOBJ_DiscreteCmdMsg *CmdMsg = (const EYASSATOBJ_DiscreteCmdMsg *) MsgPtr;
   CFE_EVS_SendEvent (EYASSATOBJ_CMD_INFO_EID,
                  CFE_EVS_INFORMATION,
                  "EyasSat discrete command sent with parameter %.2s",
                  CmdMsg->CmdCode);

   memset(EyasSatObj->commandBuffer, '\0', sizeof(EyasSatObj->commandBuffer));
   int len = snprintf(EyasSatObj->commandBuffer, sizeof(EyasSatObj->commandBuffer), "%.2s\n",
   CmdMsg->CmdCode);

   EYASSATOBJ_SendCommand(len);

   return TRUE;

} /* End EYASSATOBJ_DiscreteCmd() */

/******************************************************************************
** Function: EYASSATOBJ_Uint8Cmd
**
** Process EyasSat command messages with uint8 command parameters
**
*/
boolean EYASSATOBJ_Uint8Cmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr) {
   
   const EYASSATOBJ_Uint8CmdMsg *CmdMsg = (const EYASSATOBJ_Uint8CmdMsg *) MsgPtr;
   CFE_EVS_SendEvent (EYASSATOBJ_CMD_INFO_EID,
                  CFE_EVS_INFORMATION,
                  "EyasSat uint8 command sent with parameter %.2s %d",
                  CmdMsg->CmdCode, CmdMsg->CmdParameter);

   memset(EyasSatObj->commandBuffer, '\0', sizeof(EyasSatObj->commandBuffer));
   int len = snprintf(EyasSatObj->commandBuffer, sizeof(EyasSatObj->commandBuffer), "%.2s%hhu\n",
   CmdMsg->CmdCode, CmdMsg->CmdParameter);

   EYASSATOBJ_SendCommand(len);

   return TRUE;

} /* End EYASSATOBJ_Uint8Cmd() */

/******************************************************************************
** Function: EYASSATOBJ_Uint16Cmd
**
** Process EyasSat command messages with uint16 command parameters
**
*/
boolean EYASSATOBJ_Uint16Cmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr) {

   const EYASSATOBJ_Uint16CmdMsg *CmdMsg = (const EYASSATOBJ_Uint16CmdMsg *) MsgPtr;
   CFE_EVS_SendEvent (EYASSATOBJ_CMD_INFO_EID,
                  CFE_EVS_INFORMATION,
                  "EyasSat uint16 command sent with parameter %.2s %d",
                  CmdMsg->CmdCode, CmdMsg->CmdParameter);

   memset(EyasSatObj->commandBuffer, '\0', sizeof(EyasSatObj->commandBuffer));
   int len = snprintf(EyasSatObj->commandBuffer, sizeof(EyasSatObj->commandBuffer), "%.2s%hu\n",
   CmdMsg->CmdCode, CmdMsg->CmdParameter);

   EYASSATOBJ_SendCommand(len);

   return TRUE;

} /* End EYASSATOBJ_Uint16Cmd() */

/******************************************************************************
** Function: EYASSATOBJ_FloatCmd
**
** Process EyasSat command messages with float command parameters
**
*/
boolean EYASSATOBJ_FloatCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr) {

   const EYASSATOBJ_FloatCmdMsg *CmdMsg = (const EYASSATOBJ_FloatCmdMsg *) MsgPtr;
   CFE_EVS_SendEvent (EYASSATOBJ_CMD_INFO_EID,
                  CFE_EVS_INFORMATION,
                  "EyasSat float command sent with parameter %.2s %f",
                  CmdMsg->CmdCode, CmdMsg->CmdParameter);

   memset(EyasSatObj->commandBuffer, '\0', sizeof(EyasSatObj->commandBuffer));
   int len = snprintf(EyasSatObj->commandBuffer, sizeof(EyasSatObj->commandBuffer), "%.2s%f\n",
   CmdMsg->CmdCode, CmdMsg->CmdParameter);

   EYASSATOBJ_SendCommand(len);

   return TRUE;

}  /* End EYASSATOBJ_FloatCmd() */

/******************************************************************************
** Function: EYASSATOBJ_ConnectCmd
**
** Command to connect to the EyasSat UART port. Connection occurs on startup
** This commmand is only required if a disconnect has been performed manually
** or for some reason we have been connnected and then disconnected and exceeded
** a reconnect count of 5. In this case issue the reset ctrs command prior to
** attempting to connect again.
**
*/
boolean EYASSATOBJ_ConnectCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr) {

   EyasSatObj->DisconnectCount = 0;
   EYASSATOBJ_ConsoleConnect();

}

/******************************************************************************
** Function: EYASSATOBJ_DisconnectCmd
**
** Command to disconnect from the EyasSat UART port.
**
*/
boolean EYASSATOBJ_DisconnectCmd(void* DataObjPtr, const CFE_SB_MsgPtr_t MsgPtr) {

   //If we explicily command a discconnect, don't attempt reconnecting
   EyasSatObj->DisconnectCount = 6; 
   EYASSATOBJ_ConsoleDisconnect();

}

/* end of file */
