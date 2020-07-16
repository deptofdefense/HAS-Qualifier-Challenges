#ifndef __COMMON_H__
#define __COMMON_H__

extern "C"
{
#include <stdint.h>
#include <stdlib.h>
#include <stdarg.h>
#include <prng.h>
#include <memcmp.h>
}

//#define USE_MUTEX_LOCK			(1)

#define ENABLE_MAC_RLL_TIMEOUT		(1)

// Set the MAX_LINE_LEN
#define MAX_LINE_LEN		1024

// Signal alarm timeout for service
#define MAX_IDLE_SECS		40

// Max messages in a queue
#define MAX_QUEUE_COUNT		(32)

// This is used to debug input commands
//#define DEBUG_INPUT_HELPER	1

// Debug output data
//#define DEBUG_OUTPUT		1

// BUG patch defines
//#define PATCH_HEARTBEAT_BUG		1
#define PATCH_APNAME_OVERWRITE	1
#define PATCH_INTEGRITY_CHECK_LENGTH	1
//

//#define	ENABLE_MAC_HEARTBEAT_MSG	(1)
//

//#define ENABLE_TEST_CODE	(1)

// Logging
#define LOGGING_OFF		(0)
#define LOG_PRIORITY_HIGH	1
#define LOG_PRIORITY_MEDIUM	2
#define LOG_PRIORITY_LOW	4

#include "spimconsreg.h"
#include "md5.h"
#include "timeframe.h"
#include "doublelist.h"
#include "pdupool.h"
#include "messagequeue.h"
#include "cioconnection.h"
#include "mac.h"
#include "rll.h"
#include "rrl.h"

uint32_t ReadDevURandom32( void );
void ReadDevURandom256( uint8_t *, uint32_t );

uint32_t DoCRC32( uint32_t crc, const uint8_t *pData, uint32_t size );

int32_t debug_log( uint32_t priority, const char *format, ... );
void set_log_priority( uint32_t priority );

void FreeMessageWrapper( uint8_t * );

void WRITE_U32_LE( uint8_t *pDest, uint32_t val );
uint32_t READ_U32_LE( uint8_t *pSource );

void WRITE_U16_LE( uint8_t *pDest, uint16_t val );
uint16_t READ_U16_LE( uint8_t *pSource );

#endif // __COMMON_H__
