#ifndef __COMMON_H__
#define __COMMON_H__

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include <signal.h>
#include <fcntl.h>

#include "well_rng.h"

#define SAMPLE_FS			(5000000)
#define NS_PER_SAMPLE			(1000000000/SAMPLE_FS)
#define MAX_TIME			(2)
#define MAX_SAMPLE_POINTS	(MAX_TIME * SAMPLE_FS)
#define MIN_SAMPLE_POINTS	(128)

#define PI_VALUE			3.1415926535897932384626433832795

#endif // __COMMON_H__
