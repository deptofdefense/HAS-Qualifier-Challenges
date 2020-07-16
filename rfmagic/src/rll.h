#ifndef __RLL_H__
#define __RLL_H__

class CMessageQueue;

// Radio Link Layer (packet refragmentation and assembly)
// Possible encryption/decryption
class CRLL
{
public:
	enum
	{
		RLL_PDU_LENGTH = 0x8,
		RLL_CHANNEL_BROADCAST = 0x17,
		RLL_CHANNEL_DEDICATED = 0x73,
		RLL_CHANNEL_FAST = 0xc3,
		RLL_SECURITY_PARAMETERS = 0xd2
	};

	enum
	{
		RLL_MESSAGE_UPDATE_INTEGRITY = 0x31,
		RLL_MESSAGE_UPDATE_SECURITY = 0x89,
		RLL_MESSAGE_SHUTDOWN = 0xfa
	};

	static const uint32_t MAX_PDU_SEQUENCE_WINDOW_DELTA = 16;
	static const uint32_t MAX_FRAME_NUMBER_TIMEOUT = 120;	// 120 frames or 3 seconds with 25ms frames

	static const uint8_t MAC_DATA_IND = 0x37;
	static const uint8_t MAC_BLOCK_SIZE_UPDATE_IND = 0x31;
	static const uint8_t MAC_HEARTBEAT_IND = 0x4a;

public:
	CRLL( CMessageQueue *pMACToRLLQueue, CMessageQueue *pRLLToRRLQueue, CMessageQueue *pRLLToMACQueue, CMessageQueue *pRRLToRLLQueue, CMessageQueue *pInterMessageQueue );
	~CRLL();

	void InitTimeFrameCounter( uint64_t startValue );
	void Process( void );

	bool DecipherPDU( uint8_t *pStream, uint32_t streamLength );
	bool EncipherPDU( uint8_t *pStream, uint32_t streamLength );

private:
	bool CipherReset( uint32_t newState[2] );
	void RunCipher( uint32_t v[2], uint32_t key[4] );

	void HandleMACMessage( uint8_t *pData, uint32_t dataLen );
	void HandleRRLMessage( uint8_t *pData, uint32_t dataLen );
	bool HandleInternalMessage( uint8_t *pData, uint32_t dataLen );

	void HandleBroadcastPDU( uint8_t pduChannel, uint8_t *pduData, uint32_t dataLen );
	void HandleDedicatedPDU( uint8_t pduChannel, uint8_t *pduData, uint32_t dataLen );
	void HandleFastPDU( uint8_t pduChannel, uint8_t *pduData, uint32_t dataLen );

	void UpdateSecurityParametersMessage( uint8_t *pData, uint32_t dataLen );

	void ReceiveRRLBroadcastMessage( uint8_t *pData, uint32_t dataLen );
	void ReceiveRRLDedicatedMessage( uint8_t *pData, uint32_t dataLen );
	void ReceiveRRLFastMessage( uint8_t *pData, uint32_t dataLen );

	void SendMACHeartBeat( void );

	void UpdateTimeFrameNumber( void );

	void ResetRXPDUSequenceAndAssembly( uint16_t newPDUSize );

private:
	CPDUFragmentPool m_oPDUPool;	// A pool of PDUs used for packet reassembly
	CDoubleList m_rxPDUFragments;	// List of RX PDU fragments to assemble

	CTimeFrame m_timeFrameCounter;
	uint32_t m_lastMACPDUFrameNumber;	// Last received MAC PDU frame number

	uint32_t m_currentFrameNumber;	// The current time frame for this thread!

	uint8_t m_macDataBlockSize;	// The size of the data part of the MAC block (so we can send the data to the MAC appropriately!)
	bool m_bCipherEnabled;
	uint32_t m_cipherKey[4];

	uint8_t m_securityRoundCount;	// 16-64 rounds (configurable)
	
	uint32_t m_ulCipherState[2];	// Uplink cipher state
	uint32_t m_dlCipherState[2];	// Downlink cipher state	

	uint32_t m_pduSequenceNumberLastRX;	// Last sequence number RX
	uint32_t m_pduSequenceNumberLastTX;	// Last sequence number TX

	uint32_t m_heartBeatCounter;
	
	CMessageQueue *m_pMACToRLLQueue;
	CMessageQueue *m_pRLLToRRLQueue;

	CMessageQueue *m_pRLLToMACQueue;
	CMessageQueue *m_pRRLToRLLQueue;

	CMessageQueue *m_pInterMessageQueue;
};

#endif // __RLL_H__
