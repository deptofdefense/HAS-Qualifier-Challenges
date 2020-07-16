#include "common.h"

CRLL::CRLL( CMessageQueue *pMACToRLLQueue, CMessageQueue *pRLLToRRLQueue, CMessageQueue *pRLLToMACQueue, CMessageQueue *pRRLToRLLQueue, CMessageQueue *pInterMessageQueue )
	: m_pMACToRLLQueue( pMACToRLLQueue ), m_pRLLToRRLQueue( pRLLToRRLQueue ), m_pRLLToMACQueue( pRLLToMACQueue ), m_pRRLToRLLQueue( pRRLToRLLQueue ), m_pInterMessageQueue( pInterMessageQueue ), m_pduSequenceNumberLastRX( 0 ), m_pduSequenceNumberLastTX( 0 )
{
	m_lastMACPDUFrameNumber = 0;
	m_currentFrameNumber = 0;

	m_heartBeatCounter = 0;
}

CRLL::~CRLL( )
{

}

void CRLL::InitTimeFrameCounter( uint64_t startValue )
{
	m_timeFrameCounter.SetStartTime( startValue );
}

void CRLL::Process( void )
{
	bool bDone = false;

	debug_log( LOG_PRIORITY_LOW, "RLL::Radio Link Layer Process (UL/DL processing)\n" );

	if ( 1 )
	{
		// Update time frame number
		UpdateTimeFrameNumber();
	
		if ( m_pMACToRLLQueue->HasMessages() )
		{
			debug_log( LOG_PRIORITY_LOW, "RLL::UL MAC PDU\n" );

			CMessage *pNewMessage = m_pMACToRLLQueue->RecvMessage();

			HandleMACMessage( pNewMessage->GetData(), pNewMessage->GetLength() );

			delete pNewMessage;
		}

		if ( m_pRRLToRLLQueue->HasMessages() )
		{
			debug_log( LOG_PRIORITY_LOW, "RLL::DL RRL PDU\n" );
			
			CMessage *pNewMessage = m_pRRLToRLLQueue->RecvMessage();

			HandleRRLMessage( pNewMessage->GetData(), pNewMessage->GetLength() );

			delete pNewMessage;
		}

		if ( m_pInterMessageQueue->HasMessages() )
		{
			debug_log( LOG_PRIORITY_LOW, "RLL:: INTERNAL MESSAGE\n" );

			CMessage *pNewMessage = m_pInterMessageQueue->RecvMessage();

			if ( HandleInternalMessage( pNewMessage->GetData(), pNewMessage->GetLength() ) )
				bDone = true;

			delete pNewMessage;
		}

		m_heartBeatCounter++;
		if ( m_heartBeatCounter % 240 == 0 )
		{
			m_heartBeatCounter = 0;
			SendMACHeartBeat();
		}
		

		// Wait thread
#if X86_TARGET
		std::this_thread::sleep_for( std::chrono::milliseconds(25) );
#else
		// TODO: MIPS Target
#endif


#if ENABLE_MAC_RLL_TIMEOUT	
		if ( abs( m_timeFrameCounter.GetFrameNumber() - m_lastMACPDUFrameNumber ) > CMac::MAX_FRAME_NUMBER_TIMEOUT )
		{
			debug_log( LOG_PRIORITY_LOW, "RLL timeout!\n" );
		}
#endif

	} //  while ( !bDone );
}

bool CRLL::CipherReset( uint32_t newState[2] )
{
	m_ulCipherState[0] = newState[0];
	m_ulCipherState[1] = newState[1];

	m_dlCipherState[0] = newState[0];
	m_ulCipherState[1] = newState[1];
}

bool CRLL::EncipherPDU( uint8_t *pStream, uint32_t streamLength )
{
	if ( !m_bCipherEnabled )
		return (false);

	for ( uint32_t pos = 0; pos < streamLength; pos++ )
	{
		if ( pos % 8 == 0 )
			RunCipher( m_dlCipherState, m_cipherKey );

		pStream[pos] ^= ((uint8_t*)m_dlCipherState)[pos%8];
	}

	return (true);
}

bool CRLL::DecipherPDU( uint8_t *pStream, uint32_t streamLength )
{
	if ( !m_bCipherEnabled )
		return (false);

	for ( uint32_t pos = 0; pos < streamLength; pos++ )
	{
		if ( pos % 8 == 0 )
			RunCipher( m_ulCipherState, m_cipherKey );

		pStream[pos] ^= ((uint8_t*)m_ulCipherState)[pos%8];
	}

	return (true);
}

void CRLL::RunCipher( uint32_t v[2], uint32_t key[4] )
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

