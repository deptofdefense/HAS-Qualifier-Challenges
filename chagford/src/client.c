#include "common.h"

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
  fprintf(stderr,"------- 0x%X --------\n", (int)ch);

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

int main(int argc, char **argv) {

  int pktLen = 0;
  int sockfd, portno, n;
  unsigned int serverlen;
  struct sockaddr_in serveraddr;
  //    struct hostent *server;
  char *hostname;
  char buf[MAX_BUFSIZE];
  char recvBuff[MAX_BUFSIZE];
  
  union {
    cmdMsgHeader_t header;
    cmdMsgHeader_t stateChange;
    cmdQuery_t     query;
    cmdSetMode_t   setMode;
    char           bytes[64];
  } cmdPacket;

  uint32_t crcValue = 0;
  int shutdown = 0;
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
  sockfd = socket(AF_INET, SOCK_DGRAM, 0);

  if (sockfd < 0) 
  {
    error("ERROR opening socket");
  }
  bzero((char *) &serveraddr, sizeof(serveraddr));
  serveraddr.sin_family = AF_INET;

  serveraddr.sin_addr.s_addr = inet_addr(hostname);
  serveraddr.sin_port = htons((uint16_t)portno);

  while (1)
  {

    nextState = state->mode;
    /* get a message from the user */
    bzero(buf, MAX_BUFSIZE);
    fprintf(stderr,"Please enter msg: ");
    fgets(buf, MAX_BUFSIZE, stdin);

    if(!strcmp(buf, "help\n"))
    {
      fprintf(stderr,"valid commands are:\nlocal c2: help, reset_pkt_count, local_encrypt_on, local_encrypt_off\nserver: set_debug, set_cmd, set_lowpwr, cmd1, cmd2, cmd3, cmd4,cmd4, cmd5, query_state, getFlag ,wakeup, shutdown, disable_encryption. reset_pkt\n");

    }else if(!strcmp(buf, "reset_pkt_count\n"))
    {
      fprintf(stderr,"reset pkt_counter\n");
      state->msgCount = 0;
    }else if(!strcmp(buf, "local_encrypt_on\n"))
    {
      fprintf(stderr,"enabling local crypto\n");
      state->AES_encryption = On;
      state->mode = Command_Mode;

    }else if(!strcmp(buf, "local_encrypt_off\n"))
    {
      fprintf(stderr,"disabling local crypto\n");
      state->AES_encryption = Off;
    }else
    {
      /* these are commands that will get sent ot the C2*/
      if (!strcmp(buf,"set_debug\n")) 
      {
        fprintf(stderr,"set debug message %x\n", Debug_Mode);
        cmdPacket.stateChange.cmd_type = CMD_DEBUG;
        nextState = Debug_Mode;
      }
      else if (!strcmp(buf, "set_cmd\n"))
      {
        fprintf(stderr,"set command mode %x\n", Command_Mode);
        cmdPacket.stateChange.cmd_type = CMD_COMMAND;
        nextState = Command_Mode;
      }else if (!strcmp(buf, "set_lowpwr\n"))
      {	
        fprintf(stderr,"set low power mode %x\n", Low_Power);
        cmdPacket.stateChange.cmd_type = CMD_LOWPOWER;
        nextState = Low_Power;
      }else if(!strcmp(buf, "shutdown\n"))
      {
        fprintf(stderr,"shutting down the satallite, must be done in debug mode\n");
        cmdPacket.stateChange.cmd_type = SHUTDOWN;
        shutdown = 1;
      }else if(!strcmp(buf, "wakeup\n"))
      {
        fprintf(stderr,"waking up the satalite only works in low power mode\n");
        cmdPacket.stateChange.cmd_type = WAKEUP;
        nextState = Command_Mode;
      }
      
      
      else if(!strcmp(buf, "cmd1\n"))
      {
        fprintf(stderr,"sending command 1\n");
        cmdPacket.query.cmd_type = QUERY_COMMAND;
        cmdPacket.query.field = CMD1;
      }else if(!strcmp(buf, "cmd2\n"))
      {
        fprintf(stderr,"sending command 2\n");
        cmdPacket.query.cmd_type = QUERY_COMMAND;
        cmdPacket.query.field = CMD2;
      }else if(!strcmp(buf, "cmd3\n"))
      {
        fprintf(stderr,"sending command 3\n"); 
        cmdPacket.query.cmd_type = QUERY_COMMAND;
        cmdPacket.query.field = CMD3;
      }else if(!strcmp(buf, "cmd4\n"))
      {
        fprintf(stderr,"sending command 4\n");
        cmdPacket.query.cmd_type = QUERY_COMMAND;
        cmdPacket.query.field = CMD4;
      }else if(!strcmp(buf, "cmd5\n"))
      {
        fprintf(stderr,"sending command 5\n");
        cmdPacket.query.cmd_type = QUERY_COMMAND;
        cmdPacket.query.field = CMD5;
      }else if(!strcmp(buf, "query_state\n"))
      {
        fprintf(stderr,"sending command query_state\n");
        cmdPacket.query.cmd_type = QUERY_COMMAND;
        cmdPacket.query.field = QUERY_STATE;
      }else if(!strcmp(buf, "getFlag\n"))
      {
        fprintf(stderr,"sending command getFlag\n");
        cmdPacket.query.cmd_type = QUERY_COMMAND;
        cmdPacket.query.field = FLAG;
      }
      
      
      else if(!strcmp(buf, "disable_encryption\n"))
      {
        fprintf(stderr,"disable_encryption will only work if the server is in debug mode\n");
        //AES_encryption = Off;
        cmdPacket.setMode.cmd_type = SET_COMMAND;
        cmdPacket.setMode.field = ENCRYPT_STATE;
        cmdPacket.setMode.value = OFF;
      }else if(!strcmp(buf, "enable_encryption\n"))
      {
        fprintf(stderr,"enable_encryption will only work if the server is in debug mode\n");
        //AES_encryption = On;
        cmdPacket.setMode.cmd_type = SET_COMMAND;
        cmdPacket.setMode.field = ENCRYPT_STATE;
        cmdPacket.setMode.value = ON;
      }else if(!strcmp(buf, "reset_pkt\n"))
      {
        fprintf(stderr,"reset packet counter\n");
        cmdPacket.setMode.cmd_type = SET_COMMAND;
        cmdPacket.setMode.field = PKT_RESET;
        cmdPacket.setMode.value = OFF;
      }else
      {
        fprintf(stderr,"invalid command\n");
        continue;
      }

      /* lets send the data now */
      if(cmdPacket.header.cmd_type == QUERY_COMMAND) {
        pktLen = sizeof(cmdQuery_t);
      }
      else if(cmdPacket.header.cmd_type == SET_COMMAND) {
        pktLen = sizeof(cmdSetMode_t);
      }
      else {
        pktLen = sizeof(cmdMsgHeader_t);
      }

      cmdPacket.header.authentication = AUTH;
      cmdPacket.header.count = state->msgCount;

      crcValue = checksum(cmdPacket.bytes + sizeof(crcValue), pktLen - sizeof(crcValue), 0xffffffff);

      fprintf(stderr,"checksum = %8X\n", crcValue);
      cmdPacket.header.crc = crcValue;

      if (state->AES_encryption == On && state->mode == Command_Mode)
      {
        xcrypt(&state->aes_ctx, cmdPacket.bytes, pktLen);
        fprintf(stderr,"calling encrypt packet\n");
      }

      serverlen = sizeof(serveraddr);
      n = sendto(sockfd, cmdPacket.bytes, pktLen, 0, (struct sockaddr *) &serveraddr, serverlen);
      if (n < 0) 
        error("ERROR in sendto");
      fprintf(stderr,"packet sent data: %x\n", n);
    

      /* else
      {
        fprintf(stderr,"sending query command, size should be: 0x%X\n", (unsigned int)sizeof(cmdMsgHeader_t));

        //pkt_data = (cmdMsgHeader_t*)malloc(sizeof(cmdMsgHeader_t));
        //if(pkt_data == NULL)
        //{
        //	fprintf(stderr,"memory not allocated for command.\n");
        //	return 0;
        //}else
        //{
        ((cmdMsgHeader_t *)pkt_data)->authentication = AUTH;
        ((cmdMsgHeader_t *)pkt_data)->count = state->msgCount;
        ((cmdMsgHeader_t *)pkt_data)->cmd_type = commandType;
        ((cmdMsgHeader_t *)pkt_data)->command = command;
        ((cmdMsgHeader_t *)pkt_data)->field.lattitude.degrees = 39;
        ((cmdMsgHeader_t *)pkt_data)->field.lattitude.minutes = 20;
        ((cmdMsgHeader_t *)pkt_data)->field.lattitude.seconds = 19;
        ((cmdMsgHeader_t *)pkt_data)->field.longitude.degrees = 77;
        ((cmdMsgHeader_t *)pkt_data)->field.longitude.minutes =	6;
        ((cmdMsgHeader_t *)pkt_data)->field.longitude.seconds =	34;

      }
      */

      // here is where we exit out if the command sent was shutdown 
      if (shutdown == 1) exit(1);
      if (cmdPacket.header.cmd_type == SET_COMMAND && cmdPacket.setMode.field == ENCRYPT_STATE) 
      {
        state->AES_encryption = cmdPacket.setMode.value;
      }
      /* print the server's reply */
      fprintf(stderr,"waiting for response\n");
      bzero(recvBuff, MAX_BUFSIZE);
      fprintf(stderr,"just zero'd the buffer\n");

      n = recvfrom(sockfd, recvBuff, MAX_BUFSIZE, 0, (struct sockaddr *) &serveraddr, &serverlen);
      fprintf(stderr,"strlen(recv) = %d\n", (int)strlen(recvBuff));
      if (n < 0) 
        error("ERROR in recvfrom");

      fprintf(stderr,"Response from server: \n ");

      if (state->AES_encryption == On && nextState == Command_Mode)
      {
        fprintf(stderr,"calling decrypt packet\n");
        xcrypt(&state->aes_ctx, recvBuff, n);
      }


      cmdReplyHeader_t *reply = (cmdReplyHeader_t *)recvBuff;

      fprintf(stderr,"authentication is: %X\n", reply->authentication);
      fprintf(stderr,"count is: %X\n", reply->count);
      fprintf(stderr,"dataSize is: %d\n", reply->dataSize);
      fprintf(stderr,"crc is: %X\n", reply->crc);
	  fprintf(stderr,"system state value: %X\n", reply->systemState);

      state->mode = reply->systemState;
      
      switch(state->mode) {
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
      switch(nextState) {
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
      fprintf(stderr,"\n\n...\n");


      state->msgCount = reply->count + 1;

      fprintf(stderr,"...\n");
    }
  }
  return 0;
}

































