#ifndef _CACHE_H_
#define _CACHE_H_

#include <stdint.h>

void init_cache(void);
uint32_t te(uint8_t index);
uint32_t td(uint8_t index);

int cache_hits();
int cache_misses();

#endif
