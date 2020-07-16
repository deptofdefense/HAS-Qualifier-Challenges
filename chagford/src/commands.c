#include "common.h"

/* Function: get_crrent_state
*  
*  Description: retrieve the current state of the 
*               we are in. 
*
*  Arguments: none
*
*  return: uint8_t current state
*
*/

/* Function: invalid command
*  
*  Description: Fills out the the reply message with all
*				the info that it recieved in the request msg
*				and adds in the error type for invalid command.
*
*  Arguments: char *msg, message recieved.
*
*  return: none, however the results are in the message buffer.
*
*/
int invalidCmd(SystemState s, char *msg)
{
	uint32_t crcValue = 0;
	char tmpBuf[sizeof(cmdReplyHeader_t)];
	
	#ifdef DEBUG
	fprintf(stderr,"this is an invalid command\n");
	#endif
	
	/* set values in reply */
	
	((cmdReplyHeader_t*)tmpBuf)->authentication = ((cmdMsgHeader_t*)msg)->authentication; 
	((cmdReplyHeader_t*)tmpBuf)->count = ((cmdMsgHeader_t*)msg)->count;
	((cmdReplyHeader_t*)tmpBuf)->result = CMD_TYPE_ERR;
	((cmdReplyHeader_t*)tmpBuf)->systemState = s->mode;
	((cmdReplyHeader_t*)tmpBuf)->dataSize = sizeof(cmdReplyHeader_t);
	
	/* get the crc checksum for this packet */ 
	crcValue = checksum (tmpBuf + sizeof(crcValue), sizeof(tmpBuf) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)tmpBuf)->crc = crcValue;
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
	/* copy tmpBuf into our response buffer */
	memcpy(msg, tmpBuf, sizeof(cmdReplyHeader_t));
	
	return ((cmdReplyHeader_t*)msg)->dataSize;
}

/* Function: setCommandMode
*  
*  Description: change state, update all the function pointers for the 
*				appropriate state and send back the reply in the msg buff.
*
*  Arguments: char * msg, command msg to change state
*
*  return: Length of message in buffer.
*
*/
int setCommandMode(SystemState s, char *msg)
{
	uint32_t crcValue = 0;
	char tmpBuf[sizeof(cmdReplyHeader_t)];
		
	#ifdef DEBUG
	fprintf(stderr,"changing mode\n");
	#endif
	
	/*fill out the reply message header */
	((cmdReplyHeader_t*)tmpBuf)->authentication = ((cmdMsgHeader_t*)msg)->authentication; 
	((cmdReplyHeader_t*)tmpBuf)->count = ((cmdMsgHeader_t*)msg)->count;
	((cmdReplyHeader_t*)tmpBuf)->dataSize = sizeof(cmdReplyHeader_t);
	
	#ifdef DEBUG
	fprintf(stderr,"Command Mode - changing states\n");
	#endif
	
	s->mode = Command_Mode;
	s->functions.cmdCommandMode  = invalidCmd;
	s->functions.cmdLowPowerMode = setLowPowerMode;
	s->functions.cmdDebugMode 	 = setDebugMode;
	s->functions.wakeUp 		 = invalidCmd;
	s->functions.shutdown 		 = shutDown;

	s->functions.cmdSysCall_1 	= sysCall1;
	s->functions.cmdSysCall_2 	= sysCall2;
	s->functions.cmdSysCall_3 	= sysCall3;
	s->functions.cmdSysCall_4 	= sysCall4;
	s->functions.cmdSysCall_5 	= sysCall5;
	s->functions.queryState 	= querySt;
	s->functions.flag 			= getFlag;

	s->functions.encrypt 	= cryptOnOff;
	s->functions.countReset = msgCountRst;

	s->functions.invalid 	= invalidCmd;

	((cmdReplyHeader_t*)tmpBuf)->result = SUCCESS;

	/* set the new system state in the reply packet */
	((cmdReplyHeader_t*)tmpBuf)->systemState = s->mode;
	
	#ifdef DEBUG
		fprintf(stderr,"next state: %X\n", s->mode);
		fprintf(stderr,"next state: %X\n", ((cmdReplyHeader_t*)tmpBuf)->systemState);
		
	#endif
	
	/* get our crc checksum value and put in the packet header */
	crcValue = checksum (tmpBuf + sizeof(crcValue), sizeof(tmpBuf) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)tmpBuf)->crc = crcValue;
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
	/* copy our tmpbuf into our reply message */
	memcpy(msg, tmpBuf, sizeof(cmdReplyHeader_t));
	
	return ((cmdReplyHeader_t*)msg)->dataSize;
}

