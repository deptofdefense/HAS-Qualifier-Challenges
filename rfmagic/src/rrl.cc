#include "common.h"

uint32_t g_apReadDataCount = 0;
uint32_t g_apWriteDataCount = 0;

void RecordAPDataWrite( void *pBuffer, uint32_t writeCount )
{
	debug_log( LOG_PRIORITY_LOW, "RRL:: AP Data (%X) length=%d", pBuffer, writeCount );

	g_apWriteDataCount += writeCount;
}

void RecordAPDataRead( void *pBuffer, uint32_t readCount )
{
	debug_log( LOG_PRIORITY_LOW, "RRL:: AP Data (%X) length=%d", pBuffer, readCount );

	g_apReadDataCount += readCount;
}

uint32_t CAccessPointData::GetIntegrityData( uint16_t startPos, uint16_t length )
{
	if ( startPos > GetTotalDataLength() )
		return 0;

	if ( length > GetTotalDataLength() )
		return 0;

	return (DoCRC32( 0xaedf8732, m_pData+startPos, length ));
}

uint32_t CAccessPoint::GetAPInfoString( uint8_t *pResponseBuffer, uint32_t responseMaxLen )
{
	char *pTempData = new char[ACCESSPOINT_NAME_MAXLEN+128];

	memcpy( pTempData, GetAPName(), GetAPNameLength() );
	pTempData[GetAPNameLength()] = '\0';

	uint32_t outputChars = sprintf( (char*)(pResponseBuffer+3), "%s: %d %d %d", pTempData, GetAPID(), GetAPType(), GetAPSpeed() );

	delete [] pTempData;

	return outputChars;
}

CRRL::CRRL( CMessageQueue *pRLLToRRLQueue, CMessageQueue *pRRLToRLLQueue, CMessageQueue *pInterMessageQueue )
	: m_pRLLToRRLQueue( pRLLToRRLQueue ), m_pRRLToRLLQueue( pRRLToRLLQueue ), m_pInterMessageQueue( pInterMessageQueue )
{
	m_localSecretKey[0] = 0xA5B5C5D5;
	m_localSecretKey[1] = 0x12345678;
	m_localSecretKey[2] = 0x41414141;
	m_localSecretKey[3] = 0xCCCCCCCC;

	m_tickCount = 0;
}

CRRL::~CRRL( )
{

}

void CRRL::Process( void )
{	
	bool bDone = false;
		
	debug_log( LOG_PRIORITY_LOW, "RLL::Radio Resource Layer Process (UL/DL processing)\n" );

	if ( 1 )
	{
		if ( m_pRLLToRRLQueue->HasMessages() )
		{
			debug_log( LOG_PRIORITY_LOW, "RRL::UL RLL PDU\n" );

			CMessage *pNewMessage = m_pRLLToRRLQueue->RecvMessage();

			HandleRLLMessage( pNewMessage->GetData(), pNewMessage->GetLength() );

			delete pNewMessage;
		}

		if ( m_pInterMessageQueue->HasMessages() )
		{
			debug_log( LOG_PRIORITY_LOW, "RRL:: INTERNAL MESSAGE\n" );

			CMessage *pNewMessage = m_pInterMessageQueue->RecvMessage();

			if ( HandleInternalMessage( pNewMessage->GetData(), pNewMessage->GetLength() ) )
				bDone = true;

			delete pNewMessage;
		}

#if X86_TARGET
		std::this_thread::sleep_for( std::chrono::milliseconds( 50 ) );
#else
		// TODO: MIPS Target
#endif

		m_tickCount++;

		if ( m_tickCount % 200 == 0 )
		{
			debug_log( LOG_PRIORITY_LOW, "RRL:: Data Statistics: DATA RX[%d] TX[%d] bytes", g_apReadDataCount, g_apWriteDataCount );
		}

	} // while ( !bDone );
}

void CRRL::HandleRLLMessage( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen < RRL_MESSAGE_LENGTH )
		return;

	// Decode message
	switch( pData[0] )
	{
	case CRLL::RLL_CHANNEL_BROADCAST:
		HandleBroadcastMessage( pData+1, dataLen-1 );
		break;

	case CRLL::RLL_CHANNEL_DEDICATED:
		HandleDedicatedMessage( pData+1, dataLen-1 );
		break;

	case CRLL::RLL_CHANNEL_FAST:
		HandleFastMessage( pData+1, dataLen-1 );
		break;

	default:
		// Do nothing
		break;
	}
}

