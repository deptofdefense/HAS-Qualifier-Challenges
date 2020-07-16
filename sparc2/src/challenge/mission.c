#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "mission.h"
#include "s_malloc.h"

typedef struct {
    uint8_t cmd; 
    uint8_t arg1;
    uint8_t arg2;
    uint8_t crc;
} mission_step_t, *step; 
step mission_buffer = NULL;

#define MISSION_STEPS 8

int init_mission() 
{
    if(!mission_buffer)
    {
        mission_buffer = s_malloc(MISSION_STEPS * sizeof(mission_step_t));
    }
    return 0;
}


typedef struct {
    uint8_t len;
    uint8_t offset;
} step_header;

#define ERR_SHORT_COMMAND 6
int add_to_mission(uint8_t *msg, uint8_t len) 
{
    step_header *s_head = (step_header*)msg;
    step pSteps = (step)(msg + sizeof(step_header));
    if (len < sizeof(step_header) + sizeof(uint32_t))
    {
        return ERR_SHORT_COMMAND;
    }

    memcpy(mission_buffer + s_head->offset, pSteps, s_head->len);

    return 0;   
}

#define BAD_MISSION_STEP 10
int check_mission() {
    for (step s = mission_buffer; s < &mission_buffer[MISSION_STEPS]; s++)
    {
        if (0 == *(uint32_t*)s)
        {
            continue;
        }
        if (s->crc != crc8((uint8_t*)s, sizeof(mission_step_t) - sizeof(s->crc) ))
        {
            return BAD_MISSION_STEP;
        }
        printf("Step: %d ( %d, %d )", s->cmd, s->arg1, s->arg2);
    }
    return 0;
}