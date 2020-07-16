#include "common.h"

CMac::CMac( CMessageQueue *pMACToRLLQueue, CMessageQueue *pRLLToMACQueue, CMessageQueue *pInterMessageQueue, CIOConnection *pConnection )
	: m_pMACToRLLQueue( pMACToRLLQueue ), m_pRLLToMACQueue( pRLLToMACQueue ), m_pInterMessageQueue( pInterMessageQueue ), m_pConnection( pConnection )
{
	m_lastRLLPDUFrameNumber = 0;
	m_currentFrameNumber = 0;

	m_rxBufferPos = 0;

	m_heartBeatCounter = 0;

	m_macBufferLength = CMac::MAC_DEFAULT_BLOCK_SIZE;

	m_bFirstRun = true;	// Process first run indicator
}

CMac::~CMac( )
{

}

void CMac::InitTimeFrameCounter( uint64_t startValue )
{
	m_timeFrameCounter.SetStartTime( startValue );
}

void CMac::Process( void )
{
	uint8_t *rxBuffer = m_rxBuffer;

	debug_log( LOG_PRIORITY_LOW, "MAC::Process\n" );

	if ( m_bFirstRun )
	{	
		SendRLLDataBlockSizeUpdate( CMac::MAC_DEFAULT_BLOCK_SIZE-3 ); // -1 for header and -2 for CRC	
		m_bFirstRun = false; // Run thread has already been run once
	}

	// RX a single transport block
	if ( 1 )
	{
		// Update time frame number
		UpdateTimeFrameNumber( );

		// This check should never happen -- add just in case		
		if ( m_macBufferLength > CMac::MAC_MAX_BLOCK_SIZE )
			m_macBufferLength = CMac::MAC_MAX_BLOCK_SIZE;

		// Check for input -- and only read it if we can process it
		if ( m_pConnection->IsInputAvailable() && m_rxBufferPos < m_macBufferLength )
		{
			// Read up to (1) MAC Grant Size
			int32_t rxRead = m_pConnection->ReadData( rxBuffer+m_rxBufferPos, m_macBufferLength-m_rxBufferPos );

			// Check for disconnect
			if ( rxRead <= 0 )
			{
				// Disconnect
				return;
			}

			m_rxBufferPos+=rxRead;

			if ( m_rxBufferPos > m_macBufferLength )
			{
				debug_log( LOG_PRIORITY_HIGH, "MAC::UL RECEIVE ERROR READING GRANT ON MAC PDU.\n" );
			
				m_rxBufferPos = 0;	
			}
		}

		if ( m_rxBufferPos >= m_macBufferLength )
		{
			debug_log( LOG_PRIORITY_HIGH, "MAC::UL RX GRANT[%d] GRANT SIZE[%d]\n", m_rxBufferPos, m_macBufferLength );
			// Reset block position
			m_rxBufferPos = 0;

		// First byte --informs channel
		if ( rxBuffer[0] == CMac::MAC_BLOCK_DATA_IND )
		{
			// Do CRC
			uint16_t crcValue = READ_U16_LE( rxBuffer+1 ); // OLD: *(uint16_t*)(rxBuffer+2);

			if ( crcValue != CRC16( rxBuffer+3, m_macBufferLength-3 ) )
			{
				debug_log( LOG_PRIORITY_LOW, "MAC::UL DATA_BLOCK Invalid CRC-16\n" );
				return;
			}	
			SendRLLData( rxBuffer+3, m_macBufferLength-3 );
		}
		else if ( rxBuffer[0] == CMac::MAC_UPDATE_IND )
		{
			// Do CRC
			uint16_t crcValue = READ_U16_LE( rxBuffer+1 ); // OLD: *(uint16_t*)(rxBuffer+2);

			if ( crcValue != CRC16( rxBuffer+3, m_macBufferLength-3 ) )
			{
				debug_log( LOG_PRIORITY_LOW, "MAC::UL UPDATE_BLOCK_SIZE Invalid CRC-16 [%x != %x]\n", crcValue, CRC16( rxBuffer+3, m_macBufferLength-3 ) );
				return;
			}
		
			// Check new block length	
			if ( rxBuffer[3] > CMac::MAC_MAX_BLOCK_SIZE || rxBuffer[3] < CMac::MAC_MIN_BLOCK_SIZE )
			{
				debug_log( LOG_PRIORITY_LOW, "MAC::UL UPDATE_BLOCK_SIZE Invalid size range [%u-%u]\n", CMac::MAC_MIN_BLOCK_SIZE, CMac::MAC_MAX_BLOCK_SIZE );
				return; // Discard
			}

			if ( rxBuffer[3] % 4 != 0 )
			{
				debug_log( LOG_PRIORITY_LOW, "MAC::UL UPDATE_BLOCK_SIZE Invalid size %u, must be multiple of 4 for Radio DMA\n", rxBuffer[3] );
				return; // Discard
			}
			
			m_macBufferLength = rxBuffer[3];

			debug_log( LOG_PRIORITY_LOW, "MAC::UL UPDATE_BLOCK_SIZE -- Sending to RLL [%d]\n", m_macBufferLength-3 );

			SendRLLDataBlockSizeUpdate( m_macBufferLength-3 ); // -1 for header and -2 for CRC
		}
		else if ( rxBuffer[0] == CMac::MAC_RESET_IND )
		{
			m_macBufferLength = CMac::MAC_DEFAULT_BLOCK_SIZE;	

			m_rxBufferPos = 0;

			SendMACResetIndicator();	
			SendRLLDataBlockSizeUpdate( CMac::MAC_DEFAULT_BLOCK_SIZE-3 ); // -1 for header and -2 for CRC	
		}
		else
		{
			debug_log( LOG_PRIORITY_MEDIUM, "MAC::UL UNKNOWN MAC PDU TYPE [%x].\n", rxBuffer[0] );
		}
		}

		m_heartBeatCounter++;
		if ( m_heartBeatCounter % 20 == 0 )
		{
			m_heartBeatCounter = 0;
			SendRLLHeartBeat( );
		}

		// Check for incoming RLL messages
		if ( m_pRLLToMACQueue->HasMessages() )
		{
			debug_log( LOG_PRIORITY_LOW, "MAC::DL RECEIVE RLL PDU for MAC.\n" );

			CMessage *pNewMessage = m_pRLLToMACQueue->RecvMessage();

			HandleRLLMessage( pNewMessage->GetData(), pNewMessage->GetLength(), m_macBufferLength, true );
		
			delete pNewMessage;
		}

	} // while ( !bDone );
}

