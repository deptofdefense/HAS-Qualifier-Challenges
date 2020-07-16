/*
** Purpose: Implement example table.
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
** Include Files:
*/

#include <string.h>
#include "eyassat_tbl.h"


/*
** Type Definitions
*/


/*
** Global File Data
*/

static EYASSATTBL_Class* EyasSatTbl = NULL;

/*
** Local File Function Prototypes
*/

/******************************************************************************
** Function: EntryCallBack
**
** Notes:
**   1. This must have the same function signature as JSON_ContainerFuncPtr.
*/
boolean EntryCallBack (int TokenIdx);


/******************************************************************************
** Function: EYASSATTBL_Constructor
**
** Notes:
**    1. This must be called prior to any other functions
**
*/
void EYASSATTBL_Constructor(EYASSATTBL_Class* ObjPtr,
                       EYASSATTBL_GetTblPtr    GetTblPtrFunc,
                       EYASSATTBL_LoadTbl      LoadTblFunc, 
                       EYASSATTBL_LoadTblEntry LoadTblEntryFunc)
{

   EyasSatTbl = ObjPtr;

   CFE_PSP_MemSet(EyasSatTbl, 0, sizeof(EYASSATTBL_Class));

   EyasSatTbl->GetTblPtrFunc    = GetTblPtrFunc;
   EyasSatTbl->LoadTblFunc      = LoadTblFunc;
   EyasSatTbl->LoadTblEntryFunc = LoadTblEntryFunc; 

} /* End EYASSATTBL_Constructor() */


/******************************************************************************
** Function: EYASSATTBL_ResetStatus
**
*/
void EYASSATTBL_ResetStatus(void)
{

   int Entry;

   EyasSatTbl->LastLoadStatus    = TBLMGR_STATUS_UNDEF;
   EyasSatTbl->AttrErrCnt        = 0;
   EyasSatTbl->DataArrayEntryIdx = 0;
   
   for (Entry=0; Entry < EYASSATTBL_MAX_ENTRY_ID; Entry++) EyasSatTbl->Modified[Entry] = FALSE;
   
 
} /* End EYASSATTBL_ResetStatus() */


/******************************************************************************
** Function: EYASSATTBL_LoadCmd
**
** Notes:
**  1. Function signature must match TBLMGR_LoadTblFuncPtr.
**  2. Can assume valid table file name because this is a callback from 
**     the app framework table manager that has verified the file.
*/
boolean EYASSATTBL_LoadCmd(TBLMGR_Tbl *Tbl, uint8 LoadType, const char* Filename)
{

   int Entry;
   
   OS_printf("EYASSATTBL_LoadCmd() Entry\n");

   /*
   ** Set all data and flags to zero. If a table replace is commanded and
   ** all of the data is not defined the zeroes will be copied into the table. 
   ** Real flight code would validate all data is loaded for a replace.
   */
   
   CFE_PSP_MemSet(&(EyasSatTbl->Tbl), 0, sizeof(EYASSATTBL_Struct));  /* Wouldn't do in flight but helps debug prototype */
   
   EYASSATTBL_ResetStatus();  /* Reset status helps isolate errors if they occur */

   JSON_Constructor(&(EyasSatTbl->Json), EyasSatTbl->JsonFileBuf, EyasSatTbl->JsonFileTokens);
   
   if (JSON_OpenFile(&(EyasSatTbl->Json), Filename)) {
  
      CFE_EVS_SendEvent(EYASSATTBL_LOAD_CMD_DBG_EID,CFE_EVS_DEBUG,"EYASSATTBL: Successfully prepared file %s\n", Filename);
  
      EyasSatTbl->DataArrayEntryIdx = 0;

      JSON_RegContainerCallback(&(EyasSatTbl->Json),"entry",EntryCallBack);

      JSON_ProcessTokens(&(EyasSatTbl->Json));

      if (EyasSatTbl->DataArrayEntryIdx > 0) {

         
		 if (LoadType == TBLMGR_LOAD_TBL_REPLACE) {
         
            EyasSatTbl->LastLoadStatus = ((EyasSatTbl->LoadTblFunc)(&(EyasSatTbl->Tbl)) == TRUE) ? TBLMGR_STATUS_VALID : TBLMGR_STATUS_INVALID;

         } /* End if replace entire table */
         else if (LoadType == TBLMGR_LOAD_TBL_UPDATE) {
         
		    EyasSatTbl->LastLoadStatus = TBLMGR_STATUS_VALID;
   
            for (Entry=0; Entry < EYASSATTBL_MAX_ENTRY_ID; Entry++) {

               if (EyasSatTbl->Modified[Entry]) {
                  if (!(EyasSatTbl->LoadTblEntryFunc)(Entry, &(EyasSatTbl->Tbl.Entry[Entry])))
                     EyasSatTbl->LastLoadStatus = TBLMGR_STATUS_INVALID;
               }

            } /* End entry loop */

         } /* End if update individual records */
         else {
            CFE_EVS_SendEvent(EYASSATTBL_LOAD_CMD_TYPE_ERR_EID,CFE_EVS_ERROR,"EYASSATTBL: Invalid table command load type %d",LoadType);
         }

      } /* End if successful parse */
      else {
         CFE_EVS_SendEvent(EYASSATTBL_LOAD_CMD_PARSE_ERR_EID,CFE_EVS_ERROR,"EYASSATTBL: Table Parsing failure for file %s",Filename);
      }
      
   } /* End if valid file */
   else {
      CFE_EVS_SendEvent(EYASSATTBL_LOAD_CMD_JSON_OPEN_ERR_EID,CFE_EVS_ERROR,"EYASSATTBL: Table open failure for file %s. JSON Status = %d JSMN Status = %d",
	                    Filename, EyasSatTbl->Json.FileStatus, EyasSatTbl->Json.JsmnStatus);
   }
    
   return (EyasSatTbl->LastLoadStatus == TBLMGR_STATUS_VALID);

} /* End of ExTBL_LoadCmd() */