void CRLL::HandleMACMessage( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen < 5 )
		return;

	if ( pData[0] == CRLL::MAC_BLOCK_SIZE_UPDATE_IND )
	{
		if ( dataLen < 6 )
			return;

		uint32_t pduFrameNumber = READ_U32_LE( pData+1 ); // OLD: *((uint32_t *)(pData+1));

		if ( pduFrameNumber > m_lastMACPDUFrameNumber )
			m_lastMACPDUFrameNumber = pduFrameNumber;
	
		// Save MAC data block size	
		m_macDataBlockSize = pData[5];

		// Reset PDU assembly
		ResetRXPDUSequenceAndAssembly( m_macDataBlockSize );

		return;
	}
	else if ( pData[0] == CRLL::MAC_HEARTBEAT_IND )
	{
		if ( dataLen < 5 )
			return;

		uint32_t pduFrameNumber = READ_U32_LE( pData+1 ); // OLD: *((uint32_t *)(pData+1));

		if ( pduFrameNumber > m_lastMACPDUFrameNumber )
			m_lastMACPDUFrameNumber = pduFrameNumber;
	
		return;
	}
	else if ( pData[0] != CRLL::MAC_DATA_IND )
		return;

	if ( dataLen < RLL_PDU_LENGTH )
		return;

	uint32_t pduFrameNumber = READ_U32_LE( pData+1 ); // OLD: *((uint32_t *)(pData+1));

	if ( pduFrameNumber > m_lastMACPDUFrameNumber )
		m_lastMACPDUFrameNumber = pduFrameNumber;


	switch( pData[5] )
	{
	case RLL_CHANNEL_BROADCAST:	
		// Non segmented PDU
		HandleBroadcastPDU( pData[5], pData+6, dataLen-6 );
		break;

	case RLL_CHANNEL_DEDICATED:
		// Should be encrypted and can possibly be segmented
		HandleDedicatedPDU( pData[5], pData+6, dataLen-6 );	
		break;

	case RLL_CHANNEL_FAST:
		// Encrypted and not segmented
		HandleFastPDU( pData[5], pData+6, dataLen-6 );
		break;

	default:
		// Ignore
		break;
	}
}

void CRLL::HandleRRLMessage( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen < 2 )
		return;	 // Ignore

	switch( pData[0] )
	{
	case RLL_CHANNEL_BROADCAST:
		ReceiveRRLBroadcastMessage( pData+1, dataLen-1 );	
		break;

	case RLL_CHANNEL_DEDICATED:
		ReceiveRRLDedicatedMessage( pData+1, dataLen-1 );
		break;

	case RLL_CHANNEL_FAST:
		ReceiveRRLFastMessage( pData+1, dataLen-1 );	
		break;

	case RLL_SECURITY_PARAMETERS:
		UpdateSecurityParametersMessage( pData+1, dataLen-1 );	
		break;

	default:
		// Ignore
		break;

	}
}

bool CRLL::HandleInternalMessage( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen < 2 )
		return false;	// Ignore

	switch( pData[0] )
	{
	case RLL_MESSAGE_UPDATE_SECURITY:
		// Update security parameters

		break;

	case RLL_MESSAGE_UPDATE_INTEGRITY:
		// Update integrity parameters

		break;

	case RLL_MESSAGE_SHUTDOWN:
		// Shutdown thread
		return (true);	
		break;

	default:
		// Ignore
		return (false);
		break;
	}
}

void CRLL::HandleBroadcastPDU( uint8_t pduChannel, uint8_t *pduData, uint32_t dataLen )
{
	if ( dataLen != (m_macDataBlockSize-1) )
	{
		debug_log( LOG_PRIORITY_MEDIUM, "RLL::UL BROADCAST MESSAGE MAC Grant Size[%d] != PDU length=%d", m_macDataBlockSize, dataLen );
		return;
	}

	// Just pass it on up! -- no encryption/decryption
	uint8_t *pNewData = new uint8_t[dataLen+1];

	// Pass it directly
	pNewData[0] = pduChannel;
	memcpy( pNewData+1, pduData, dataLen );

	CMessage *pNewMessage = new CMessage( pNewData, dataLen+1, &FreeMessageWrapper );

	if ( !m_pRLLToRRLQueue->SendMessage( pNewMessage ) )
		delete pNewMessage;
}

