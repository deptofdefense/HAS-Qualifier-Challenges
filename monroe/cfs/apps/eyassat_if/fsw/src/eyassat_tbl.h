/*
** Purpose: Define Example Table
**
** Notes:
**   1. Use the Singleton design pattern. A pointer to the table object
**      is passed to the constructor and saved for all other operations.
**      This is a table-specific file so it doesn't need to be re-entrant.
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
#ifndef _eyassattbl_
#define _eyassattbl_

/*
** Includes
*/

#include "app_cfg.h"


/*
** Macro Definitions
*/

/*
** Event Message IDs
*/

#define EYASSATTBL_CREATE_FILE_ERR_EID        (EYASSATTBL_BASE_EID + 0)
#define EYASSATTBL_LOAD_INDEX_ERR_EID         (EYASSATTBL_BASE_EID + 1)
#define EYASSATTBL_LOAD_LINE_ERR_EID          (EYASSATTBL_BASE_EID + 2)
#define EYASSATTBL_LOAD_CMD_TYPE_ERR_EID      (EYASSATTBL_BASE_EID + 3)
#define EYASSATTBL_LOAD_CMD_PARSE_ERR_EID     (EYASSATTBL_BASE_EID + 4)
#define EYASSATTBL_LOAD_CMD_JSON_OPEN_ERR_EID (EYASSATTBL_BASE_EID + 5)
#define EYASSATTBL_LOAD_CMD_DBG_EID           (EYASSATTBL_BASE_EID + 6)

/*
** Type Definitions
*/

/******************************************************************************
** Table -  Local table copy used for table loads
** 
*/

typedef struct {

   uint16   Data1;
   uint16   Data2;
   uint16   Data3;

} EYASSATTBL_Entry;

typedef struct
{

   EYASSATTBL_Entry Entry[EYASSATTBL_MAX_ENTRY_ID];

} EYASSATTBL_Struct;



/*
** Table Owner Callback Functions
*/

/* Return pointer to owner's table data */
typedef const EYASSATTBL_Struct* (*EYASSATTBL_GetTblPtr)(void);
            
/* Table Owner's function to load all table data */
typedef boolean (*EYASSATTBL_LoadTbl)(EYASSATTBL_Struct* NewTable); 

/* Table Owner's function to load a single table entry */
typedef boolean (*EYASSATTBL_LoadTblEntry)(uint16 EntryId, EYASSATTBL_Entry* NewEntry);   


typedef struct {

   uint8    LastLoadStatus;
   uint16   AttrErrCnt;
   uint16   DataArrayEntryIdx;
   boolean  Modified[EYASSATTBL_MAX_ENTRY_ID];

   EYASSATTBL_Struct Tbl;

   EYASSATTBL_GetTblPtr    GetTblPtrFunc;
   EYASSATTBL_LoadTbl      LoadTblFunc;
   EYASSATTBL_LoadTblEntry LoadTblEntryFunc; 

   JSON_Class Json;
   char       JsonFileBuf[JSON_MAX_FILE_CHAR];   
   jsmntok_t  JsonFileTokens[JSON_MAX_FILE_TOKENS];

} EYASSATTBL_Class;


/*
** Exported Functions
*/


/******************************************************************************
** Function: EYASSATTBL_Constructor
**
** Initialize the example table object.
**
** Notes:
**   1. The table values are not populated. This is done when the table is 
**      registered with the table manager.
**
*/
void EYASSATTBL_Constructor(EYASSATTBL_Class* TblObj, 
                       EYASSATTBL_GetTblPtr    GetTblPtrFunc,
                       EYASSATTBL_LoadTbl      LoadTblFunc, 
                       EYASSATTBL_LoadTblEntry LoadTblEntryFunc);


/******************************************************************************
** Function: EYASSATTBL_ResetStatus
**
** Reset counters and status flags to a known reset state.  The behavour of
** the table manager should not be impacted. The intent is to clear counters
** and flags to a known default state for telemetry.
**
*/
void EYASSATTBL_ResetStatus(void);


/******************************************************************************
** Function: EYASSATTBL_LoadCmd
**
** Command to load the table.
**
** Notes:
**  1. Function signature must match TBLMGR_LoadTblFuncPtr.
**  2. Can assume valid table file name because this is a callback from 
**     the app framework table manager.
**
*/
boolean EYASSATTBL_LoadCmd(TBLMGR_Tbl *Tbl, uint8 LoadType, const char* Filename);


/******************************************************************************
** Function: EYASSATTBL_DumpCmd
**
** Command to dump the table.
**
** Notes:
**  1. Function signature must match TBLMGR_DumpTblFuncPtr.
**  2. Can assume valid table file name because this is a callback from 
**     the app framework table manager.
**
*/
boolean EYASSATTBL_DumpCmd(TBLMGR_Tbl *Tbl, uint8 DumpType, const char* Filename);

#endif /* _eyassattbl_ */

