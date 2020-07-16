#include <stdlib.h>
#include <string.h>
#include "s_malloc.h"
#include "mission.h"
#include "io.h"


typedef struct __attribute__((packed)) {
  uint8_t len; 
  uint8_t type;
} header_t, *pHeader;

typedef struct __attribute__((packed)) {
  uint16_t cookie1;
  uint16_t cookie2;
  uint16_t packetId;
  uint16_t packetLen;
} preamble_t, *pPreamble;

typedef struct {
  uint32_t data[32];
} msgTypeOne_t, *pMsgTypeOne;

#define SUCCESS         0x0
#define ERR_GENERAL     0x1
#define ERR_BADMSGID    0x2
#define ERR_BADCOOKIE1  0x3
#define ERR_BADCOOKIE2  0x4
#define ERR_BADPREAMBLE 0x5
#define ERR_STRUCTSIZE  0x6
#define ERR_BADCMDTYPE  0x7
#define ERR_BADINDEX    0x8

#define PREAMBLE_TYPE 0x1
#define GETSTRS_TYPE  0x2
#define GETPARAM_TYPE 0x3
#define SETPARAM_TYPE 0x4
#define EXIT_TYPE 0x5
#define MISSION_TYPE 0x6

#define inBuffLen (32)
int __attribute__ ((noinline)) handleGetStrs(pHeader msgHead, uint8_t len);
int __attribute__ ((noinline)) handleSetParam(pHeader msgHead, uint8_t len);
int __attribute__ ((noinline)) handleGetParam(pHeader msgHead, uint8_t len);
int __attribute__ ((noinline)) handleExitLoop(pHeader msgHead, uint8_t len);

int handlePacket(void)
{
  static uint8_t lastId = 0;
  uint8_t packetLen = 0;
  uint8_t currLen   = 0;
  int error = SUCCESS;

  //uint8_t *inBuff = s_malloc(inBuffLen);

  pHeader msg    = s_malloc(64);

  pHeader head   = s_malloc(sizeof(header_t));

  // Read In Preamble
  currLen += readHexMsg((uint8_t*) head, sizeof(header_t));

  if (head->len != sizeof(preamble_t) || head->type != PREAMBLE_TYPE)
    return ERR_BADPREAMBLE;
  
  currLen += readHexMsg( (uint8_t*)msg, sizeof(preamble_t) );
  pPreamble p = (pPreamble)msg;
  if ( p->packetId <= lastId )
    return ERR_BADMSGID;
  if ( p->cookie1 != 0xDEAD )
    return ERR_BADCOOKIE1;
  if ( p->cookie2 != 0xBEEF )
    return ERR_BADCOOKIE2;
  
  lastId    = p->packetId;
  packetLen = p->packetLen;

  s_free(msg);
  msg = NULL;

  // Start Reading in parts
  while (currLen < packetLen)
  {
    currLen += readHexMsg((uint8_t*)head, sizeof(header_t));
    msg = (pHeader)s_malloc(head->len);
    currLen += readHexMsg((uint8_t*)msg, head->len - sizeof(header_t));
    
    switch (head->type)
    {
      case GETSTRS_TYPE:
        error = handleGetStrs(msg, head->len);
        break;
      case GETPARAM_TYPE: 
        error = handleGetParam(msg, head->len);
        break;
      case SETPARAM_TYPE:
        error = handleSetParam(msg, head->len);
        break;
      case EXIT_TYPE:
        error = handleExitLoop(msg, head->len);
        break;
      case MISSION_TYPE:
        error = add_to_mission((uint8_t *)msg, head->len);
        break;
      default:
        error = ERR_BADCMDTYPE;
        break;
    }
    
    s_free(msg);
    if (error)
      break;
  }

  if (head) 
  {
    s_free(head);
    head = NULL;
  }
  
  if (error)
    printf("ERROR %d\n", error);
  else
    printf("ACK\n");
  return error;
}

char *strs[] = { 
  "Space Message Broker v3.2",
  "L54-8012-5511-1",
  "sparc-rtems-gcc",
  "rtems5-dev",
  "Stop Reading This list of Strings",
  "It is a waste of time...",
  "No, Seriously",
  "OK whatever, I'm not listening anymore",
  "LALALALALALALALALA",
};
const int numStrs = sizeof(strs)/sizeof(char *);

typedef struct __attribute__((packed)) {
  header_t head;
  uint8_t index;
} getIndex_t, *pGetIndex;

int __attribute__ ((noinline)) handleGetStrs(pHeader msgHead, uint8_t len)
{
  if (len != sizeof(getIndex_t))
  {
    return ERR_STRUCTSIZE;
  }

  pGetIndex msg = (pGetIndex)msgHead;
  if (msg->index > numStrs)
  {
    printf("%s\n", strs[numStrs - 1]);
  }
  else
  {
    printf("%s\n", strs[msg->index]);
  }
  return 0;
}

int params[] = { 42, 7, 8, 10, 31337, 0, 0, 28 };
const int numParams = sizeof(strs)/sizeof(char *);

typedef struct __attribute__((packed)) {
  header_t head;
  uint8_t index;
  uint8_t value;
} setIndex_t, *pSetIndex;

int __attribute__ ((noinline)) handleSetParam(pHeader msgHead, uint8_t len)
{
  if (len != sizeof(setIndex_t))
  {
    return ERR_STRUCTSIZE;
  }

  pSetIndex msg = (pSetIndex)msgHead;

  if (msg->index >= numParams)
  {
    return ERR_BADINDEX;
  }
  params[msg->index] = msg->value;
  return 0;
}

int __attribute__ ((noinline)) handleGetParam(pHeader msgHead, uint8_t len)
{
  if (len != sizeof(getIndex_t))
  {
    return ERR_STRUCTSIZE;
  }
  
  pGetIndex msg = (pGetIndex)msgHead;
  if (msg->index >= numParams)
  {
    return ERR_BADINDEX;
  }
  printf("%d\n", params[msg->index]);
  return 0;
}

int __attribute__ ((noinline)) handleExitLoop(pHeader msgHead, uint8_t len)
{
  if (len < sizeof(getIndex_t))
  {
    return ERR_STRUCTSIZE;
  }
  pGetIndex msg = (pGetIndex)msgHead;
  return msg->index;
}
