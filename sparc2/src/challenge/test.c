#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <sys/mman.h>
#include "s_malloc.h"
#include "io.h"

typedef struct blk_t 
{
  size_t prevFree:1;
  size_t prevSize:31;
  size_t free:1;
  size_t size:31;
  struct blk_t *prev;
  struct blk_t *next;
} blk_t, *Block;

typedef struct {
  uint32_t msgId;
  uint32_t msgCmd;
} msgHeader_t, *pHeader;

typedef struct {
  msgHeader_t header; 
  uint32_t data[32];
} msgTypeOne_t, *pMsgTypeOne;

int __attribute__ ((noinline)) targetVulnHandle(pHeader msgHead, size_t len)
{
  if (len != sizeof(msgTypeOne_t))
  {
    s_free(msgHead);
    return -1;
  }
  pMsgTypeOne msg = (pMsgTypeOne) msgHead;
  msg->data[0] = msg->data[1];
  msg->data[2] = msg->data[10];
  s_free(msgHead);
  return 0;
}

int vulnFn(void)
{
  uint8_t totalLen = 0;
  uint8_t partLen  = 0;
  uint8_t currLen  = 0;
  pHeader msgHead = NULL;
  char *inBuff    = NULL;
  char *cksum     = NULL;

  int error = 0;
  totalLen = hexRead();
  currLen += 1;
  while (currLen < totalLen)
  {
    if (!inBuff) 
    {
      inBuff = s_malloc(48);
    }

    partLen = hexRead();
    currLen += 1;

    msgHead = s_malloc(partLen);
    partLen = readMsg(inBuff, partLen);

    memcpy(msgHead, inBuff, partLen);
    
    if (!cksum)
    {
      cksum = s_malloc(4);
    }
    // Calculate Checksum

    switch (msgHead->msgCmd)
    {
      case 0:
        error = 0;
        s_free(msgHead);
        break;
      case 1: 
        error = targetVulnHandle(msgHead, partLen);
        break;
    }
    
    if (error)
      break;
  
    currLen += partLen;
  }

  if (inBuff)
  {
    s_free(inBuff);
    inBuff = NULL;
  }
  if (cksum) 
  {
    s_free(cksum);
    cksum = NULL;
  }
  return error;
}