void CMac::HandleRLLMessage( uint8_t *pData, uint32_t dataLen, uint8_t macBufferLength, bool bCRCFlag )
{

	// Frame up message...
	if ( pData[0] == CMac::RLL_DATA_IND )
	{
		uint8_t expectedBufferLength = macBufferLength;
	
		if ( bCRCFlag )
			expectedBufferLength -= 3;
		else
			expectedBufferLength -= 1;

		if ( (dataLen-5) != expectedBufferLength )
		{
			debug_log( LOG_PRIORITY_MEDIUM, "MAC::DL RLL message did not match MAC block size, discarding" );
			return; // Ignore
		}

		uint32_t pduFrameNumber = READ_U32_LE( pData+1 ); // OLD: *((uint32_t*)(pData+1));

		if ( pduFrameNumber > m_lastRLLPDUFrameNumber )
                        m_lastRLLPDUFrameNumber = pduFrameNumber;

		// OK frame up data and send it
		uint8_t *pTempData = new uint8_t[macBufferLength];

		memset( pTempData, 0, macBufferLength );

		pTempData[0] = MAC_BLOCK_DATA_IND;
	
		if ( bCRCFlag )
		{
			WRITE_U16_LE( pTempData+1, CRC16( pData+5, dataLen-5 ) ); // OLD: *((uint16_t*)(pTempData+2)) = CRC16( pData+5, dataLen-5 );	
			memcpy( pTempData+3, pData+5, dataLen-5 ); 
		}
		else
			memcpy( pTempData+1, pData+5, dataLen-5 ); 

		m_pConnection->WriteData( pTempData, macBufferLength );

		delete pTempData;	
	}
	else if ( pData[0] == CMac::RLL_HEARTBEAT_IND )
	{
		if ( dataLen != 5 )
		{
			debug_log( LOG_PRIORITY_MEDIUM, "MAC::DL RLL heart beat size did not match, discarding" );
			return; // Ignore
		}

		uint32_t pduFrameNumber = READ_U32_LE( pData+1 ); //OLD: *((uint32_t*)(pData+1));

		if ( pduFrameNumber > m_lastRLLPDUFrameNumber )
                        m_lastRLLPDUFrameNumber = pduFrameNumber;

#if ENABLE_MAC_HEARTBEAT_MSG
		// OK frame up data and send it
		uint8_t *pTempData = new uint8_t[macBufferLength];

		memset( pTempData, 0, macBufferLength );

		pTempData[0] = MAC_BLOCK_HEARTBEAT_IND;
	
		if ( bCRCFlag )
		{
			WRITE_U16_LE( pTempData+1, CRC16( pData+5, dataLen-5 ) ); // OLD: *((uint16_t*)(pTempData+2)) = CRC16( pData+5, dataLen-5 );	
			memcpy( pTempData+3, pData+5, dataLen-5 ); 
		}
		else
			memcpy( pTempData+1, pData+5, dataLen-5 ); 
		
		m_pConnection->WriteData( pTempData, macBufferLength );

		delete pTempData;	
#endif
	} 
	else
		return; // Ignore
}

