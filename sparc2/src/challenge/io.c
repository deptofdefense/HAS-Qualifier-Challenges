#include "io.h"

//#define DEBUG 1

#ifdef DEBUG
#include <string.h>

char debugBuff[] = "0801deadbeef0000006b3c05000000000000000000000000000000000000000000000000000000000000248000001c400018380310006d4141414141414141414141418000001c240500000000000008deadbeef0000006b3c05000000000000000000000000000000000000000000000000000000000000248000001c400018640310006d4141414141414141414141418000001c2405000000000000000000000000000000000000000000000000000000800000240000008008deadbeef0000006b3c05000000000000000000000000000000000000000000000000000000000000248000001c4000186c901060f84141414141414141414141418000001c2405000000000000000000000000000000000000000000000000000000800000240000008008deadbeef0000000c020200";
char *curr = &debugBuff[0];

int my_read(int fd, char*buff, int count) {
  (void)fd;
  memcpy(buff, curr, count);
  curr += count;
  return count;
}

#endif

char hexLookup[] = "0123456789ABCDEF";

char _readOne(void)
{
  char buff;
#ifdef DEBUG
  if (1 != my_read(0, &buff, 1))
#else 
  if (1 != read(0, &buff, 1))
#endif 
    return -1;
  if (buff >= '0' && buff <= '9')
    return buff - '0';
  buff |= 0x20;
  if (buff >= 'a' && buff <= 'f')
    return buff - 'a' + 0xA;
  return 0;
}

uint8_t hexRead(void)
{
  uint8_t x = (uint8_t)(_readOne() & 0xF);
  uint8_t y = (uint8_t)(_readOne() & 0xF);
  return (x << 4) | y;
}


int readHexMsg(uint8_t *buff, int len)
{
  int curr = 0;
  while (curr < len)
  {
    //read(0, &buff[len], 1);
    buff[curr] = hexRead();
    curr++;
  }
  return curr;
}

int hexWrite(uint8_t *buff, int len)
{
  int ii = 0;
  while (ii < len)
  {
    uint8_t b = buff[ii];
    write(1, &hexLookup[(b >> 4) & 0xF], 1);
    write(1, &hexLookup[b & 0xF], 1);
    ii++;
  }
  return ii;
}