void CRLL::HandleDedicatedPDU( uint8_t pduChannel, uint8_t *pduData, uint32_t dataLen )
{
	// Check data length
	if ( dataLen != (m_macDataBlockSize-1) )
	{
		debug_log( LOG_PRIORITY_MEDIUM, "RLL::UL DEDICATED_MESSAGE MAC Grant Size[%d] != PDU length=%d", m_macDataBlockSize, dataLen );
		return;
	}

	// Check for cipher
	if ( !m_bCipherEnabled )
	{
		debug_log( LOG_PRIORITY_LOW, "RLL::UL DEDICATED_MESSAGE Security not enabled, PDU discarded.\n" );
		return;
	}

	// Decipher PDU
	if ( !DecipherPDU( pduData, dataLen ) )
	{
		debug_log( LOG_PRIORITY_LOW, "RLL::UL DEDICATED_MESSAGE Decryption failed, PDU discarded\n" );
		return;
	}

	// Next perform resegmentation
	uint16_t pduHeader = READ_U16_LE( pduData );

	uint8_t lf_bit = (pduHeader >> 15) & 0x1;
	uint16_t seqNumber = (pduHeader >> 4) & 0x7FF;
	uint8_t fragmentNumber = pduHeader & 0xF;

	// Check if sequence number is inside sequence number window
	if ( abs( seqNumber - m_pduSequenceNumberLastRX ) > MAX_PDU_SEQUENCE_WINDOW_DELTA &&
	     abs( ((uint32_t)seqNumber+2048) - m_pduSequenceNumberLastRX ) > MAX_PDU_SEQUENCE_WINDOW_DELTA )
	{
		debug_log( LOG_PRIORITY_LOW, "RLL::UL DEDICATED_MESSAGE SN SEQUENCE WINDOW[%d] out of range PDU SN[%d], PDU discarded.\n", m_pduSequenceNumberLastRX, seqNumber );
		return;
	}

	// Perform reassembly
	// Find an existing fragment buffer
	CFragmentBuffer *pFragmentBuffer = NULL;

	bool bFound = false;
	for ( pFragmentBuffer = (CFragmentBuffer *)m_rxPDUFragments.GetFirst(); pFragmentBuffer; pFragmentBuffer = (CFragmentBuffer *)m_rxPDUFragments.GetNext( pFragmentBuffer ) )
	{
		if ( pFragmentBuffer->GetSequenceNumber() == seqNumber )
		{
			bFound = true;
			break;
		}
	}

	if ( bFound )
	{
		pFragmentBuffer->AddFragment( lf_bit, fragmentNumber, pduData+2, dataLen-2 );
	}
	else
	{
		pFragmentBuffer = new CFragmentBuffer( seqNumber, &m_oPDUPool );

		pFragmentBuffer->AddFragment( lf_bit, fragmentNumber, pduData+2, dataLen-2 );
	
		m_rxPDUFragments.AddLast( pFragmentBuffer );
	}

	// check for all fragments!!
	if ( pFragmentBuffer->HasAllFragments() )
	{
		// BUG:: This allocation may be insufficient to hold an entire set of assembled PDU's
		uint8_t tempFragmentBuffer[CFragmentBuffer::MAX_PACKET_FRAGMENTS * 80];
		uint16_t outLength;

		if ( pFragmentBuffer->AssemblePacket( tempFragmentBuffer, CFragmentBuffer::MAX_PACKET_FRAGMENTS * 80, outLength ) )
		{
			// Send it to the next layer!
			uint8_t *pNewData = new uint8_t[outLength+1];

			// Pass it directly
			pNewData[0] = pduChannel;
			memcpy( pNewData+1, tempFragmentBuffer, outLength );

			CMessage *pNewMessage = new CMessage( pNewData, outLength+1, &FreeMessageWrapper );

			if ( !m_pRLLToRRLQueue->SendMessage( pNewMessage ) )
				delete pNewMessage;
		}	
	}
	
	// Slide window
	if ( seqNumber > m_pduSequenceNumberLastRX || ((m_pduSequenceNumberLastRX >= (0x800 - MAX_PDU_SEQUENCE_WINDOW_DELTA)) && (seqNumber <= MAX_PDU_SEQUENCE_WINDOW_DELTA)) )
	{
		m_pduSequenceNumberLastRX = seqNumber;

		// Slider window and delete any fragments out of range
		CFragmentBuffer *pNext = NULL;
		for ( pFragmentBuffer = (CFragmentBuffer *)m_rxPDUFragments.GetFirst(); pFragmentBuffer; pFragmentBuffer = pNext )
		{
			pNext = (CFragmentBuffer *)m_rxPDUFragments.GetNext( pFragmentBuffer );

			if ( abs( pFragmentBuffer->GetSequenceNumber() - m_pduSequenceNumberLastRX ) > MAX_PDU_SEQUENCE_WINDOW_DELTA &&
	     		abs( ((uint32_t)pFragmentBuffer->GetSequenceNumber()+2048) - m_pduSequenceNumberLastRX ) > MAX_PDU_SEQUENCE_WINDOW_DELTA )
				delete pFragmentBuffer;
		}
	}

}

