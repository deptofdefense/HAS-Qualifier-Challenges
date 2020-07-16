#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"
#include "cache.h"

typedef struct timespec *Time;
//#define DEBUG 1
const uint8_t key[] = { 
  0xDE, 0xAD, 0xBE, 0xEF, 0xDE, 0xAD, 0xBE, 0xEF, 0xDE, 0xAD, 0xBE, 0xEF, 0xDE, 0xAD, 0xBE, 0xEF,
};
#ifdef DEBUG
const uint8_t input[] = { 
//  0xDE, 0xAD, 0xBE, 0xEF, 0xDE, 0xAD, 0xBE, 0xEF, 0xDE, 0xAD, 0xBE, 0xEF, 0xDE, 0xAD, 0xBE, 0xEF,
  0xDE, 0x11, 0x22, 0x33, 0x44, 0xAD, 0x66, 0x77, 0x88, 0x99, 0xBE, 0xBB, 0xCC, 0xDD, 0xEE, 0xEF,
};
#endif

Time sub(Time start, Time end)
{
  if ((end->tv_nsec - start->tv_nsec) < 0) {
    end->tv_sec  -= start->tv_sec + 1;
    end->tv_nsec -= start->tv_nsec - 1000000000;
  } else {
    end->tv_sec  -= start->tv_sec;
    end->tv_nsec -= start->tv_nsec;
  }
  return end;
}

#define ROUNDS 1
#define BLOCK_SIZE 16
int main(int argc, char* argv[])
{
  struct timespec time1, time2;
  uint8_t output[BLOCK_SIZE];
#ifndef DEBUG
  uint8_t input[BLOCK_SIZE];
  if (BLOCK_SIZE != read(0, input, BLOCK_SIZE))
  {
    return -1;
  }
#endif
  AesContext *ctxt = malloc(sizeof(AesContext));
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &time1);
  init_cache();
  aesInit(ctxt, key, BLOCK_SIZE);
  for (int ii = 0; ii < ROUNDS; ii++)
  {
    aesInit(ctxt, key, BLOCK_SIZE);
    aesEncryptBlock(ctxt, input, output);
  }
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &time2);
  printf("%d\n", cache_hits() + 25 * cache_misses());
  /*
  for (int ii = 0; ii < 16; ii ++ )
    printf("%02x", output[ii]);
  printf("\n");
  */
  return 0;
}
