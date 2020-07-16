#include "common.h"

/* Function:
*  
*  Description:
*
*  Arguments:
*
*  return:
*
*/
int commandMode(SystemState s, char *message, int len)
{
	cmdMsgHeader_t *request = NULL;
	cmdQuery_t *query = NULL;
	cmdSetMode_t *setStateCmd = NULL;
	
	#ifdef DEBUG
	if (s->AES_encryption == On) fprintf(stderr,"encryption is on\n");
	if (s->mode == Command_Mode) fprintf(stderr,"system is in command mode\n");
	if (s->mode == Debug_Mode) fprintf(stderr,"system is in Debug mode\n");
	if (s->mode == Low_Power) fprintf(stderr,"system is in Low power mode\n");
	#endif
	
	/* lets see if encryption is both on, and we are in command mode,
	*  so we know that we need to decrypt the packet.
	*/
	if (s->AES_encryption == On && s->mode == Command_Mode)
	{
		#ifdef DEBUG
		fprintf(stderr,"encryption on: calling decrypt\n");
		#endif
		xcrypt(&s->aes_ctx, message, len);
	}
	/* Helper structs to clean up code, they both point to the message buffer 
	*/
	request = (cmdMsgHeader_t *)message;

	/* call validate_pkt to make sure the packet has all the
	*  valid feilds requierd. if so we will then handle the type 
	*  of packet that we received. The functions called below are
	*  in a function table, so it if the command is allowed the 
	*  function will get called, if not it will call invalid 
	*  command. These commands are updated in the cmdModeChange
	*  function.  It is not obvious here which is valid and which
	*  is not. It depends on the current_state we are in.
	*/
	if (validate_pkt(s, message) != 1)
	{
		fprintf(stderr,"packet failed.....\n");
		//just echo the packet back
		
	}else if (request->cmd_type == CMD_COMMAND)
	{
		len = s->functions.cmdCommandMode(s, message);	
	}else if (request->cmd_type == CMD_LOWPOWER)
	{
		len = s->functions.cmdLowPowerMode(s, message);	
	}else if (request->cmd_type == CMD_DEBUG)
	{
		len = s->functions.cmdDebugMode(s, message);
	}else if (request->cmd_type == WAKEUP)
	{
		len = s->functions.wakeUp(s, message);
	}else if (request->cmd_type == SHUTDOWN)
	{
		len = s->functions.shutdown(s, message);
	}else if (request->cmd_type == QUERY_COMMAND)
	{	
		query = (cmdQuery_t *)message;
		switch(query->field)
		{
			case CMD1:
				len = s->functions.cmdSysCall_1(s, message);
				break;
			case CMD2:
				len = s->functions.cmdSysCall_2(s, message);
				break;
			case CMD3:
				len = s->functions.cmdSysCall_3(s, message);
				break;
			case CMD4:
				len = s->functions.cmdSysCall_4(s, message);
				break;
			case CMD5:
				len = s->functions.cmdSysCall_5(s, message);
				break;	
			case QUERY_STATE:
				len = s->functions.queryState(s, message);
				break;
			case FLAG:
				len = s->functions.flag(s, message);
				break;			
			default:
				len = s->functions.invalid(s, message);
		}

	}else if(request->cmd_type == SET_COMMAND)
	{
		setStateCmd = (cmdSetMode_t *)message;
		switch (setStateCmd->field)
		{
			case ENCRYPT_STATE:
				len = s->functions.encrypt(s, message, setStateCmd->value);
				break;
			case PKT_RESET:
				len = s->functions.countReset(s, message, setStateCmd->value);
				break;
			default:
				len = s->functions.invalid(s, message);
		}	
	}else
	{
		len = s->functions.invalid(s, message);
	}
	/* at this point our packet has been processed 
	*  the message now contains the reply.  and we 
	*  need to see if we have to encrypt it.  
	*/
	
		
	if (s->AES_encryption == On && s->mode == Command_Mode)
	{
		#ifdef DEBUG
		fprintf(stderr,"encryption on: calling encrypt\n");
		#endif
		xcrypt(&s->aes_ctx, message, len);
	}
	
	#ifdef DEBUG
		fprintf(stderr,"len passing back to send: %X\n", len);
	#endif
	
	return len;
}