bool CRRL::HandleInternalMessage( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen < 2 )
		return (false);

	switch ( pData[0] )
	{
	case RRL_MESSAGE_SHUTDOWN:
		// Shutdown thread
		return (true);
		break;
	}
}

void CRRL::HandleBroadcastMessage( uint8_t *pData, uint32_t dataLen )
{
	uint32_t i;
	// Broadcast messages consist of connection start message -- which includes
	// security parameters
	
	// Decode security parameters...
	if ( (pData[0] & 0xF0) == 0x70 )
	{
		if ( dataLen < 97)
			return;

		// Extract RAND
		uint8_t clientNonce[96];
		uint8_t serverNonce[96];

		// Copy in rand data
		memcpy( clientNonce, pData+1, 96 );

		// Generate our RAND
		ReadDevURandom256( serverNonce, 96 );

		// Now generate message back to send down to RLC for response
		uint8_t serverResponse[97];
	
		serverResponse[0] = 0x9d;
		memcpy( serverResponse+1, serverNonce, 96 );	

		// Send a broadcast response message (public KEY)
		SendBroadcastResponse( serverResponse, 97 );

		// INFORM RLL of the security parameters
		uint8_t rllSecurityParameters[32];
		uint8_t sharedSecretBytes[96];
	
#if 0	
		debug_log( LOG_PRIORITY_LOW, "RRL::UL CLIENT NONCE[%x%x%x%x%x%x%x%x)",
			((uint32_t*)clientNonce)[0], ((uint32_t*)clientNonce)[1], ((uint32_t*)clientNonce)[2], ((uint32_t*)clientNonce)[3],
		       	((uint32_t*)clientNonce)[4], ((uint32_t*)clientNonce)[5],
	 		((uint32_t*)clientNonce)[6], ((uint32_t*)clientNonce)[7] );		
#endif

		// Calculate
		for ( i = 0; i < 96; i+=8 )
			RunCipher( (uint32_t*)(clientNonce+i), m_localSecretKey );

		for ( i = 0; i < 96; i+= 8 )
			RunCipher( (uint32_t*)(serverNonce+i), m_localSecretKey );

#if 0
		debug_log( LOG_PRIORITY_LOW, "RRL::UL CLIENT NONCE[%x%x%x%x%x%x%x%x)",
			((uint32_t*)clientNonce)[4], ((uint32_t*)clientNonce)[5], ((uint32_t*)clientNonce)[6], ((uint32_t*)clientNonce)[7],
		       	((uint32_t*)clientNonce)[4], ((uint32_t*)clientNonce)[5],
	 		((uint32_t*)clientNonce)[6], ((uint32_t*)clientNonce)[7] );		
#endif

		for ( i = 0; i < 96; i+= 4 )
			*((uint32_t*)(sharedSecretBytes+i)) = *((uint32_t*)(clientNonce+i)) ^ *((uint32_t*)(serverNonce+i));
		
		debug_log( LOG_PRIORITY_LOW, "RRL::UL SHARED SECRET[%x%x%x%x)",
			((uint32_t*)sharedSecretBytes)[0], ((uint32_t*)sharedSecretBytes)[1], ((uint32_t*)sharedSecretBytes)[2], ((uint32_t*)sharedSecretBytes)[3]
				);

		// Calculate MD5 of shared secret
		CMD5 oMD5;

		oMD5.InitDigest();

		oMD5.UpdateDigest( sharedSecretBytes, 48 );

		oMD5.GetDigest( rllSecurityParameters, 16 );

		oMD5.InitDigest();
	
		oMD5.UpdateDigest( sharedSecretBytes+48, 48 );

		oMD5.GetDigest( rllSecurityParameters+16, 16 );

		debug_log( LOG_PRIORITY_LOW, "RRL::UL Negotiated security parameters MASTER KEY[%x%x%x%x] UL IV(%x%x) DL IV(%x%x)",
			((uint32_t*)rllSecurityParameters)[0], ((uint32_t*)rllSecurityParameters)[1], ((uint32_t*)rllSecurityParameters)[2], ((uint32_t*)rllSecurityParameters)[3],
		       	((uint32_t*)rllSecurityParameters)[4], ((uint32_t*)rllSecurityParameters)[5],
	 		((uint32_t*)rllSecurityParameters)[6], ((uint32_t*)rllSecurityParameters)[7] );		



		// Lastly send down security parameters
		// Send response
		SendSecurityParameters( rllSecurityParameters, 32 );
	}	
}