/* Function: setLowPowerMode
*  
*  Description: change state, update all the function pointers for the 
*				appropriate state and send back the reply in the msg buff.
*
*  Arguments: char * msg, command msg to change state
*
*  return: none, however the results are in the message buffer.
*
*/
int setLowPowerMode(SystemState s, char *msg)
{
	
	uint32_t crcValue = 0;
	char tmpBuf[sizeof(cmdReplyHeader_t)];
		
	#ifdef DEBUG
	fprintf(stderr,"changing mode\n");
	#endif
	
	/*fill out the reply message header */
	((cmdReplyHeader_t*)tmpBuf)->authentication = ((cmdMsgHeader_t*)msg)->authentication; 
	((cmdReplyHeader_t*)tmpBuf)->count = ((cmdMsgHeader_t*)msg)->count;
	((cmdReplyHeader_t*)tmpBuf)->dataSize = sizeof(cmdReplyHeader_t);
	
	#ifdef DEBUG
	fprintf(stderr,"resetting message counter to zero\n");
	#endif
	/* set the new system state */
	s->mode = Low_Power;
	
	/* update the function tables low power mode */
	s->functions.cmdCommandMode 	= invalidCmd;
	s->functions.cmdLowPowerMode 	= invalidCmd;
	s->functions.cmdDebugMode 		= invalidCmd;
	s->functions.wakeUp 			= wakeUp;
	s->functions.shutdown 			= shutDown;

	s->functions.cmdSysCall_1 = invalidCmd;
	s->functions.cmdSysCall_2 = invalidCmd;
	s->functions.cmdSysCall_3 = invalidCmd;
	s->functions.cmdSysCall_4 = invalidCmd;
	s->functions.cmdSysCall_5 = invalidCmd;
	s->functions.queryState   = invalidCmd;
	s->functions.flag 		  = invalidCmd;

	s->functions.encrypt 	  = (int (*)(SystemState,char*, uint8_t))invalidCmd;
	s->functions.countReset   = (int (*)(SystemState,char*, uint8_t))invalidCmd;
	
	s->functions.invalid 	  = invalidCmd;
	
	/* add success to our reply */
	((cmdReplyHeader_t*)tmpBuf)->result = SUCCESS;
		
	/* set the new system state in the reply packet */
	((cmdReplyHeader_t*)tmpBuf)->systemState = s->mode;
	
	#ifdef DEBUG
		fprintf(stderr,"next state: %X\n", s->mode);
		fprintf(stderr,"next state: %X\n", ((cmdReplyHeader_t*)tmpBuf)->systemState);
		
	#endif
	
	/* get our crc checksum value and put in the packet header */
	crcValue = checksum (tmpBuf + sizeof(crcValue), sizeof(tmpBuf) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)tmpBuf)->crc = crcValue;
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
	/* copy our tmpbuf into our reply message */
	memcpy(msg, tmpBuf, sizeof(cmdReplyHeader_t));
	
	return ((cmdReplyHeader_t*)msg)->dataSize;
}

