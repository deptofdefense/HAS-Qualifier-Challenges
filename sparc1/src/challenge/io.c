#include "io.h"

char hexLookup[] = "0123456789ABCDEF";

void hangup(char *msg){
  printf("[!] %s\n", msg);
  printf("Shutdown\n");
  exit(1);
}

char _readOne(void)
{
  char buff;
  if (1 != read(0, &buff, 1))
    return -1;
  if (buff >= '0' && buff <= '9')
    return buff - '0';
  buff |= 0x20;
  if (buff >= 'a' && buff <= 'f')
    return buff - 'a' + 0xA;

  hangup("Non-Hexdigit Detected\n");
  return -1;
}

char hexRead(void)
{
  char x =  (_readOne() & 0xF);
  char y =  (_readOne() & 0xF);
  return (x << 4) | y;
}


int bufferedRead(char *buff, int targetLen)
{
  int len = 0;
  while (len < targetLen)
  {
    buff[len] = hexRead();
    len++;
  }
  return len;
}

int readMsg(char *buff, int maxLen)
{
  uint8_t len = 0;
  bufferedRead((char*)&len, 1);
  if (len > maxLen) {
    hangup("Message Too Long\n");
  }
  return bufferedRead(buff, len - 1);
}

int hexWrite(char *buff, int len)
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