void CRRL::HandleDedicatedMessage( uint8_t *pData, uint32_t dataLen )
{	
	if ( dataLen < 1 )
		return; // Ignore

	switch( pData[0] )
	{
	case HEARTBEAT_REQUEST_ID:
		HandleHeartBeatRequest( pData+1, dataLen-1 );
		break;

	case INTEGRITY_REQUEST_ID:
		HandleIntegrityRequest( pData+1, dataLen-1 );
		break;

	case ACCESSPOINT_SETUP_REQUEST_ID:
		HandleAccessPointSetupRequest( pData+1, dataLen-1 );
		break;

	case ACCESSPOINT_DESTROY_REQUEST_ID:
		HandleAccessPointDestroyRequest( pData+1, dataLen-1 );
		break;

	case ACCESSPOINT_INFO_REQUEST_ID:
		HandleAccessPointInfoRequest( pData+1, dataLen-1 );
		break;
	}
}

void CRRL::HandleFastMessage( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen < 6 )
	{
		uint8_t responseBuffer[4];
		responseBuffer[0] = FAST_ACCESS_FAILURE_ID;
		responseBuffer[1] = FAST_BAD_COMMAND;

		SendFastResponse( responseBuffer, 2 );
		return;
	}

	uint32_t apID = READ_U32_LE( pData+1 ); // OLD: *((uint32_t*)(pData+1));

	// Lookup AP ID
	CAccessPoint *pAP = GetAPForID( apID );

	if ( pAP == NULL )
	{
		// Failure, ignore
		// Invalid -- send failure
		uint8_t responseBuffer[4];
		responseBuffer[0] = FAST_ACCESS_FAILURE_ID;
		responseBuffer[1] = FAST_AP_NOT_FOUND;

		SendFastResponse( responseBuffer, 2 );
		return;
	}

	if ( pData[0] == FAST_WRITE_COMMAND_ID )
	{
		uint8_t attemptWriteCount = pData[5];

		if ( attemptWriteCount > dataLen-6 )
		{
			uint8_t responseBuffer[4];
			responseBuffer[0] = FAST_ACCESS_FAILURE_ID;
			responseBuffer[1] = FAST_BAD_COMMAND;

			SendFastResponse( responseBuffer, 2 );
			return;
		}

		// Send fast message
		uint32_t writeCount = pAP->GetData().WriteData( pData+6, attemptWriteCount );	

		uint8_t responseBuffer[7];

		responseBuffer[0] = FAST_WRITE_COMMAND_ID;

		WRITE_U32_LE( responseBuffer+1, apID ); // OLD: *((uint32_t*)(responseBuffer+1)) = apID;

		responseBuffer[5] = (uint8_t)writeCount;

		SendFastResponse( responseBuffer, 6 );
	}
	else if ( pData[0] == FAST_READ_COMMAND_ID )
	{
		uint8_t responseBuffer[1024+5];
		uint8_t *readBuffer = responseBuffer+6;
		
		uint8_t readLength = pData[5];

		// Receive fast message
		uint32_t readCount = pAP->GetData().ReadData( readBuffer, readLength );

		// Send back response message
		responseBuffer[0] = FAST_READ_COMMAND_ID;

		WRITE_U32_LE( responseBuffer+1, apID ); // OLD: *((uint32_t *)(responseBuffer+1)) = apID;

		responseBuffer[5] = (uint8_t)readCount;

		SendFastResponse( responseBuffer, readCount+6 );	
	}
	else
	{
		// Unknown command --- FAIL
		uint8_t responseBuffer[4];
		responseBuffer[0] = FAST_ACCESS_FAILURE_ID;
		responseBuffer[1] = FAST_BAD_COMMAND;

		SendFastResponse( responseBuffer, 2 );
		return;
	}	
}