/* Function: setDebugMode
*  
*  Description: change state, update all the function pointers for the 
*				appropriate state and send back the reply in the msg buff.
*
*  Arguments: char * msg, command msg to change state
*
*  return: none, however the results are in the message buffer.
*
*/
int setDebugMode(SystemState s, char *msg)
{
	uint32_t crcValue = 0;
	char tmpBuf[sizeof(cmdReplyHeader_t)];
		
	#ifdef DEBUG
	fprintf(stderr,"changing mode\n");
	#endif
	
	/*fill out the reply message header */
	((cmdReplyHeader_t*)tmpBuf)->authentication = ((cmdMsgHeader_t*)msg)->authentication; 
	((cmdReplyHeader_t*)tmpBuf)->count = ((cmdMsgHeader_t*)msg)->count;
	((cmdReplyHeader_t*)tmpBuf)->dataSize = sizeof(cmdReplyHeader_t);
	

	#ifdef DEBUG
	fprintf(stderr,"Command Mode - changing states\n");
	#endif
	
	/* set the new system state */
	s->mode = Debug_Mode;
	/* update the function tables for debug mode */
	s->functions.cmdCommandMode  = setCommandMode;
	s->functions.cmdLowPowerMode = invalidCmd;
	s->functions.cmdDebugMode    = invalidCmd;	
	s->functions.wakeUp          = invalidCmd;
	s->functions.shutdown        = shutDown;

	s->functions.cmdSysCall_1 = invalidCmd;
	s->functions.cmdSysCall_2 = invalidCmd;
	s->functions.cmdSysCall_3 = invalidCmd;
	s->functions.cmdSysCall_4 = invalidCmd;
	s->functions.cmdSysCall_5 = invalidCmd;
	s->functions.flag 		  = invalidCmd;
	
	s->functions.encrypt 	  = cryptOnOff;
	s->functions.countReset   = msgCountRst;

	s->functions.invalid = invalidCmd;
	
	/* add success to our reply */
	((cmdReplyHeader_t*)tmpBuf)->result = SUCCESS;
	
	/* well, we are in command mode, and the client
	*  didn't ask for an appropriate transition to 
	* either debug or lowpwr mode, so lets default and
	* send back an error
	*/
		
	
	/* set the new system state in the reply packet */
	((cmdReplyHeader_t*)tmpBuf)->systemState = s->mode;
	
	#ifdef DEBUG
		fprintf(stderr,"next state: %X\n", s->mode);
		fprintf(stderr,"next state: %X\n", ((cmdReplyHeader_t*)tmpBuf)->systemState);
		
	#endif
	
	/* get our crc checksum value and put in the packet header */
	crcValue = checksum (tmpBuf + sizeof(crcValue), sizeof(tmpBuf) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)tmpBuf)->crc = crcValue;
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
	/* copy our tmpbuf into our reply message */
	memcpy(msg, tmpBuf, sizeof(cmdReplyHeader_t));
	
	return ((cmdReplyHeader_t*)msg)->dataSize;
}

/* Function: wakeUp
*  
*  Description: s->mode is in low power mode, this function
*				"wakes up" the satalite and moves it to command mode.
*				it also sets up the function table for command mode
*				operations.
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
int wakeUp(SystemState s, char *msg)
{
	return setCommandMode(s,msg);
}

/* Function: sysCall1
*  
*  Description: Call a python script to retrieve data.
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
int sysCall1(SystemState s, char *msg)
{
	
	FILE *fp = NULL;
	size_t nread;
	char tmpBuf[1024];
	uint32_t crcValue = 0;
	unsigned int size = 0;
	cmdMsgHeader_t request;
	
	#ifdef DEBUG
	fprintf(stderr,"system call 1\n");
	#endif
	
	/* get values from the command message, store them localy.
	*  we will use them to add into the response
	*/
	request.authentication = ((cmdMsgHeader_t*)msg)->authentication;
	request.count = ((cmdMsgHeader_t*)msg)->count;
	request.cmd_type = ((cmdMsgHeader_t*)msg)->cmd_type;
	
	/* zero out our buffers */
	bzero(msg, MAX_BUFSIZE);
	bzero(tmpBuf, MAX_BUFSIZE);
	/* put in the basic info in our repose header */
	
	((cmdReplyHeader_t*)msg)->authentication = request.authentication;
	((cmdReplyHeader_t*)msg)->count = request.count;
	((cmdReplyHeader_t*)msg)->systemState = s->mode;
	
	/* we are calling python here and using file i/o to do it,
	*  and redirecting stdout to to us as a result.
	*/
	fp = popen("python mars.py", "r");  // Open the command for reading.
    /* error handeling */
	if (fp == NULL) 
	{
        /* if we are here, the file i/0 failed,so we will send a command
		*  failed back.
		*/
		((cmdReplyHeader_t*)msg)->result = COMMAND_FAIL;
		/* set data size of response */
		((cmdReplyHeader_t*)msg)->dataSize = sizeof(cmdReplyHeader_t);
    }else
	{
		/* we are here because the command worked.  or at least we got 
		* something back from the script we called.
		*/
		while ((nread = fread(tmpBuf, 1, sizeof(tmpBuf), fp)) > 0)
		{
			#ifdef DEBUG
			fwrite(tmpBuf, 1, nread, stdout);
			#endif
		}
		/* have to close out the file pointer */
		pclose(fp);  // close 
		
		/* set result to success */
		((cmdReplyHeader_t*)msg)->result = SUCCESS;
		
		/* our response was string, so lets get the string len */
		size = strlen(tmpBuf);
		#ifdef DEBUG
		fprintf(stderr,"data size: %d\n", size);
		#endif
		
		/* set the data size in the packet */
		((cmdReplyHeader_t*)msg)->dataSize = size + sizeof(cmdReplyHeader_t);
		
		/* copy the data form tmpBuf to our response message */
		memcpy(msg + sizeof(cmdReplyHeader_t), tmpBuf, nread);
		
	
	}

	/* get and set our crc checksum value */
	crcValue = checksum (msg + sizeof(crcValue), size + sizeof(cmdReplyHeader_t) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)msg)->crc = crcValue;
		
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
	return ((cmdReplyHeader_t*)msg)->dataSize;
	
}