void CRLL::HandleFastPDU( uint8_t pduChannel, uint8_t *pduData, uint32_t dataLen )
{
	if ( dataLen != (m_macDataBlockSize-1) )
	{
		debug_log( LOG_PRIORITY_MEDIUM, "RLL::UL FAST_MESSAGE MAC Grant Size[%d] != PDU length=%d", m_macDataBlockSize, dataLen );
		return;
	}

	// Check for cipher
	if ( !m_bCipherEnabled )
	{
		debug_log( LOG_PRIORITY_LOW, "RLL::UL FAST_MESSAGE Security not enabled, PDU discarded.\n" );
		return;
	}

	// Decipher PDU
	if ( !DecipherPDU( pduData, dataLen ) )
	{
		debug_log( LOG_PRIORITY_LOW, "RLL::UL FAST_MESSAGE Decryption failed, PDU discarded\n" );
		return;
	}

	// Send it to the next layer!
	uint8_t *pNewData = new uint8_t[dataLen+1];

	// Pass it directly
	pNewData[0] = pduChannel;
	memcpy( pNewData+1, pduData, dataLen );

	CMessage *pNewMessage = new CMessage( pNewData, dataLen+1, &FreeMessageWrapper );

	if ( !m_pRLLToRRLQueue->SendMessage( pNewMessage ) )
		delete pNewMessage;
}

void CRLL::ReceiveRRLBroadcastMessage( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen == 0 )
		return;

	if ( dataLen > (m_macDataBlockSize-1) )
		return;

	// Send it to the next layer!
	uint8_t *pNewData = new uint8_t[m_macDataBlockSize+5];
	memset( pNewData, 0, m_macDataBlockSize );

	// Pass it directly
	pNewData[0] = CMac::RLL_DATA_IND;
	// OLD: *((uint32_t*)(pNewData+1)) = m_currentFrameNumber;
	WRITE_U32_LE( pNewData+1, m_currentFrameNumber );

	pNewData[5] = RLL_CHANNEL_BROADCAST;

	memcpy( pNewData+6, pData, dataLen );

	CMessage *pNewMessage = new CMessage( pNewData, m_macDataBlockSize+5, &FreeMessageWrapper );

	if ( !m_pRLLToMACQueue->SendMessage( pNewMessage ) )
		delete pNewMessage;

	return;
}

void CRLL::ReceiveRRLDedicatedMessage( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen == 0 )
		return;

	if ( !m_bCipherEnabled )
	{
		debug_log( LOG_PRIORITY_LOW, "RLL::DL DEDICATED_MESSAGE Security not enabled, discarding PDU.\n" );
		return;
	}

	uint32_t dataPos = 0;

	uint16_t seqNumber = m_pduSequenceNumberLastTX;
	// Update sequence number	
	m_pduSequenceNumberLastTX++;

	// Calculate number of fragments
	uint32_t fragmentCount = 0;	

	if ( (dataLen / (m_macDataBlockSize-3)) >= 16 ) // -2 to account for sequence number and fragment header
		fragmentCount = 16;	// Cut it short!
	else
	{
		fragmentCount = (dataLen / (m_macDataBlockSize-3));
		
		if ( dataLen % (m_macDataBlockSize-3) )
			fragmentCount++;	
	}

	// Iterate over each fragment
	for ( uint8_t fragmentNumber = 0; fragmentNumber < fragmentCount; fragmentNumber++ )
	{
		uint32_t dataLenForFragment = dataLen - dataPos;

		if ( dataLenForFragment > (m_macDataBlockSize-3) )
			dataLenForFragment = (m_macDataBlockSize-3);

		// Generate PDU data for segment	
		uint8_t *pNewData = new uint8_t[m_macDataBlockSize+5];

		pNewData[0] = CMac::RLL_DATA_IND;
		// OLD: *((uint32_t*)(pNewData+1)) = m_currentFrameNumber;
		WRITE_U32_LE( pNewData+1, m_currentFrameNumber );


		pNewData[5] = RLL_CHANNEL_DEDICATED;

		// Write out fragment sequence number
		uint8_t lf_bit = 0;

		// If this is the last fragment set the lf bit (last fragment bit)
		if ( fragmentNumber+1 == fragmentCount )
			lf_bit = 1;

		// OLD: *((uint16_t*)(pNewData+6)) = (lf_bit << 15) | ((seqNumber & 0x7FF) << 4) | (fragmentNumber & 0xF);
		WRITE_U16_LE( pNewData+6, (lf_bit << 15) | ((seqNumber & 0x7FF) << 4) | (fragmentNumber & 0xF) );

		// Copy in fragment data
		memcpy( pNewData+8, pData+dataPos, dataLenForFragment );

		// BUG::
		// We will leak any data after this memcpy from the heap if the last fragment's length is less than the m_macDataBlockSize -- leaking stale pointers!
		
		// Update dataPos
		dataPos += dataLenForFragment;

		// Encrypt!	
		if ( !EncipherPDU( pNewData+6, m_macDataBlockSize-1 ) )	// Encrypt PDU Header to end of message
		{
			debug_log( LOG_PRIORITY_LOW, "RLL::DL DEDICATED MESSAGE PDU Encryptioned failed, discarding.\n" );

			delete pNewData;
			return;
		}

		CMessage *pNewMessage = new CMessage( pNewData, m_macDataBlockSize+5, &FreeMessageWrapper );

		if ( !m_pRLLToMACQueue->SendMessage( pNewMessage ) )
			delete pNewMessage;
	}

}