void CRRL::SendBroadcastResponse( uint8_t *pData, uint32_t dataLen )
{
	uint8_t *pNewMessage = new uint8_t[dataLen+1];

	pNewMessage[0] = CRLL::RLL_CHANNEL_BROADCAST;

	memcpy( pNewMessage+1, pData, dataLen );

	m_pRRLToRLLQueue->SendMessage( new CMessage( pNewMessage, dataLen+1, &FreeMessageWrapper ) );

	return;
}

void CRRL::SendDedicatedResponse( uint8_t *pData, uint32_t dataLen )
{
	uint8_t *pNewMessage = new uint8_t[dataLen+1];

	pNewMessage[0] = CRLL::RLL_CHANNEL_DEDICATED;

	memcpy( pNewMessage+1, pData, dataLen );

	m_pRRLToRLLQueue->SendMessage( new CMessage( pNewMessage, dataLen+1, &FreeMessageWrapper ) );

	return;
}

void CRRL::SendFastResponse( uint8_t *pData, uint32_t dataLen )
{
	uint8_t *pNewMessage = new uint8_t[dataLen+1];

	pNewMessage[0] = CRLL::RLL_CHANNEL_FAST;

	memcpy( pNewMessage+1, pData, dataLen );

	m_pRRLToRLLQueue->SendMessage( new CMessage( pNewMessage, dataLen+1, &FreeMessageWrapper ) );

	return;
}

void CRRL::SendSecurityParameters( uint8_t *pData, uint32_t dataLen )
{
	uint8_t *pNewMessage = new uint8_t[dataLen+1];

	pNewMessage[0] = CRLL::RLL_SECURITY_PARAMETERS;

	memcpy( pNewMessage+1, pData, dataLen );

	m_pRRLToRLLQueue->SendMessage( new CMessage( pNewMessage, dataLen+1, &FreeMessageWrapper ) );

	return;
}

void CRRL::HandleHeartBeatRequest( uint8_t *pData, uint32_t dataLen )
{
	uint16_t requestLength;

	if ( dataLen < 2 )
		return;

	requestLength = READ_U16_LE( pData ); // OLD: *((uint16_t*)pData);
	uint8_t *pRequestData = pData+2;

#if PATCH_HEARTBEAT_BUG
	if ( requestLength > (dataLen-2) )
		return;
#endif

	uint8_t *pRequestResponse = new uint8_t[requestLength+3];

	pRequestResponse[0] = CRRL::HEARTBEAT_RESPONSE_ID;

	WRITE_U16_LE( pRequestResponse+1, requestLength ); // OLD: *((uint16_t*)(pRequestResponse+1)) = requestLength;

	memcpy( pRequestResponse+3, pRequestData, requestLength );	
	
	SendDedicatedResponse( pRequestResponse, requestLength+3 );

	delete pRequestResponse;
	return;
}

