// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
#ifndef __COMMON_H__
// -----------------------------------------------------------------------------
#define __COMMON_H__
// -----------------------------------------------------------------------------
#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <errno.h>
#include <pthread.h>
#include <stdarg.h>
#include <fcntl.h>
#include <sys/select.h>
#include <termios.h>
// -----------------------------------------------------------------------------
#include "helpers.h"
// -----------------------------------------------------------------------------
//#define LOG_ENABLE
// -----------------------------------------------------------------------------
#define POLL_INTERVAL       10  // how often the obc polls all slaves (when its on)
#define POLL_LENGTH         8   // how long we make that take
#define OBC_MEM_SIZE        512

#ifdef LOG_ENABLE
#define EEP_MEM_SIZE        256
#else
#define EEP_MEM_SIZE        512
#endif // LOG_ENABLE

#include "Logging.h"

#define EPS_NUM_RAILS       6
const float EPS_RAIL_VALS[EPS_NUM_RAILS]={
1.8,
3.3,  // EEPROM
5,    // LEON3 OBC
-5,
12,
-12,
};
#define EPS_EEP_IDX         1     // 3.3V
#define EPS_OBC_IDX         2     // 5v
#define EPS_MEM_SIZE        ((EPS_NUM_RAILS+1)*4)
// -----------------------------------------------------------------------------
// GLOBALS
// -----------------------------------------------------------------------------
extern bool   g_mainloop;
// -----------------------------------------------------------------------------
#endif // __COMMON_H__
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
