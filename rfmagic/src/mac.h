#ifndef __MAC_H__
#define __MAC_H__

class CMessageQueue;

// Handles low level physical -> logical channel translation
class CMac
{
public:
	const uint32_t MAC_MAX_BLOCK_SIZE = 192; // Maximum RX at a time
	const uint32_t MAC_MIN_BLOCK_SIZE = 16;	 // Minimum block size

	const uint32_t MAC_DEFAULT_BLOCK_SIZE = 32;
	const uint32_t MAC_BLOCK_DATA_IND = 0xe3;
	const uint32_t MAC_UPDATE_IND = 0x79;
	const uint32_t MAC_RESET_IND = 0x13;
	const uint32_t MAC_BLOCK_HEARTBEAT_IND = 0x55;
	const uint32_t MAC_UPDATE_BLOCK_SIZE = 0x31;

	static const uint32_t MAX_FRAME_NUMBER_TIMEOUT = 3*10*1000*1000;    // 25 frames or 3 seconds at 40ms per frame

	static const uint8_t RLL_DATA_IND = 0x9c;
        static const uint8_t RLL_HEARTBEAT_IND = 0x4d;

public:
	CMac( CMessageQueue *pMACToRLLQueue, CMessageQueue *pRLLToMACQueue, CMessageQueue *pInterMessageQueue, CIOConnection *pConnection );
	~CMac();

	void InitTimeFrameCounter( uint64_t startValue );
	void Process( void );

private:
	void HandleRLLMessage( uint8_t *pData, uint32_t dataLen, uint8_t macBufferLength, bool bCRCFlag );
	void SendMACResetIndicator( void );

	bool SendRLLData( uint8_t *pData, uint32_t dataLen, bool bCopy = true );	
	bool SendRLLDataBlockSizeUpdate( uint8_t dataBlockSize );
	bool SendRLLHeartBeat( void );	
	uint16_t CRC16( uint8_t *pData, uint32_t dataLen );

	void UpdateTimeFrameNumber( void );

private:
	CTimeFrame m_timeFrameCounter;
	uint32_t m_currentFrameNumber;

	uint32_t m_lastRLLPDUFrameNumber;	// Last frame number from RLL PDU

	CIOConnection *m_pConnection;
	CMessageQueue *m_pMACToRLLQueue;
	CMessageQueue *m_pRLLToMACQueue;
	CMessageQueue *m_pInterMessageQueue;

	uint8_t m_rxBuffer[192*2];
	uint16_t m_rxBufferPos;

	uint8_t m_macBufferLength;

	uint32_t m_heartBeatCounter;

	bool m_bFirstRun;

};

#endif // __MAC_H__