/******************************************************************************
** Function: EYASSATTBL_DumpCmd
**
** Notes:
**  1. Function signature must match TBLMGR_DumpTblFuncPtr.
**  2. Can assume valid table file name because this is a callback from 
**     the app framework table manager that has verified the file.
**  3. DumpType is unused.
**  4. File is formatted so it can be used as a load file. It does not follow
**     the cFE table file format. 
**  5. Creates a new dump file, overwriting anything that may have existed
**     previously
*/
boolean EYASSATTBL_DumpCmd(TBLMGR_Tbl *Tbl, uint8 DumpType, const char* Filename)
{

   boolean  RetStatus = FALSE;
   int32    FileHandle;
   char     DumpRecord[256];
   int      i;
   const EYASSATTBL_Struct *EyasSatTblPtr;

   FileHandle = OS_creat(Filename, OS_WRITE_ONLY);

   if (FileHandle >= OS_FS_SUCCESS)
   {

      EyasSatTblPtr = (EyasSatTbl->GetTblPtrFunc)();

      sprintf(DumpRecord,"\n{\n\"name\": \"Example Table\",\n");
      OS_write(FileHandle,DumpRecord,strlen(DumpRecord));

      sprintf(DumpRecord,"\"description\": \"Example table for object-based application template.\",\n");
      OS_write(FileHandle,DumpRecord,strlen(DumpRecord));

      sprintf(DumpRecord,"\"data-array\": [\n");
      OS_write(FileHandle,DumpRecord,strlen(DumpRecord));
      
      for (i=0; i < EYASSATTBL_MAX_ENTRY_ID; i++)
      {
      
         sprintf(DumpRecord,"\"entry\": {\n  \"index\": %03d,\n  \"data1\": %4d,\n  \"data2\": %4d,\n  \"data3\": %4d, \n},\n",
                 i, EyasSatTblPtr->Entry[i].Data1, EyasSatTblPtr->Entry[i].Data2, EyasSatTblPtr->Entry[i].Data3);
         OS_write(FileHandle,DumpRecord,strlen(DumpRecord));
      
      } /* End Entry loop */

      sprintf(DumpRecord,"]\n}\n");
      OS_write(FileHandle,DumpRecord,strlen(DumpRecord));

      /* TODO - Add addition meta data when file dumped */
      RetStatus = TRUE;

      OS_close(FileHandle);

   } /* End if file create */
   else
   {
   
      CFE_EVS_SendEvent(EYASSATTBL_CREATE_FILE_ERR_EID, CFE_EVS_ERROR,
                        "Error creating dump file '%s', Status=0x%08X", Filename, FileHandle);
   
   } /* End if file create error */

   return RetStatus;
   
} /* End of EYASSATTBL_DumpCmd() */


/******************************************************************************
** Function: EntryCallBack
**
** Process a JSON entry.
**
** Notes:
**   1. This must have the same function signature as JSON_ContainerFuncPtr.
*/
boolean EntryCallBack (int TokenIdx)
{

   int  Index, Data1, Data2, Data3, EntryCnt=0;

   EyasSatTbl->DataArrayEntryIdx++;
   CFE_EVS_SendEvent(EYASSATTBL_LOAD_CMD_DBG_EID,CFE_EVS_DEBUG,
      "EntryCallBack() for DataArrayEntryIdx %d and token index %d\n",EyasSatTbl->DataArrayEntryIdx, TokenIdx);
      
   if (JSON_GetValShortInt(&(EyasSatTbl->Json), TokenIdx, "index", &Index)) EntryCnt++;
   if (JSON_GetValShortInt(&(EyasSatTbl->Json), TokenIdx, "data1", &Data1)) EntryCnt++;
   if (JSON_GetValShortInt(&(EyasSatTbl->Json), TokenIdx, "data2", &Data2)) EntryCnt++;
   if (JSON_GetValShortInt(&(EyasSatTbl->Json), TokenIdx, "data3", &Data3)) EntryCnt++;
   
   if (EntryCnt == 4)
   {
      if (Index < EYASSATTBL_MAX_ENTRY_ID)
      {        
         EyasSatTbl->Tbl.Entry[Index].Data1 = Data1;
         EyasSatTbl->Tbl.Entry[Index].Data2 = Data2;
         EyasSatTbl->Tbl.Entry[Index].Data3 = Data3;
         EyasSatTbl->Modified[Index] = TRUE;
         CFE_EVS_SendEvent(EYASSATTBL_LOAD_CMD_DBG_EID,CFE_EVS_DEBUG,
		    "EntryCallBack() index, data1, data2, datat3: %d, %d, %d, %d\n",Index, Data1, Data2, Data3);
      }
      else
      {
         EyasSatTbl->AttrErrCnt++;     
         CFE_EVS_SendEvent(EYASSATTBL_LOAD_INDEX_ERR_EID, CFE_EVS_ERROR, "Load file data-array entry %d error, invalid index %d",
                           EyasSatTbl->DataArrayEntryIdx, Index);
      }
      
   } /* Valid Entry */
   else
   {
      EyasSatTbl->AttrErrCnt++;
      CFE_EVS_SendEvent(EYASSATTBL_LOAD_LINE_ERR_EID, CFE_EVS_ERROR, "Load file data-array entry %d error, invalid number of elements %d. Should be 4.",
                        EyasSatTbl->DataArrayEntryIdx, EntryCnt);
   } /* Invalid Entry */

   return (EntryCnt == 4);

} /* EntryCallBack() */

/* end of file */