/* Function: sysCall2
*  
*  Description: Call a python script to retrieve data.
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
int sysCall2(SystemState s, char *msg)
{	
	FILE *fp = NULL;
	size_t nread;
	char tmpBuf[1024];
	uint32_t crcValue = 0;
	unsigned int size = 0;
	cmdMsgHeader_t request;
	
	#ifdef DEBUG
	fprintf(stderr,"system call 2\n");
	#endif
	
		/* get values from the command message, store them localy.
	*  we will use them to add into the response
	*/
	request.authentication = ((cmdMsgHeader_t*)msg)->authentication;
	request.count = ((cmdMsgHeader_t*)msg)->count;
	request.cmd_type = ((cmdMsgHeader_t*)msg)->cmd_type;
	
	/* zero out our buffers */
	bzero(msg, MAX_BUFSIZE);
	bzero(tmpBuf, MAX_BUFSIZE);
	/* put in the basic info in our repose header */
	
	((cmdReplyHeader_t*)msg)->authentication = request.authentication;
	((cmdReplyHeader_t*)msg)->count = request.count;
	((cmdReplyHeader_t*)msg)->systemState = s->mode;
	
	/* we are calling python here and using file i/o to do it,
	*  and redirecting stdout to to us as a result.
	*/
	fp = popen("python sun.py", "r");  // Open the command for reading.
    /* error handeling */
	if (fp == NULL) 
	{
        /* if we are here, the file i/0 failed,so we will send a command
		*  failed back.
		*/
		((cmdReplyHeader_t*)msg)->result = COMMAND_FAIL;
		/* set data size of response */
		((cmdReplyHeader_t*)msg)->dataSize = sizeof(cmdReplyHeader_t);
    }else
	{
		/* we are here because the command worked.  or at least we got 
		* something back from the script we called.
		*/
		while ((nread = fread(tmpBuf, 1, sizeof(tmpBuf), fp)) > 0)
		{
			#ifdef DEBUG
			fwrite(tmpBuf, 1, nread, stdout);
			#endif
		}
		/* have to close out the file pointer */
		pclose(fp);  // close 
		
		/* set result to success */
		((cmdReplyHeader_t*)msg)->result = SUCCESS;
		
		/* our response was string, so lets get the string len */
		size = strlen(tmpBuf);
		#ifdef DEBUG
		fprintf(stderr,"data size: %d\n", size);
		#endif
		
		/* set the data size in the packet */
		((cmdReplyHeader_t*)msg)->dataSize = size + sizeof(cmdReplyHeader_t);
		
		/* copy the data form tmpBuf to our response message */
		memcpy(msg + sizeof(cmdReplyHeader_t), tmpBuf, DATA_BUFF);
		
	
	}

	/* get and set our crc checksum value */
	crcValue = checksum (msg + sizeof(crcValue), size + sizeof(cmdReplyHeader_t) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)msg)->crc = crcValue;
		
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
	return ((cmdReplyHeader_t*)msg)->dataSize;
	
}