void CRRL::HandleIntegrityRequest( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen < 8 )
	{
		// Invalid -- send failure
		uint8_t responseBuffer[4];
		responseBuffer[0] = INTEGRITY_RESPONSE_ID;
		responseBuffer[1] = INTEGRITY_FAILURE_ID;

		SendDedicatedResponse( responseBuffer, 2 );
		return;
	}

	// Allow them to perform an integrity check on an AP's data
	uint16_t integrityCheckLength = READ_U16_LE( pData ); // OLD: *((uint16_t*)pData);	
	uint32_t apID = READ_U32_LE( pData+2 ); // OLD: *((uint32_t*)(pData+2));
	uint16_t integrityCheckStart = READ_U16_LE( pData+6 ); // OLD: *((uint16_t*)(pData+6));

	// Find AP
	CAccessPoint *pAP = GetAPForID( apID );

	if ( pAP == NULL )
	{
		// Invalid -- send failure
		uint8_t responseBuffer[8];
		responseBuffer[0] = INTEGRITY_RESPONSE_ID;
		responseBuffer[1] = INTEGRITY_AP_NOT_FOUND_ID;

		WRITE_U32_LE( responseBuffer+2, apID ); // OLD: *((uint32_t*)(responseBuffer+2)) = apID;

		SendDedicatedResponse( responseBuffer, 6 );

		return;
	}

	if ( integrityCheckLength > pAP->GetData().GetTotalDataLength() )
	{
		// Invalid -- send failure
		uint8_t responseBuffer[8];
		responseBuffer[0] = INTEGRITY_RESPONSE_ID;
		responseBuffer[1] = INTEGRITY_INVALID_LENGTH_ID;

		WRITE_U32_LE( responseBuffer+2, apID ); // OLD: *((uint32_t*)(responseBuffer+2)) = apID;

		SendDedicatedResponse( responseBuffer, 6 );

		return;
	}

	if ( integrityCheckStart > pAP->GetData().GetTotalDataLength() )
	{
		// Invalid -- send failure
		uint8_t responseBuffer[8];
		responseBuffer[0] = INTEGRITY_RESPONSE_ID;
		responseBuffer[1] = INTEGRITY_INVALID_START_ID;

		WRITE_U32_LE( responseBuffer+2, apID ); // OLD: *((uint32_t*)(responseBuffer+2)) = apID;

		SendDedicatedResponse( responseBuffer, 6 );
		
		return;
	}
	
	if ( (integrityCheckStart + integrityCheckLength) > pAP->GetData().GetTotalDataLength() )
	{
		// Invalid -- send failure
		uint8_t responseBuffer[8];
		responseBuffer[0] = INTEGRITY_RESPONSE_ID;
		responseBuffer[1] = INTEGRITY_INVALID_START_ID;

		WRITE_U32_LE( responseBuffer+2, apID ); // OLD: *((uint32_t*)(responseBuffer+2)) = apID;

		SendDedicatedResponse( responseBuffer, 6 );

#if PATCH_INTEGRITY_CHECK_LEAK
		return;
#endif
	}

	// Now perform integrity check
	uint32_t integrityCheckValue = pAP->GetData().GetIntegrityData( integrityCheckStart, integrityCheckLength );	

	// Respond with integrity check value
	uint8_t responseBuffer[10];
	responseBuffer[0] = INTEGRITY_RESPONSE_ID;
	responseBuffer[1] = INTEGRITY_SUCCESS_ID;

	WRITE_U32_LE( responseBuffer+2, apID ); // OLD: *((uint32_t*)(responseBuffer+2)) = apID;
	WRITE_U32_LE( responseBuffer+6, integrityCheckValue ); // OLD: *((uint32_t*)(responseBuffer+6)) = integrityCheckValue;

	SendDedicatedResponse( responseBuffer, 10 );
}

void CRRL::HandleAccessPointSetupRequest( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen < 4 )
	{
		debug_log( LOG_PRIORITY_LOW, "RRL:: AP SETUP REQUEST INVALID LENGTH, length=%d", dataLen );

		// Invalid -- send failure
		uint8_t responseBuffer[4];
		responseBuffer[0] = ACCESSPOINT_SETUP_RESPONSE_ID;
		responseBuffer[1] = ACCESSPOINT_SETUP_FAILURE;

		SendDedicatedResponse( responseBuffer, 2 );
		return;
	}

	// Get Length/Name/Type/Speed of access point
	uint8_t accessPointType = pData[0];
	uint8_t accessPointSpeed = pData[1];
	uint8_t accessPointLength = pData[2];

#ifdef PATCH_APNAME_OVERWRITE
	if ( dataLen < (accessPointLength+3) || accessPointLength >= ACCESSPOINT_NAME_MAXLEN )
#else
	if ( dataLen < (accessPointLength+3) )