void CMac::SendMACResetIndicator( void )
{
	uint8_t pTempData[16];
	pTempData[0] = MAC_RESET_IND;
	pTempData[1] = 0;
	
	m_pConnection->WriteData( pTempData, 2 );
}

bool CMac::SendRLLData( uint8_t *pData, uint32_t dataLen, bool bCopy )
{
	// Make a copy of the data
	uint8_t *pTempData = new uint8_t[dataLen+5];

	pTempData[0] = CRLL::MAC_DATA_IND;
	// OLD: *((uint32_t*)(pTempData+1)) = m_currentFrameNumber;
	WRITE_U32_LE( pTempData+1, m_currentFrameNumber );
	
	memcpy( pTempData+5, pData, dataLen );

	// Now add message to send
	CMessage *pNewMessage = new CMessage( pTempData, dataLen+5, &FreeMessageWrapper );
	bool bSendStatus = m_pMACToRLLQueue->SendMessage( pNewMessage );

	if ( !bSendStatus )
		delete pNewMessage;

	return (bSendStatus);
}

bool CMac::SendRLLDataBlockSizeUpdate( uint8_t newDataBlockSize )
{
	debug_log( LOG_PRIORITY_LOW, "CMac::SendRLLDataBlockSizeUpdate::newDataBlockSize=%u\n", (uint32_t)newDataBlockSize );

	uint8_t *pTempData = new uint8_t[6];

	pTempData[0] = CRLL::MAC_BLOCK_SIZE_UPDATE_IND;

	// OLD: *((uint32_t*)(pTempData+1)) = m_currentFrameNumber;
	WRITE_U32_LE( pTempData+1, m_currentFrameNumber );

	pTempData[5] = newDataBlockSize;

	CMessage *pNewMessage = new CMessage( pTempData, 6, &FreeMessageWrapper );

	bool bSendStatus = m_pMACToRLLQueue->SendMessage( pNewMessage );

	if ( !bSendStatus )
		delete pNewMessage;
	
	return (bSendStatus);
}

bool CMac::SendRLLHeartBeat( void )
{
	uint8_t *pTempData = new uint8_t[5];
	
	pTempData[0] = CRLL::MAC_HEARTBEAT_IND;
	
	// OLD: *((uint32_t*)(pTempData+1)) = m_currentFrameNumber;
	WRITE_U32_LE( pTempData+1, m_currentFrameNumber );
	
	CMessage *pNewMessage = new CMessage( pTempData, 5, &FreeMessageWrapper );
	bool bSendStatus = m_pMACToRLLQueue->SendMessage( pNewMessage );

	if ( !bSendStatus )
		delete pNewMessage;

	return (bSendStatus);
}

uint16_t CMac::CRC16( uint8_t *pData, uint32_t dataLen )
{
	const uint16_t POLY = 0x8408;

        /*
        //                                      16   12   5
        // this is the CCITT CRC 16 polynomial X  + X  + X  + 1.
        // This works out to be 0x1021, but the way the algorithm works
        // lets us use 0x8408 (the reverse of the bit pattern).  The high
        // bit is always assumed to be set, thus we only use 16 bits to
        // represent the 17 bit value.
        */
        uint8_t i;
        uint32_t data = 0;
        uint32_t crc = 0xffff;

        if ( dataLen == 0 )
        {
                return ((uint16_t)(~crc));
        }


        do
        {
                for ( i=0, data=(unsigned int)0xff & *pData++; i < 8; i++, data >>= 1 )
                {
                        if ((crc & 0x0001) ^ (data & 0x0001))
                                crc = (crc >> 1) ^ POLY;
                        else
                                crc >>= 1;

                }
        } while ( --dataLen );

        crc = ~crc;
        data = crc;
        crc = (crc << 8) | (data >> 8 & 0xff);

        return ((uint16_t)(crc));
}

void CMac::UpdateTimeFrameNumber( void )
{
	m_currentFrameNumber = m_timeFrameCounter.GetFrameNumber();
}