/* Function: sysCall3
*  
*  Description: Call a python script to retrieve data.
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
int sysCall3(SystemState s, char *msg)
{	
	FILE *fp = NULL;
	size_t nread;
	char tmpBuf[1024];
	uint32_t crcValue = 0;
	unsigned int size = 0;
	cmdMsgHeader_t request;
	
	#ifdef DEBUG
	fprintf(stderr,"system call 3\n");
	#endif
	
		/* get values from the command message, store them localy.
	*  we will use them to add into the response
	*/
	request.authentication = ((cmdMsgHeader_t*)msg)->authentication;
	request.count = ((cmdMsgHeader_t*)msg)->count;
	request.cmd_type = ((cmdMsgHeader_t*)msg)->cmd_type;
	
	/* zero out our buffers */
	bzero(msg, MAX_BUFSIZE);
	bzero(tmpBuf, MAX_BUFSIZE);
	/* put in the basic info in our repose header */
	
	((cmdReplyHeader_t*)msg)->authentication = request.authentication;
	((cmdReplyHeader_t*)msg)->count = request.count;
	((cmdReplyHeader_t*)msg)->systemState = s->mode;
	
	/* we are calling python here and using file i/o to do it,
	*  and redirecting stdout to to us as a result.
	*/
	fp = popen("python venus.py", "r");  // Open the command for reading.
    /* error handeling */
	if (fp == NULL) 
	{
        /* if we are here, the file i/0 failed,so we will send a command
		*  failed back.
		*/
		((cmdReplyHeader_t*)msg)->result = COMMAND_FAIL;
		/* set data size of response */
		((cmdReplyHeader_t*)msg)->dataSize = sizeof(cmdReplyHeader_t);
    }else
	{
		/* we are here because the command worked.  or at least we got 
		* something back from the script we called.
		*/
		while ((nread = fread(tmpBuf, 1, sizeof(tmpBuf), fp)) > 0)
		{
			#ifdef DEBUG
			fwrite(tmpBuf, 1, nread, stdout);
			#endif
		}
		/* have to close out the file pointer */
		pclose(fp);  // close 
		
		/* set result to success */
		((cmdReplyHeader_t*)msg)->result = SUCCESS;
		
		/* our response was string, so lets get the string len */
		size = strlen(tmpBuf);
		#ifdef DEBUG
		fprintf(stderr,"data size: %d\n", size);
		#endif
		
		/* set the data size in the packet */
		((cmdReplyHeader_t*)msg)->dataSize = size + sizeof(cmdReplyHeader_t);
		
		/* copy the data form tmpBuf to our response message */
		memcpy(msg + sizeof(cmdReplyHeader_t), tmpBuf, DATA_BUFF);
		
	
	}

	/* get and set our crc checksum value */
	crcValue = checksum (msg + sizeof(crcValue), size + sizeof(cmdReplyHeader_t) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)msg)->crc = crcValue;
		
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
   	return ((cmdReplyHeader_t*)msg)->dataSize;
	
}

/* Function: sysCall4
*  
*  Description: Call a python script to retrieve data.
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
int sysCall4(SystemState s, char *msg)
{	
	FILE *fp = NULL;
	size_t nread;
	char tmpBuf[1024];
	uint32_t crcValue = 0;
	unsigned int size = 0;
	cmdMsgHeader_t request;
	
	#ifdef DEBUG
	fprintf(stderr,"system call 4\n");
	#endif
	
	/* get values from the command message, store them localy.
	*  we will use them to add into the response
	*/
	request.authentication = ((cmdMsgHeader_t*)msg)->authentication;
	request.count = ((cmdMsgHeader_t*)msg)->count;
	request.cmd_type = ((cmdMsgHeader_t*)msg)->cmd_type;
	
	/* zero out our buffers */
	bzero(msg, MAX_BUFSIZE);
	bzero(tmpBuf, MAX_BUFSIZE);
	/* put in the basic info in our repose header */
	
	((cmdReplyHeader_t*)msg)->authentication = request.authentication;
	((cmdReplyHeader_t*)msg)->count = request.count;
	((cmdReplyHeader_t*)msg)->systemState = s->mode;
	
	/* we are calling python here and using file i/o to do it,
	*  and redirecting stdout to to us as a result.
	*/
	fp = popen("python moon.py", "r");  // Open the command for reading.
    /* error handeling */
	if (fp == NULL) 
	{
        /* if we are here, the file i/0 failed,so we will send a command
		*  failed back.
		*/
		((cmdReplyHeader_t*)msg)->result = COMMAND_FAIL;
		/* set data size of response */
		((cmdReplyHeader_t*)msg)->dataSize = sizeof(cmdReplyHeader_t);
    }else
	{
		/* we are here because the command worked.  or at least we got 
		* something back from the script we called.
		*/
		while ((nread = fread(tmpBuf, 1, sizeof(tmpBuf), fp)) > 0)
		{
			#ifdef DEBUG
			fwrite(tmpBuf, 1, nread, stdout);
			#endif
		}
		/* have to close out the file pointer */
		pclose(fp);  // close 
		
		/* set result to success */
		((cmdReplyHeader_t*)msg)->result = SUCCESS;
		
		/* our response was string, so lets get the string len */
		size = strlen(tmpBuf);
		#ifdef DEBUG
		fprintf(stderr,"data size: %d\n", size);
		#endif
		
		/* set the data size in the packet */
		((cmdReplyHeader_t*)msg)->dataSize = size + sizeof(cmdReplyHeader_t);
		
		/* copy the data form tmpBuf to our response message */
		memcpy(msg + sizeof(cmdReplyHeader_t), tmpBuf, size);
		
	
	}

	/* get and set our crc checksum value */
	crcValue = checksum (msg + sizeof(crcValue), size + sizeof(cmdReplyHeader_t) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)msg)->crc = crcValue;
		
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
	return ((cmdReplyHeader_t*)msg)->dataSize;
	
}