#endif	
	{
		debug_log( LOG_PRIORITY_LOW, "RRL:: AP SETUP REQUEST INVALID LENGTH, length=%d", dataLen );

		// Invalid -- send failure
		uint8_t responseBuffer[4];
		responseBuffer[0] = ACCESSPOINT_SETUP_RESPONSE_ID;
		responseBuffer[1] = ACCESSPOINT_SETUP_FAILURE;

		SendDedicatedResponse( responseBuffer, 2 );
		return;
	}

	// Check for existing AP
	uint32_t foundAPID;
	uint32_t newAPID;
	uint8_t tryCount = 0;

	if ( GetAPIDForName( pData+3, accessPointLength, foundAPID ) )
	{
		debug_log( LOG_PRIORITY_LOW, "RRL:: AP SETUP REQUEST AP NAME ALREADY EXISTS" );

		// AP already exists
		// Invalid -- send failure
		uint8_t responseBuffer[6];
		responseBuffer[0] = ACCESSPOINT_SETUP_RESPONSE_ID;
		responseBuffer[1] = ACCESSPOINT_SETUP_ALREADY_EXISTS;

		WRITE_U32_LE( responseBuffer+2, foundAPID ); // OLD: *((uint32_t*)(responseBuffer+2)) = foundAPID;

		SendDedicatedResponse( responseBuffer, 6 );
		return;
	}

	if ( GetAccessPointCount() >= MAX_ACCESS_POINT_COUNT )
	{
		debug_log( LOG_PRIORITY_LOW, "RRL:: AP SETUP REQUEST MAX ACCESS POINTS REACHED" );

		// AP count exceeded
		// Invalid -- send failure
		uint8_t responseBuffer[6];
		responseBuffer[0] = ACCESSPOINT_SETUP_RESPONSE_ID;
		responseBuffer[1] = ACCESSPOINT_SETUP_TOO_MANY;

		WRITE_U32_LE( responseBuffer+2, MAX_ACCESS_POINT_COUNT ); // OLD: *((uint32_t*)(responseBuffer+2)) = foundAPID;

		SendDedicatedResponse( responseBuffer, 6 );
		return;
	}

	// No AP FOUND -- make a new one
	bool bFound = true;
	for ( tryCount = 0; tryCount < 100; tryCount++ )
	{
		// TRY new AP ID
		newAPID = (uint32_t)prng();

		if ( !GetAPForID( newAPID ) )
		{
			bFound = false;
			break;	// No AP found, exit
		}
	}

	if ( bFound )
	{
		// Invalid -- send failure
		uint8_t responseBuffer[4];
		responseBuffer[0] = ACCESSPOINT_SETUP_RESPONSE_ID;
		responseBuffer[1] = ACCESSPOINT_SETUP_FAILURE;

		SendDedicatedResponse( responseBuffer, 2 );
		return;
	}

	// CREATE
	CAccessPoint *pNewAP = new CAccessPoint( pData+3, accessPointLength, newAPID, accessPointType, accessPointSpeed, &RecordAPDataRead, &RecordAPDataWrite );

	if ( !pNewAP )
	{
		// Invalid -- send failure
		uint8_t responseBuffer[4];
		responseBuffer[0] = ACCESSPOINT_SETUP_RESPONSE_ID;
		responseBuffer[1] = ACCESSPOINT_SETUP_FAILURE;

		SendDedicatedResponse( responseBuffer, 2 );
		return;
	}

	m_apList.AddLast( pNewAP ); 

	// INFORM them of success
	uint8_t responseBuffer[6];
	responseBuffer[0] = ACCESSPOINT_SETUP_RESPONSE_ID;
	responseBuffer[1] = ACCESSPOINT_SETUP_SUCCESS;

	WRITE_U32_LE( responseBuffer+2, newAPID ); // OLD: *((uint32_t*)(responseBuffer+2)) = newAPID;

	SendDedicatedResponse( responseBuffer, 6 );	
		
	debug_log( LOG_PRIORITY_LOW, "RRL:: AP SETUP REQUEST CREATED NEW AP[%u]", newAPID );
}

void CRRL::HandleAccessPointDestroyRequest( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen < 4 )
	{
		// Invalid -- send failure
		uint8_t responseBuffer[4];
		responseBuffer[0] = ACCESSPOINT_DESTROY_RESPONSE_ID;
		responseBuffer[1] = ACCESSPOINT_DESTROY_FAILURE;

		SendDedicatedResponse( responseBuffer, 2 );
		return;
	}

	uint32_t apID = READ_U32_LE( pData ); // OLD: *((uint32_t*)pData);

	CAccessPoint *pAP = GetAPForID( apID );

	if ( pAP == NULL )
	{
		// Invalid -- send failure
		uint8_t responseBuffer[4];
		responseBuffer[0] = ACCESSPOINT_DESTROY_RESPONSE_ID;
		responseBuffer[1] = ACCESSPOINT_DESTROY_DOES_NOT_EXIST;

		SendDedicatedResponse( responseBuffer, 2 );
		return;
	}

	// Destroy the AP
	delete pAP;
	
	// Invalid -- send failure
	uint8_t responseBuffer[4];
	responseBuffer[0] = ACCESSPOINT_DESTROY_RESPONSE_ID;
	responseBuffer[1] = ACCESSPOINT_DESTROY_SUCCESS;

	SendDedicatedResponse( responseBuffer, 2 );
	return;
}

