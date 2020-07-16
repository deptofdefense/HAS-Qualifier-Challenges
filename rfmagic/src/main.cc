#include "common.h"

extern int main( void );
extern void TimerInterrupt( void ) asm ("TimerInterrupt");

extern CIOConnection *g_iodata;

#if ENABLE_TEST_CODE
volatile uint32_t *FLAG_READ_ADDRESS = (uint32_t*)(0xa2008000);
void TestReadFlag( void )
{
	g_iodata->WriteData( (uint8_t*)(0xa2008000), 0x128 );
}

void TestPDUPool( void )
{
	CPDUFragmentPool m_oPDUPool;

	m_oPDUPool.InitPool( 16 );

	CPDUFragment *pNewFragment = m_oPDUPool.AllocateFragment( 1, (uint8_t*)"test", strlen("test") );
	CPDUFragment *pNewFragment2 = m_oPDUPool.AllocateFragment( 2, (uint8_t*)"test2", strlen("test2") );
	CPDUFragment *pNewFragment3 = m_oPDUPool.AllocateFragment( 3, (uint8_t*)"test3", strlen("test3") );
	
	printf( "new fragment # = %d\n", pNewFragment->GetFragmentNumber() );

	m_oPDUPool.FreeFragment( pNewFragment2 );

	pNewFragment2 = m_oPDUPool.AllocateFragment( 2, (uint8_t*)"test4", strlen("test4") );

	m_oPDUPool.FreeFragment( pNewFragment2 );
}

void TestMD5( void )
{
	uint8_t md5_digest[16];

	CMD5 oMD5;

	oMD5.InitDigest();

	oMD5.UpdateDigest( (uint8_t*)"hello there this is a test of the MD5!!!hello there this is a test of the MD5!!!", strlen("hello there this is a test of the MD5!!!hello there this is a test of the MD5!!!") );

	oMD5.GetDigest( md5_digest, 16 );

	printf( "MD5 Test: " );
	for ( uint32_t i = 0; i < 16; i++ )
	{
		printf( "%02x", md5_digest[i] );
	}
	printf( "\n" );
}

uint32_t TestReadClock( void )
{
	uint32_t readAddress = IOBASE+CLOCK_CONTROL;
	readAddress = 0xa1010000+4;

	return *((uint32_t*)(readAddress));
}

void __attribute__((externally_visible)) SetupTimerInterrupt( void )
{
	uint32_t readAddress = IOBASE+CLOCK_CONTROL;
	readAddress = 0xa1010000+8;

	*((uint32_t*)(readAddress)) = 100000;
	*((uint32_t*)(readAddress+4)) = 0x3; 
}

void TestAllocate( void )
{
	uint8_t *pData = new uint8_t[21];

	pData[0] = 10;

	printf( "pData[1] = %d\n", pData[1] );
	printf( "pData[10] = %d\n", pData[10] );
}


void TestPrintf( uint8_t testVal, uint16_t testVal2, uint32_t testVal3 )
{
	debug_log( LOG_PRIORITY_HIGH, "TESTVAL (d): %d\n", testVal );
	debug_log( LOG_PRIORITY_HIGH, "TESTVAL (u): %u\n", testVal );
	
	debug_log( LOG_PRIORITY_HIGH, "TESTVAL2 (d): %d\n", testVal2 );
	debug_log( LOG_PRIORITY_HIGH, "TESTVAL2 (u): %u\n", testVal2 );
	
	debug_log( LOG_PRIORITY_HIGH, "TESTVAL3 (d): %d\n", testVal3 );
	debug_log( LOG_PRIORITY_HIGH, "TESTVAL3 (u): %u\n", testVal3 );
}
#endif

void EnableTimerInterrupt( void )
{
	__asm__
	__volatile__
	(	
	"mfc0 $a0, $12 \n"
        "ori $a0, $a0, 0x8001 \n"              /* IM7 and IEc */
        "mtc0 $a0, $12\n"
	: : : "%a0"
	);
}

void DisableTimerInterrupt( void )
{
	__asm__
	__volatile__
	(	
	"mfc0 $a0, $12 \n"
	"lui $a1, 0xffff\n"
	"ori $a1, 0x7fff\n"
        "and $a0, $a1 \n"              /* IM7 and IEc */
        "mtc0 $a0, $12\n"
	: : : "%a0", "%a1"
	);
}

void TimerInterrupt( void )
{
	uint32_t readAddress = 0xa1010000+0xc;

	
	//printf( ">\n" );
	//putc('>');
	
	*((uint32_t*)(readAddress)) = 0x3;	// Keep interrupts enabled -- but clear this one
}

void InitPRNG( void )
{
	// TODO: Seed from something else? maybe a new device for getting random numbers!
	sprng( 10 );
}


int main( void )
{
	//printf( "CLOCK: %d\n", TestReadClock() );
	CIOConnection oConnection;

	g_iodata = &oConnection;

	InitPRNG();

	//TestReadFlag();

	//SetupTimerInterrupt();
	//EnableTimerInterrupt();

	set_log_priority( LOGGING_OFF ); // LOG_PRIORITY_LOW | LOG_PRIORITY_MEDIUM | LOG_PRIORITY_HIGH );
	//set_log_priority( LOG_PRIORITY_LOW );
	//set_log_priority( LOG_PRIORITY_LOW | LOG_PRIORITY_MEDIUM | LOG_PRIORITY_HIGH );

	// Message Queues
	CMessageQueue oMACToRLL( "UL: MACRLL" );
	CMessageQueue oRLLToRRL( "UL: RLLRRL" );

	CMessageQueue oRRLToRLL( "DL: RRLRLL" );
	CMessageQueue oRLLToMAC( "DL: RLLMAC" );
	CMessageQueue oInterMessageQueue( "GLOBAL" );

	CMac oMac( &oMACToRLL, &oRLLToMAC, &oInterMessageQueue, g_iodata );
	CRLL oRadioLink( &oMACToRLL, &oRLLToRRL, &oRLLToMAC, &oRRLToRLL, &oInterMessageQueue );
	CRRL oRadioResource( &oRLLToRRL, &oRRLToRLL, &oInterMessageQueue );

	// Initialize frame counters to be the same
	oMac.InitTimeFrameCounter( 0 );
	oRadioLink.InitTimeFrameCounter( 0 );

#if 0
	TestMD5();

	TestPDUPool();

	TestAllocate();

	DisableTimerInterrupt();

	TestPrintf( 16, 23612, 132423522 );
	
	printf( "CLOCK: %d\n", TestReadClock() );
#endif

	while ( 1 )
	{
		//printf( "CLOCK: %d\n", TestReadClock() );

		oMac.Process();
		oRadioLink.Process();
		oRadioResource.Process();
	}
	
	return (0);
}
