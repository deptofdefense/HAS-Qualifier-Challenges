
/* Putting all my includes here
* so I can reference them from 
* any new c file.
*/
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

//#define DEBUG 1


/* Max buffer size
* Shouldnt need anything bigger, and if so we can
* make another define or change this one.
*/
#define MAX_BUFSIZE 1024

/* Just an authentication value to put in the
* packet to make sure it is coming from us
*/
#define AUTH 0xAABBCCDD

/* Command types, currently only two.
* One to change the operating mode and one to 
* query the satellite
*/

/* No arg commands */
#define CMD_COMMAND 0x20
#define CMD_LOWPOWER 0x31
#define CMD_DEBUG 0x42
#define SHUTDOWN 0x88
#define WAKEUP 0x55

/* Query command takes one arg */
#define QUERY_COMMAND 0x5A
/* Set of command values that can only be run
* in full command mode. We do not want actual 
* strings since that will make reversing much easier
*/
#define CMD1		0x1
#define CMD2		0x2
#define CMD3		0x3
#define CMD4		0x4
#define CMD5		0x5
#define QUERY_STATE 0x6
#define FLAG  		0x66  //order 66 (flag)

/* Takes Two arguments, first is field, second is value */
#define SET_COMMAND 0x75
/* These are the fields that can be set */
#define ENCRYPT_STATE 0x94
#define PKT_RESET 0xAA



/* result values 
* can be an error, success, or just a result 
* to the satellite
*/
#define SUCCESS			 0xAAAAAAAA
#define CMD_TYPE_ERR     0xFFFFFFFF
#define	STATE_CHANGE_ERR 0xFFFFFFFE
#define COMMAND_FAIL	 0xFFFFFFFD

/* Address for both client and server.
* These may or may not be needed depending 
* on requirements
*/
//#define CLIENT_ADDR "192.168.1.40"
#define SERVER_ADDR "0.0.0.0"
//#define SERVER_ADDR "192.168.1.27"
#define PORT "8008"

/* AES Encryption definitions */

#define AES_BLOCKLEN 16 // Block length in bytes - AES is 128b block only

#define AES_KEYLEN 16   // Key length in bytes
#define AES_keyExpSize 176

/* enum for our state machine.
* enum values unless set are 0 through n,
* we will use those default values.
*/
typedef enum
{
	Command_Mode = 0,
	Low_Power  = 1,
	Debug_Mode = 42,
	Invalid_Mode = 0xFF
}SystemState_e;

#define ON  0x0
#define OFF 0x1

typedef enum
{
	On,
	Off,
}Encrypt_e;

/* Structure for the header of the packets received or sent.
* This does not include the data that would be in the packet
* returned from the satalite. Assumption that only commands 
* will be sent to the satalite.
*/

typedef struct system_state *SystemState;

typedef struct
{
	int		(*cmdCommandMode)(SystemState, char *);
	int		(*cmdLowPowerMode)(SystemState, char *);
	int		(*cmdDebugMode)(SystemState, char *);
	int  	(*wakeUp)(SystemState, char *);
	int		(*shutdown)(SystemState, char*);

	int		(*cmdSysCall_1)(SystemState, char *);
	int		(*cmdSysCall_2)(SystemState, char *);
	int 	(*cmdSysCall_3)(SystemState, char *);
	int 	(*cmdSysCall_4)(SystemState, char *);
	int		(*cmdSysCall_5)(SystemState, char *);
	
	int		(*queryState)(SystemState, char*);
	int		(*flag)(SystemState, char *);
	
	int	 	(*encrypt)(SystemState, char *, uint8_t);
	int 	(*countReset)(SystemState, char*, uint8_t);

	int		(*invalid)(SystemState, char*);
	
} funTable_t;


typedef struct
{
	int32_t		degrees;	
	int32_t		minutes;
	int32_t		seconds;
}coord_t;

typedef struct
{
	coord_t		lattitude;
	coord_t		longitude;
}fields_t;



typedef struct __attribute__ ((packed))
{
	uint32_t	crc;
	uint32_t	authentication;
	uint32_t	count;
	uint8_t		cmd_type;
} cmdMsgHeader_t;

typedef struct __attribute__ ((packed))
{
	uint32_t	crc;
	uint32_t	authentication;
	uint32_t	count;
	uint8_t		cmd_type;
	uint8_t		field;
} cmdQuery_t;

typedef struct __attribute__ ((packed))
{
	uint32_t	crc;
	uint32_t	authentication;
	uint32_t	count;
	uint8_t		cmd_type;
	uint8_t		field;
	uint8_t 	value;
} cmdSetMode_t;

typedef struct __attribute__ ((packed))
{
	uint32_t	crc;
	uint32_t	authentication;
	int32_t		count;
	uint32_t	result; //success or failure//
	SystemState_e  	systemState;
	uint32_t		dataSize;
} cmdReplyHeader_t;

#define DATA_BUFF MAX_BUFSIZE - sizeof(cmdMsgHeader_t) - sizeof(uint32_t)


/*
*
*
*/
struct AES_ctx
{
  uint8_t RoundKey[AES_keyExpSize];
  uint8_t Iv[AES_BLOCKLEN];

};


void AES_init_ctx(struct AES_ctx* ctx, const uint8_t* key);
void AES_init_ctx_iv(struct AES_ctx* ctx, const uint8_t* key, const uint8_t* iv);
void AES_ctx_set_iv(struct AES_ctx* ctx, const uint8_t* iv);
void xcrypt(struct AES_ctx*, char *message, uint32_t size);

// Same function for encrypting as for decrypting. 
// IV is incremented for every block, and used after encryption as XOR-compliment for output
// NOTES: you need to set IV in ctx with AES_init_ctx_iv() or AES_ctx_set_iv()
//        no IV should ever be reused with the same key 
void AES_CTR_xcrypt_buffer(struct AES_ctx* ctx, uint8_t* buf, uint32_t length);

uint32_t checksum (char *buf, int length, uint32_t init);

//void debugMode(char *message);
int commandMode(SystemState, char *message, int len);
//void lowPowerMode(char *message);

/*functions in commands.c */
int invalidCmd(SystemState, char * msg);
int setCommandMode(SystemState, char *msg);
int setLowPowerMode(SystemState, char *msg);
int setDebugMode(SystemState, char *msg);
int wakeUp(SystemState, char *msg);
int shutDown(SystemState, char *msg);

int sysCall1(SystemState, char *msg);
int sysCall2(SystemState, char *msg);
int sysCall3(SystemState, char *msg);
int sysCall4(SystemState, char *msg);
int sysCall5(SystemState, char *msg);
int querySt (SystemState, char *msg);
int getFlag(SystemState, char *msg);

int msgCountRst(SystemState, char *msg, uint8_t);
int cryptOnOff(SystemState, char *msg, uint8_t);

uint8_t validate_pkt (SystemState, char *msg);


/* global variable */


typedef struct system_state
{
	funTable_t functions;
	struct AES_ctx aes_ctx;
	uint32_t msgCount;				// current packet counter
	SystemState_e mode;
	Encrypt_e AES_encryption;		// is enctyption on or off, only matters in Command Mode
} system_state_t;

uint8_t masterKey[16];  //= {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
uint8_t masterIv[16]; // =  {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