void CRLL::ReceiveRRLFastMessage( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen == 0 )
		return;

	// For fast messages -- we can only send up to the block size -- so we restrict it!
	if ( dataLen > (m_macDataBlockSize-1) )
		dataLen = m_macDataBlockSize-1;

	if ( !m_bCipherEnabled )
	{
		debug_log( LOG_PRIORITY_LOW, "RLL::DL FAST_MESSAGE Security not enabled, discarding PDU.\n" );
		return;
	}

	// Send it to the next layer!
	uint8_t *pNewData = new uint8_t[m_macDataBlockSize+5];

	// Pass it directly
	pNewData[0] = CMac::RLL_DATA_IND;
	// OLD: *((uint32_t*)(pNewData+1)) = m_currentFrameNumber;
	WRITE_U32_LE( pNewData+1, m_currentFrameNumber );

	pNewData[5] = RLL_CHANNEL_FAST;

	memcpy( pNewData+6, pData, dataLen );

	// BUG::
	// We will leak stale memory here back to them after this memcpy if the data
	// being sent is less than m_macDataBlockSize
	
	// Encrypt PDU
	if ( !EncipherPDU( pNewData+6, m_macDataBlockSize-1 ) )
	{
		debug_log( LOG_PRIORITY_LOW, "RLL::DL FAST MESSAGE PDU Encryptioned failed, discarding.\n" );
	
		delete pNewData;
		return;
	}

	CMessage *pNewMessage = new CMessage( pNewData, m_macDataBlockSize+5, &FreeMessageWrapper );

	if ( !m_pRLLToMACQueue->SendMessage( pNewMessage ) )
		delete pNewMessage;
}

void CRLL::SendMACHeartBeat( void )
{
	// Send it to the next layer!
	uint8_t *pNewData = new uint8_t[5];

	// Pass it directly
	pNewData[0] = CMac::RLL_HEARTBEAT_IND;
	// OLD: *((uint32_t*)(pNewData+1)) = m_currentFrameNumber;
	WRITE_U32_LE( pNewData+1, m_currentFrameNumber );

	CMessage *pNewMessage = new CMessage( pNewData, 5, &FreeMessageWrapper );

	if ( !m_pRLLToMACQueue->SendMessage( pNewMessage ) )
		delete pNewMessage;
}

void CRLL::UpdateSecurityParametersMessage( uint8_t *pData, uint32_t dataLen )
{
	if ( dataLen != 32 )
		return; // Ignore

	// OK valid security parameters -- update cipher keys!
	memcpy( (uint8_t*)m_cipherKey, pData, 16 );

	// Update cipher states
	memcpy( (uint8_t*)m_ulCipherState, pData+16, 8 );
	memcpy( (uint8_t*)m_dlCipherState, pData+24, 8 );

	// Enable ciphering
	m_bCipherEnabled = true;
}

void CRLL::UpdateTimeFrameNumber( void )
{
	m_currentFrameNumber = m_timeFrameCounter.GetFrameNumber();
}

void CRLL::ResetRXPDUSequenceAndAssembly( uint16_t newPDUSize )
{
	m_pduSequenceNumberLastRX = 0;

	// Reset PDU buffers
	m_rxPDUFragments.DeleteAll();

	// Initialize PDU pool to new PDU size
	m_oPDUPool.InitPool( newPDUSize );
}