/* Function: sysCall5
*  
*  Description: Call a python script to retrieve data.
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
int sysCall5(SystemState s, char *msg)
{	
	FILE *fp = NULL;
	size_t nread;
	char tmpBuf[1024];
	uint32_t crcValue = 0;
	unsigned int size = 0;
	cmdMsgHeader_t request;
	
	#ifdef DEBUG
	fprintf(stderr,"system call 4\n");
	#endif
	
	/* get values from the command message, store them localy.
	*  we will use them to add into the response
	*/
	request.authentication = ((cmdMsgHeader_t*)msg)->authentication;
	request.count = ((cmdMsgHeader_t*)msg)->count;
	request.cmd_type = ((cmdMsgHeader_t*)msg)->cmd_type;
	
	/* zero out our buffers */
	bzero(msg, MAX_BUFSIZE);
	bzero(tmpBuf, MAX_BUFSIZE);
	/* put in the basic info in our repose header */
	
	((cmdReplyHeader_t*)msg)->authentication = request.authentication;
	((cmdReplyHeader_t*)msg)->count = request.count;
	((cmdReplyHeader_t*)msg)->systemState = s->mode;
	
	/* we are calling python here and using file i/o to do it,
	*  and redirecting stdout to to us as a result.
	*/
	fp = popen("python spaceodity.py", "r");  // Open the command for reading.
    /* error handeling */
	if (fp == NULL) 
	{
        /* if we are here, the file i/0 failed,so we will send a command
		*  failed back.
		*/
		((cmdReplyHeader_t*)msg)->result = COMMAND_FAIL;
		/* set data size of response */
		((cmdReplyHeader_t*)msg)->dataSize = sizeof(cmdReplyHeader_t);
    }else
	{
		/* we are here because the command worked.  or at least we got 
		* something back from the script we called.
		*/
		while ((nread = fread(tmpBuf, 1, sizeof(tmpBuf), fp)) > 0)
		{
			#ifdef DEBUG
			fwrite(tmpBuf, 1, nread, stdout);
			#endif
		}
		/* have to close out the file pointer */
		pclose(fp);  // close 
		
		/* set result to success */
		((cmdReplyHeader_t*)msg)->result = SUCCESS;
		
		/* our response was string, so lets get the string len */
		size = strlen(tmpBuf);
		#ifdef DEBUG
		fprintf(stderr,"data size: %d\n", size);
		#endif
		
		/* set the data size in the packet */
		((cmdReplyHeader_t*)msg)->dataSize = size + sizeof(cmdReplyHeader_t);
		
		/* copy the data form tmpBuf to our response message */
		memcpy(msg + sizeof(cmdReplyHeader_t), tmpBuf, size);
		
	
	}

	/* get and set our crc checksum value */
	crcValue = checksum (msg + sizeof(crcValue), size + sizeof(cmdReplyHeader_t) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)msg)->crc = crcValue;
		
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
	return ((cmdReplyHeader_t*)msg)->dataSize;	
}

/* Function: getFlag
*  
*  Description: Call a python script to retrieve the FLAG!
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
int getFlag(SystemState s, char *msg)
{
	uint32_t crcValue = 0;
	unsigned int size = 0;
	cmdMsgHeader_t request;

	#ifdef DEBUG
	fprintf(stderr,"get flag function\n");
	#endif
	
	/* get values from the command message, store them localy.
	*  we will use them to add into the response
	*/
	request.authentication = ((cmdMsgHeader_t*)msg)->authentication;
	request.count = ((cmdMsgHeader_t*)msg)->count;
	request.cmd_type = ((cmdMsgHeader_t*)msg)->cmd_type;

	/* zero out our buffers */
	bzero(msg, MAX_BUFSIZE);
	/* put in the basic info in our repose header */
	
	((cmdReplyHeader_t*)msg)->authentication = request.authentication;
	((cmdReplyHeader_t*)msg)->count = request.count;
	((cmdReplyHeader_t*)msg)->systemState = s->mode;
	((cmdReplyHeader_t*)msg)->result = SUCCESS;
	char *flag = getenv("FLAG");
	size = strlen(flag);
	memcpy(msg + sizeof(cmdReplyHeader_t), flag, size);
	((cmdReplyHeader_t*)msg)->dataSize = size + sizeof(cmdReplyHeader_t);

	crcValue = checksum (msg + sizeof(crcValue), size + sizeof(cmdReplyHeader_t) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)msg)->crc = crcValue;

	return ((cmdReplyHeader_t*)msg)->dataSize;	

}