void CRRL::HandleAccessPointInfoRequest( uint8_t *pData, uint32_t dataLen )
{
	uint8_t responseBuffer[40];
	if ( dataLen < 4 )
	{
		// Invalid -- send failure
		responseBuffer[0] = ACCESSPOINT_INFO_RESPONSE_ID;
		responseBuffer[1] = ACCESSPOINT_INFO_FAILURE;

		SendDedicatedResponse( responseBuffer, 2 );
		return;
	}

	uint32_t apID = READ_U32_LE( pData ); // OLD: *((uint32_t*)pData);

	CAccessPoint *pAP = GetAPForID( apID );

	if ( pAP == NULL )
	{
		// Invalid -- send failure
		responseBuffer[0] = ACCESSPOINT_INFO_RESPONSE_ID;
		responseBuffer[1] = ACCESSPOINT_INFO_DOES_NOT_EXIST;

		SendDedicatedResponse( responseBuffer, 2 );
		return;
	}

	// Get info
	uint8_t *pResponseBuffer = new uint8_t[ACCESSPOINT_NAME_MAXLEN+128+3];

	uint32_t outputChars = pAP->GetAPInfoString( pResponseBuffer+3, ACCESSPOINT_NAME_MAXLEN+128 );


	// Send response
	pResponseBuffer[0] = ACCESSPOINT_INFO_RESPONSE_ID;
	pResponseBuffer[1] = ACCESSPOINT_INFO_SUCCESS;
	pResponseBuffer[2] = (uint8_t)outputChars;

	SendDedicatedResponse( pResponseBuffer, outputChars+3 );

	delete [] pResponseBuffer;
	return; 
}

bool CRRL::GetAPIDForName( uint8_t *pAPName, uint8_t nameLength, uint32_t &foundAPID )
{
	CAccessPoint *pCur;
	
	for ( pCur = (CAccessPoint *)m_apList.GetFirst(); pCur; pCur = (CAccessPoint *)m_apList.GetNext( pCur ) )
	{
		if ( pCur->GetAPNameLength() == nameLength )
		{
			if ( memcmp( pCur->GetAPName(), pAPName, nameLength ) == 0 )
			{
				foundAPID = pCur->GetAPID();
				return (true);
			}
		}
	}

	foundAPID = 0;
	return (false);
}

CAccessPoint *CRRL::GetAPForID( uint32_t apID )
{
	CAccessPoint *pCur;

	for ( pCur = (CAccessPoint *)m_apList.GetFirst(); pCur; pCur = (CAccessPoint *)m_apList.GetNext( pCur ) )
	{
		if ( pCur->GetAPID() == apID )
			return (pCur);
	}

	return (NULL);
}

uint32_t CRRL::GetAccessPointCount( void )
{
	CAccessPoint *pCur;
	uint32_t count = 0;

	for ( pCur = (CAccessPoint *)m_apList.GetFirst(); pCur; pCur = (CAccessPoint *)m_apList.GetNext( pCur ) )
		count++;

	return (count);
}

void CRRL::RunCipher( uint32_t v[2], uint32_t key[4] )
{
        uint32_t v0=v[0];
        uint32_t v1=v[1];
        uint32_t delta = 0x83E778B9;
        uint32_t sum = (delta*16);

        for ( uint32_t i = 0; i < 16; i++ )
        {
                v0 += (((v1 << 4) ^ (v1 >> 5)) + v1) ^ (sum + key[sum & 3]);
                sum += delta;
                v1 += (((v0 << 4) ^ (v0 >> 5)) + v0) ^ (sum + key[(sum>>11) & 3]);
        }

        v[0] = v0;
        v[1] = v1;
}
