#include "common.h"

/* Function: error
*  
*  Description: error handling, exits program due to an error
*
*  Arguments: char *msg
*
*  return: 1, for error
*
*/
void error(char *msg)
{
	perror(msg);
	exit(1);
}

/* Function: initCrypto
*  
*  Description: function reads in a hash file with both
*               a key and iv.  This is very basic and if this
*	            production code we wouldn't do it this way.
*				Puts the key and the iv in a global value.
*
*  Arguments: none
*
*  return: none
*
*/
void initCrypto(SystemState s)
{
	FILE *fp;
	//char *buf;
	//long len;
	
	fp = fopen("hash.txt", "rb");
	if (fp == NULL)
	{
		error("Error in initCrypto");
	}

	fread(masterKey, 16, 1, fp);
	fread(masterIv, 16, 1, fp);

	fclose(fp);
	
	AES_init_ctx_iv(&s->aes_ctx, masterKey, masterIv);
}

/* Function: initSocket
*  
*  Description: Sets up the socket for listenling and
*				binds it to a port. port is defined in
*				common.h
*
*  Arguments: none
*
*  return: unsigned int, sockfd
*
*/
int initSocket(void)
{
	int sockfd; 	/* socket and return item  */
	unsigned int port; 		/* port we are going to listen on */
	int 		 optval;  	/* flag value for setsockopt */
	struct sockaddr_in serverAddr;
	
	port = atoi(PORT);  //PORT is defined in command.h
	
	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if (sockfd < 0)
	{
		error("Error in socket");
	}
	
	optval = 1;
	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR,
			(const void *)&optval, sizeof(int));
			
	/* Build the server's network address */
	
	bzero((char *) &serverAddr, sizeof(serverAddr));
	serverAddr.sin_family = AF_INET;
	serverAddr.sin_addr.s_addr = INADDR_ANY;
	serverAddr.sin_port = htons((uint16_t)port);
	
	/* bind the socket with a port */
	
	if (bind(sockfd, (struct sockaddr *) &serverAddr,
		sizeof(serverAddr)) < 0)
	{
		error("Error in bind");
	}
	
	return sockfd;
}

/* Function: main
*  
*  Description: main function, calls initialization functions
*               and command function to handle incoming commands.
*               It will also send the reply back to the client.
*				The function will have an indefinate loop to listen
*               and send. Breaks when there is an error.
*
*  Arguments: none
*
*  return: int, upon return
*
*/
int main (void)
{
	SystemState s = malloc(sizeof(system_state_t)); 

	int serverfd, sockfd; 	/*socket */
	unsigned int clientlen = sizeof(struct sockaddr_in);  /* client address size */
	int n = 0;
	struct sockaddr_in clientAddr; /* client address */
	char msgBuf[MAX_BUFSIZE]; /* our message buf */

	char *service_host = getenv("SERVICE_HOST");
	int service_port = atoi(getenv("SERVICE_PORT"));
	printf("Satellite listening on tcp:%s:%d\n", service_host, service_port);
	fflush(stdout);
	/* initialize the function pointer table for low power mode 
	*/
	
	s->functions.cmdCommandMode = invalidCmd;
	s->functions.cmdLowPowerMode = invalidCmd;
	s->functions.cmdDebugMode = invalidCmd;
	s->functions.wakeUp = wakeUp;
	s->functions.shutdown = shutDown;

	s->functions.cmdSysCall_1 = invalidCmd;
	s->functions.cmdSysCall_2 = invalidCmd;
	s->functions.cmdSysCall_3 = invalidCmd;
	s->functions.cmdSysCall_4 = invalidCmd;
	s->functions.cmdSysCall_5 = invalidCmd;
	s->functions.queryState = invalidCmd;
	s->functions.flag = invalidCmd;
	s->functions.invalid = invalidCmd;
	
	s->functions.encrypt = (int (*)(SystemState,char*, uint8_t))invalidCmd;
	s->functions.countReset = (int (*)(SystemState,char*, uint8_t))invalidCmd;
	
	/* init global state variables */
	s->msgCount = 0;
	s->AES_encryption = On;
	s->mode = Low_Power;
	
	/* call to initCrypto */
	initCrypto(s);
	
	/* call to initSocket and get socket for
	*  recieving and sending UDP data.
	*/
	serverfd = initSocket();
	if (listen(serverfd, 5) != 0)
	{
		error("Error Listening");
	}
	sockfd = accept(serverfd, (struct sockaddr *) &clientAddr, &clientlen);
	
	/* indefinate loop */
	while(1)
	{
		
		/* zero out the buffer so we don't have 
		* any garbage from memory sitting in our
		* data.
		*/
		bzero(msgBuf, MAX_BUFSIZE);
		/* recieve UDP from client */
		n = recv(sockfd, msgBuf, MAX_BUFSIZE, 0);
		/*make sure we actually got data */
		if (n < 0)
		{
			error("Error in recv");
		}
		
		
		/* call command mode, our msgBuf will get changed
		*  during the command handling.
		*/

		n = commandMode(s, msgBuf, n);
		#ifdef DEBUG
			fprintf(stderr,"size (what we are sending) = %X\n", n);
		#endif
		
		/* send the response to the client */
		n = send(sockfd, msgBuf, n, 0);
		
		
		/* error handling, make sure we sent data back */
		if (n < 0)
		{
			error("Error in sendto");
		}else
		{
			#ifdef DEBUG
			fprintf(stderr,"message sent\n\n\n");
			#endif
		}
		/* increment our message counter */
		s->msgCount++;
	}
	
	return 0;
}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	