/* Function: cryptOnOff
*  
*  Description: function that enables or disables encryption.
*				Note: can only be called from debug mode.
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
int cryptOnOff(SystemState s, char *msg, uint8_t reqMode)
{
	uint32_t crcValue = 0;
	char tmpBuf[sizeof(cmdReplyHeader_t)];
	
	#ifdef DEBUG
	fprintf(stderr,"enable/disable encryption: ");
	#endif
	
	/* check to see if we are setting encryption is 
	*  going to be set to on or off, and doing so.
	*/
	if(reqMode == OFF)
	{
		s->AES_encryption = OFF;
		((cmdReplyHeader_t*)tmpBuf)->result = SUCCESS;
		
		#ifdef DEBUG
		fprintf(stderr,"disable encryption\n");
		#endif
		
	}else if (reqMode == ON)
	{
		s->AES_encryption = ON;
		((cmdReplyHeader_t*)tmpBuf)->result = SUCCESS;
		
		#ifdef DEBUG
		fprintf(stderr,"enable encryption\n");
		#endif
	
	/* if we reach this else statement, we got a bad command */
	}else
	{
		
		((cmdReplyHeader_t*)tmpBuf)->result = COMMAND_FAIL;
		#ifdef DEBUG
		fprintf(stderr,"set encryption failed");
		#endif
	}
	
	/* stet the back header information */
	((cmdReplyHeader_t*)tmpBuf)->authentication = ((cmdMsgHeader_t*)msg)->authentication; 
	((cmdReplyHeader_t*)tmpBuf)->count = ((cmdMsgHeader_t*)msg)->count;
	((cmdReplyHeader_t*)tmpBuf)->dataSize = sizeof(cmdReplyHeader_t);
	
	((cmdReplyHeader_t*)tmpBuf)->systemState = s->mode;
	
	/* get our CRC checksum and set it in the packet header */
	crcValue = checksum (tmpBuf + sizeof(crcValue), sizeof(tmpBuf) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)tmpBuf)->crc = crcValue;
	
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
	/* copy everything over into our response message */
	memcpy(msg, tmpBuf, sizeof(cmdReplyHeader_t));
	return ((cmdReplyHeader_t*)msg)->dataSize;
	
}

/* Function: shutdown
*  
*  Description: if we got a shutdown command, we will exit the program.
*
*  Arguments: char *msg, command message we received
*
*  return: none
*
*/
int shutDown(SystemState s, char *msg)
{
	/* tell everyone we are shuttingdown and
	*  exit.
	*/
	(void)s;
	(void)msg;
	fprintf(stderr,"system shutdown\n");
	fflush(0);
	exit(0);
	
}

/* Function: querySt
*  
*  Description: function to handle quesry state command.
*				NOTE: this function is currently not used,
*				we send back the current state in our packet
*				responses. but I left it here anyway.
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
int querySt(SystemState s, char *msg)
{
	uint32_t crcValue = 0;
	char tmpBuf[sizeof(cmdReplyHeader_t)];
	
	#ifdef DEBUG
	fprintf(stderr,"query command\n");
	#endif
	
	((cmdReplyHeader_t*)tmpBuf)->authentication = ((cmdMsgHeader_t*)msg)->authentication; 
	((cmdReplyHeader_t*)tmpBuf)->count = ((cmdMsgHeader_t*)msg)->count;
	((cmdReplyHeader_t*)msg)->dataSize = sizeof(cmdReplyHeader_t);
	 
	((cmdReplyHeader_t*)tmpBuf)->result = s->mode;
	((cmdReplyHeader_t*)tmpBuf)->systemState = s->mode;
	
	
	crcValue = checksum (tmpBuf + sizeof(crcValue), sizeof(tmpBuf) - sizeof(crcValue), 0xffffffff);
	((cmdReplyHeader_t*)tmpBuf)->crc = crcValue;
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	
	memcpy(msg, tmpBuf, sizeof(cmdReplyHeader_t));

	return ((cmdReplyHeader_t*)msg)->dataSize;

}

/* Function: msgCountRst
*  
*  Description: reset the message counter to zero. I put this 
*				in here to make it a little easier, and incase
*				I thought I was getting out of sync.
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
int msgCountRst(SystemState s, char *msg, uint8_t count)
{
	uint32_t crcValue = 0;
	char tmpBuf[sizeof(cmdReplyHeader_t)];
	
	#ifdef DEBUG
	fprintf(stderr,"reset message counter\n");
	#endif
	
	/* reset the message counter */
	s->msgCount = count;
	
	/* set the respnose header info */
	((cmdReplyHeader_t*)tmpBuf)->authentication = ((cmdMsgHeader_t*)msg)->authentication; 
	((cmdReplyHeader_t*)tmpBuf)->count = ((cmdMsgHeader_t*)msg)->count;
	((cmdReplyHeader_t*)tmpBuf)->result = SUCCESS;
	((cmdReplyHeader_t*)tmpBuf)->dataSize = sizeof(cmdReplyHeader_t);
	((cmdReplyHeader_t*)tmpBuf)->systemState = s->mode;
	
	/* get our checksum */
	crcValue = checksum (tmpBuf + sizeof(crcValue), sizeof(tmpBuf) - sizeof(crcValue), 0xffffffff);
	
	#ifdef DEBUG
	fprintf(stderr,"checksum = %8X\n", crcValue);
	#endif
	/* set our crc checksum in our packet */
	((cmdReplyHeader_t*)tmpBuf)->crc = crcValue;
	
	/* copy everything over into our reponse message */
	memcpy(msg, tmpBuf, sizeof(cmdReplyHeader_t));
	
	return ((cmdReplyHeader_t*)msg)->dataSize;
	
}

