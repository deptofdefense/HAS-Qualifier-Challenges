#include "crc.h"
#define CRC16_IBM 0x3D65
#define POLY 0x07
#define INIT 0x00

uint8_t crc8(const uint8_t *data, uint8_t len)
{
  uint8_t crc = INIT;
  uint8_t i, j;
  for (i = 0; i < len; i++) {
    crc ^= data[i];
    for (j = 0; j < 8; j++) {
      if ((crc & 0x80) != 0)
        crc = (uint8_t)((crc << 1) ^ POLY);
      else
        crc <<= 1;
    }
  }
  return crc;
}
