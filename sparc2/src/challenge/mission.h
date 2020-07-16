#ifndef _MISSION_H_
#define _MISSION_H_
#include <stdint.h>
#include "crc.h"

int init_mission();
int add_to_mission(uint8_t *step, uint8_t len);
int check_mission();

#endif