/* Function: validate_pkt
*  
*  Description: validate that we received the correct packet.
*				check that we got our magic number, crc checksum is
*				correct, and that our packet count is correct, or 
*				becuse we are nice, +/- a few.
*
*  Arguments: char *msg, command message we received
*
*  return: none, however the results are in the message buffer.
*
*/
uint8_t validate_pkt(SystemState s, char *msg)
{
	uint8_t result = 1;
	uint32_t crcValue = 0;
	
	cmdMsgHeader_t * request = (cmdMsgHeader_t *)msg;
	if (request->cmd_type == QUERY_COMMAND)
	{
		#ifdef DEBUG
		fprintf(stderr,"command is either change mode or wakeup\n");
		#endif
		crcValue = checksum (msg + sizeof(crcValue), sizeof(cmdQuery_t) - sizeof(crcValue), 0xffffffff);
		
	/*if it is not a state change, lets get the right CRC value for a cmdMsgHeader_t */	
	}else if (request->cmd_type == SET_COMMAND)
	{
		crcValue = checksum (msg + sizeof(crcValue), sizeof(cmdSetMode_t) - sizeof(crcValue), 0xffffffff);
	
	}else
	{
		crcValue = checksum (msg + sizeof(crcValue), sizeof(cmdMsgHeader_t) - sizeof(crcValue), 0xffffffff);
	}
	
	/* do we have the correct magic number */
	if(request->authentication != AUTH)
	{
		result = 0;
		
		#ifdef DEBUG
		fprintf(stderr,"invalid packet: authentication error, 0x%X\n", ((cmdReplyHeader_t*)msg)->authentication);
		#endif
		exit(1);
	}
	/* check the message counter to see if it is correct, or really close to correct */
	if(request->count < s->msgCount) 
	{
		result = 0;
		
		#ifdef DEBUG
		fprintf(stderr,"1 invalid packet: pkt count error, count was %d and should be %d\n", ((cmdReplyHeader_t*)msg)->count, s->msgCount);
		#endif
		//if ((((cmdReplyHeader_t*)msg)->cmd_type == PKT_RESET)) result = 1;  //client is wanting to reset counter so we will forgo this requirement.
		
		shutDown(s, msg);
		
		exit(1);
	}
	if(request->count > s->msgCount + 1)
	{
		result = 0;
		
		#ifdef DEBUG
		fprintf(stderr,"2 invalid packet: pkt count error, count was %d and should be %d\n", ((cmdReplyHeader_t*)msg)->count, s->msgCount);
		#endif
		
		shutDown(s, msg);
		
		exit(1);	
	}
	/* last check is to see what the checksum is. */
	if (request->crc != crcValue)
	{
		result = 0;
		
		#ifdef DEBUG
		fprintf(stderr,"invalid packet: checksum error, packet checksum 0x%X, we calculated it to be 0x%X\n", ((cmdReplyHeader_t*)msg)->crc, crcValue);
		#endif
		exit(1);	
	}
	return result;
	
}

