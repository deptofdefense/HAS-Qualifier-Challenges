#include "common.h"
#include <time.h>

void error(char *msg) {
  perror(msg);
  exit(0);
}

void initCrypto(struct AES_ctx *ctx)
{
  FILE *fp;
  //char *buf;
  //long len;

  fp = fopen("hash.txt", "rb");
  if (fp == NULL)
  {
    error("Error in initCrypto");
  }

  //fseek(fp, 0, SEEK_END);
  //len = ftell(fp);
  //rewind(fp);

  //buf = (char *)malloc(len * sizeof(char));
  int ch;
  ch = (getc(fp));
  //fprintf(stderr,"------- 0x%X --------\n", (int)ch);

  rewind(fp);
  fread(masterKey, 16, 1, fp);
  fread(masterIv, 16, 1, fp);
  fclose(fp);

  AES_init_ctx_iv(ctx, masterKey, masterIv);

#ifdef DEBUG
  int i;

  for (i = 0; i < 16; i++) fprintf(stderr,"0x%2x ", masterKey[i]);
  fprintf(stderr,"\n");
  for (i = 0; i < 16; i++) fprintf(stderr,"0x%2x ", masterIv[i]);
  fprintf(stderr,"\n");
#endif

}

int main(int argc, char **argv)
{

  uint8_t command = 0;
  int pktLen = 0;
  int sockfd, portno, n;
  unsigned int serverlen;
  struct sockaddr_in serveraddr;
  char *hostname;
  char recvBuff[MAX_BUFSIZE];
  int count = 0;
  cmdReplyHeader_t *reply = NULL;

  union {
    cmdMsgHeader_t header;
    cmdMsgHeader_t stateChange;
    cmdQuery_t     query;
    cmdSetMode_t   setMode;
    char           bytes[64];
  } cmdPacket;

  uint32_t crcValue = 0;
  SystemState_e nextState = Low_Power;

  SystemState state = malloc(sizeof(system_state_t));
  state->msgCount = 0;
  state->mode = Low_Power;
  /* check command line arguments */
  if (argc != 3) {
    fprintf(stderr,"usage: %s <hostname> <port>\n", argv[0]);
    exit(0);
  }
  hostname = argv[1];
  portno = atoi(argv[2]);

  initCrypto(&state->aes_ctx);

  /* socket: create the socket */
  
  for (int ii = 0; ii < 10; ii ++ )
  {
    sleep(1);
    sockfd = socket(AF_INET, SOCK_STREAM, 0);

    if (sockfd < 0) {
      continue;
    }
    bzero((char *) &serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;

    serveraddr.sin_addr.s_addr = inet_addr(hostname);
    serveraddr.sin_port = htons((uint16_t)portno);

    if (connect(sockfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr)) != 0)
    {
      sockfd = -1;
      continue;
    }
    break;
  }
  if (sockfd < 0) {
      fprintf(stderr, "Failed to connect to server\n");
      error("Couldn't connect");
  }
  //fprintf(stderr,"about to go into a loop\n");
  for(int i = 0; i < 3; i++)
  {
    //fprintf(stderr,"waking up the satalite only works in low power mode\n");
    cmdPacket.stateChange.cmd_type = WAKEUP;
    nextState = Command_Mode;
    pktLen = sizeof(cmdMsgHeader_t);
    cmdPacket.header.authentication = AUTH;
    cmdPacket.header.count = state->msgCount;

    crcValue = checksum(cmdPacket.bytes + sizeof(crcValue), pktLen - sizeof(crcValue), 0xffffffff);

    //fprintf(stderr,"checksum = %8X\n", crcValue);
    cmdPacket.header.crc = crcValue;

    //if (state->AES_encryption == On && state->mode == Command_Mode)
    //{
    //	xcrypt(&state->aes_ctx, cmdPacket.bytes, pktLen);
    //	printf("calling encrypt packet\n");
    //}

    serverlen = sizeof(serveraddr);
    n = send(sockfd, cmdPacket.bytes, pktLen, 0);
    if (n < 0) 
      error("ERROR in sendto");
    //fprintf(stderr, "packet sent data: %x\n", n);


    //fprintf(stderr, "waiting for response\n");
    bzero(recvBuff, MAX_BUFSIZE);

    n = recv(sockfd, recvBuff, MAX_BUFSIZE, 0);
    if (n < 0) 
      error("ERROR in recv");
    //fprintf(stderr,"Response from server: \n ");

    //if (state->AES_encryption == On && state->mode == Command_Mode)
    //{
    //fprintf(stderr,"calling decrypt packet\n");
    xcrypt(&state->aes_ctx, recvBuff, n);
    //}


    //fprintf(stderr,"strlen(recv) = %d\n", (int)strlen(recvBuff));


    reply = (cmdReplyHeader_t *)recvBuff;
    /*
    fprintf(stderr,"authentication is: %X\n", reply->authentication);
    fprintf(stderr,"count is: %X\n", reply->count);
    fprintf(stderr,"dataSize is: %d\n", reply->dataSize);
    fprintf(stderr,"crc is: %X\n", reply->crc);
    fprintf(stderr,"mode is: %X\n", reply->systemState);
    */
    state->mode = reply->systemState;
    state->msgCount = reply->count + 1;

    srand(time(0));
    count = 4;

    while (count > 0)
    {
      count --;

      pktLen = sizeof(cmdQuery_t);
      cmdPacket.query.cmd_type = QUERY_COMMAND;
      srand(time(0));
      command = (uint8_t) ( 73 * state->msgCount) % 5;
      cmdPacket.query.field = command;
      cmdPacket.header.authentication = AUTH;
      cmdPacket.header.count = state->msgCount;

      crcValue = checksum(cmdPacket.bytes + sizeof(crcValue), pktLen - sizeof(crcValue), 0xffffffff);

      //fprintf(stderr,"checksum = %8X\n", crcValue);
      cmdPacket.header.crc = crcValue;

      //if (state->AES_encryption == On && state->mode == Command_Mode)
      //{
      xcrypt(&state->aes_ctx, cmdPacket.bytes, pktLen);
      //fprintf(stderr,"calling encrypt packet\n");
      //}

      serverlen = sizeof(serveraddr);
      n = send(sockfd, cmdPacket.bytes, pktLen, 0);
      if (n < 0) 
        error("ERROR in sendto");
      //fprintf(stderr,"packet sent data: %x\n", n);


      //get response //

      //fprintf(stderr,"waiting for response\n");
      bzero(recvBuff, MAX_BUFSIZE);
      //fprintf(stderr,"just zero'd the buffer\n");

      n = recv(sockfd, recvBuff, MAX_BUFSIZE, 0);
      //fprintf(stderr,"strlen(recv) = %d\n", (int)strlen(recvBuff));
      if (n < 0) 
        error("ERROR in recv");

      //fprintf(stderr,"Response from server: \n ");

      //if (state->AES_encryption == On && nextState == Command_Mode)
      //{
      //fprintf(stderr,"calling decrypt packet\n");
      xcrypt(&state->aes_ctx, recvBuff, n);
      //}



      reply = (cmdReplyHeader_t *)recvBuff;
      /*
      fprintf(stderr,"authentication is: %X\n", reply->authentication);
      fprintf(stderr,"count is: %X\n", reply->count);
      fprintf(stderr,"dataSize is: %d\n", reply->dataSize);
      fprintf(stderr,"crc is: %X\n", reply->crc);
      */
      state->mode = reply->systemState;

      state->msgCount = reply->count + 1;
      
      switch(state->mode) 
      {
        case Debug_Mode:
          fprintf(stderr,"satalite is in debug mode\n");
          break;
        case Command_Mode:
          fprintf(stderr,"satalite is in command mode\n");
          break;
        case Low_Power:
          fprintf(stderr,"satalite is in lowpower mode\n");
          break;
        default:
          fprintf(stderr,"don't know the satalite state....\n");
      }
      state->mode = nextState;
      switch(nextState) 
      {
        case Debug_Mode:
          fprintf(stderr,"satalite is in debug mode\n");
          break;
        case Command_Mode:
          fprintf(stderr,"satalite is in command mode\n");
          break;
        case Low_Power:
          fprintf(stderr,"satalite is in lowpower mode\n");
          break;
        default:
          fprintf(stderr,"don't know the satalite state....\n");
      }
      unsigned int dataSize = reply->dataSize;

      if (cmdPacket.header.cmd_type == QUERY_COMMAND)
      {
        for (unsigned int i = sizeof(cmdReplyHeader_t); i < dataSize; i++)
        {
          fprintf(stderr,"%c", recvBuff[i]);
        }

      }
      //fprintf(stderr,"\n\n...\n");
    }

    cmdPacket.stateChange.cmd_type = CMD_LOWPOWER;
    nextState = Low_Power;

    pktLen = sizeof(cmdMsgHeader_t);
    cmdPacket.header.authentication = AUTH;
    cmdPacket.header.count = state->msgCount;

    crcValue = checksum(cmdPacket.bytes + sizeof(crcValue), pktLen - sizeof(crcValue), 0xffffffff);

    //fprintf(stderr,"checksum = %8X\n", crcValue);
    cmdPacket.header.crc = crcValue;

    //if (state->AES_encryption == On && state->mode == Command_Mode)
    //{
    xcrypt(&state->aes_ctx, cmdPacket.bytes, pktLen);
    //fprintf(stderr,"calling encrypt packet\n");
    //}

    serverlen = sizeof(serveraddr);
    n = send(sockfd, cmdPacket.bytes, pktLen, 0);
    if (n < 0) 
      error("ERROR in sendto");
    //fprintf(stderr,"packet sent data: %x\n", n);


    //fprintf(stderr,"waiting for response\n");
    bzero(recvBuff, MAX_BUFSIZE);
    //fprintf(stderr,"just zero'd the buffer\n");

    n = recv(sockfd, recvBuff, MAX_BUFSIZE, 0);
    if (n < 0) 
      error("ERROR in recv");
    //fprintf(stderr,"Response from server: \n ");

    //fprintf(stderr,"strlen(recv) = %d\n", (int)strlen(recvBuff));


    reply = (cmdReplyHeader_t *)recvBuff;
  
    /*
    fprintf(stderr,"authentication is: %X\n", reply->authentication);
    fprintf(stderr,"count is: %X\n", reply->count);
    fprintf(stderr,"dataSize is: %d\n", reply->dataSize);
    fprintf(stderr,"crc is: %X\n", reply->crc);
    fprintf(stderr,"mode is: %X\n", reply->systemState);
    */
    state->mode = reply->systemState;
    state->msgCount = reply->count + 1;

    fprintf(stderr,"...... going to sleep .......\n");
    sleep(10);
  }


  cmdPacket.stateChange.cmd_type = SHUTDOWN;
  pktLen = sizeof(cmdMsgHeader_t);
  cmdPacket.header.authentication = AUTH;
  cmdPacket.header.count = state->msgCount;

  crcValue = checksum(cmdPacket.bytes + sizeof(crcValue), pktLen - sizeof(crcValue), 0xffffffff);

  fprintf(stderr,"checksum = %8X\n", crcValue);
  cmdPacket.header.crc = crcValue;
  serverlen = sizeof(serveraddr);
  n = send(sockfd, cmdPacket.bytes, pktLen, 0);
  if (n < 0) 
    error("ERROR in sendto");
  fprintf(stderr,"packet sent data: %x\n", n);


  fprintf(stderr,"system shutting down now\n");
  return 0;
}	










