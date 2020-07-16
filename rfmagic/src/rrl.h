#ifndef __RRL_H__
#define __RRL_H__

#define ACCESSPOINT_NAME_MAXLEN 	128
#define ACCESSPOINT_DATA_MAXLEN		512
#define MAX_ACCESS_POINT_COUNT		8

typedef void (*fpWriteCallback)( void *pBufferAddress, uint32_t writeCount );
typedef void (*fpReadCallback)( void *pBufferAddress, uint32_t readCount );

class CAccessPointData
{
public:
	CAccessPointData( )
	{
		m_readPos = 0;
		m_writePos = 0;

		m_pData = new uint8_t[ACCESSPOINT_DATA_MAXLEN];

		m_fpWriteCallback = NULL;
		m_fpReadCallback = NULL;
	}

	~CAccessPointData()
	{
		if ( m_pData )
			delete [] m_pData;
	}

	void SetReadCallback( fpReadCallback readCallback )
	{
		m_fpReadCallback = readCallback;	
	}

	void SetWriteCallback( fpWriteCallback writeCallback )
	{
		m_fpWriteCallback = writeCallback;
	}

	uint32_t GetDataAvailable( void )
	{
		return (m_writePos - m_readPos);
	}

	uint32_t GetTotalDataLength( void )
	{
		return (m_writePos);
	}

	uint32_t ReadData( uint8_t *pDestBuffer, uint32_t count )
	{
		uint32_t dataRemaining = (m_writePos-m_readPos);

		if ( count > dataRemaining )
			count = dataRemaining;

		if ( count == 0 )
			return (0);

		memcpy( pDestBuffer, m_pData+m_readPos, count );

		m_readPos += count;

		if ( m_fpReadCallback )
			(*m_fpReadCallback)( pDestBuffer, count );
		  
		return (count);
	}

	uint32_t WriteData( uint8_t *pSrcBuffer, uint32_t count )
	{
		if ( (m_writePos+count) > ACCESSPOINT_DATA_MAXLEN )
			count = (ACCESSPOINT_DATA_MAXLEN - m_writePos);

		if ( count == 0 )
			return (0);

		memcpy( m_pData+m_writePos, pSrcBuffer, count );

		m_writePos += count;

		if ( m_fpWriteCallback )
			(*m_fpWriteCallback)( pSrcBuffer, count );

		return (count);
	}

	uint32_t GetIntegrityData( uint16_t startPos, uint16_t length );

private:
	fpWriteCallback m_fpWriteCallback;
	fpReadCallback m_fpReadCallback;
	uint32_t m_readPos;
	uint32_t m_writePos;
	uint8_t *m_pData;
	
};

class CAccessPoint : public CDoubleLink
{
public:
	CAccessPoint( uint8_t *pAPName, uint8_t apNameLength, uint32_t apID, uint8_t apType, uint8_t apSpeed, fpReadCallback readCallback, fpWriteCallback writeCallback ) : CDoubleLink()
	{
		m_apData.SetReadCallback( readCallback );
		m_apData.SetWriteCallback( writeCallback );
		
		for ( uint8_t i = 0; i < apNameLength; i++ )
			m_apName[i] = pAPName[i];
	
		m_apNameLength = apNameLength;	
		m_apID = apID;
		m_apType = apType;
		m_apSpeed = apSpeed;

	}

	~CAccessPoint( )
	{

	}

	uint8_t *GetAPName( void ) { return m_apName; };
	uint8_t GetAPNameLength( void ) const { return m_apNameLength; };
	uint32_t GetAPID( void ) const { return m_apID; };
	uint8_t GetAPType( void ) const { return m_apType; };
	uint8_t GetAPSpeed( void ) const { return m_apSpeed; };

	CAccessPointData &GetData( void ) { return m_apData; };

	uint32_t GetAPInfoString( uint8_t *pResponseBuffer, uint32_t responseMaxLen );

private:
	uint8_t m_apName[ACCESSPOINT_NAME_MAXLEN];
	uint8_t m_apNameLength;
	uint32_t m_apID;
	uint8_t m_apType;
	uint8_t m_apSpeed;
	
	CAccessPointData m_apData;
};

// Radio Resource Layer
// Handles allocation/deallocation of radio resources
// Encrpytion/Decryption settings
// Access and authentication
// Capabilities verification
// Connection setup
class CRRL
{
public:
	static const uint32_t RRL_MESSAGE_LENGTH = 0x4;

	enum
	{
		RRL_MESSAGE_SHUTDOWN = 0x1
	};

	enum
	{
		HEARTBEAT_REQUEST_ID = 0x71,
		INTEGRITY_REQUEST_ID = 0x3f,
		ACCESSPOINT_SETUP_REQUEST_ID = 0x23,
		ACCESSPOINT_DESTROY_REQUEST_ID = 0x87,
		ACCESSPOINT_INFO_REQUEST_ID = 0x52
	};

	enum
	{
		HEARTBEAT_RESPONSE_ID = 0xe2,
		INTEGRITY_RESPONSE_ID = 0xaa,
		ACCESSPOINT_SETUP_RESPONSE_ID = 0x5e,
		ACCESSPOINT_DESTROY_RESPONSE_ID = 0x94,
		ACCESSPOINT_INFO_RESPONSE_ID = 0x28
	};

	// Fast Access Message response id's
	enum
	{
		FAST_ACCESS_FAILURE_ID = 0x17,
		FAST_WRITE_COMMAND_ID = 0x1,
		FAST_READ_COMMAND_ID = 0x2,
	};

	enum
	{
		FAST_AP_NOT_FOUND = 0x33,
		FAST_BAD_COMMAND = 0x77
	};

	// Integrity message response id's
	enum
	{
		INTEGRITY_FAILURE_ID = 0xcc,
		INTEGRITY_AP_NOT_FOUND_ID = 0x33,
		INTEGRITY_INVALID_LENGTH_ID = 0x86,
		INTEGRITY_INVALID_START_ID = 0x5d,
		INTEGRITY_SUCCESS_ID = 0x8f
	};

	// Access Point message response id's
	enum
	{
		ACCESSPOINT_SETUP_SUCCESS = 0,
		ACCESSPOINT_SETUP_FAILURE = 1,
		ACCESSPOINT_SETUP_ALREADY_EXISTS = 2,
		ACCESSPOINT_SETUP_TOO_MANY = 3
	};

	// Access Point destroy message response id's
	enum
	{
		ACCESSPOINT_DESTROY_SUCCESS = 0,
		ACCESSPOINT_DESTROY_FAILURE = 1,
		ACCESSPOINT_DESTROY_DOES_NOT_EXIST = 2
	};

	// Access Point info message response id's
	enum
	{
		ACCESSPOINT_INFO_SUCCESS = 0,
		ACCESSPOINT_INFO_FAILURE = 1,
		ACCESSPOINT_INFO_DOES_NOT_EXIST = 2
	};

public:
	CRRL( CMessageQueue *pRLLToRRLQueue, CMessageQueue *pRRLToRLLQueue, CMessageQueue *pInterMessageQueue );
	~CRRL( );

	void Process( void );

private:
	void HandleRLLMessage( uint8_t *pData, uint32_t dataLen );
	bool HandleInternalMessage( uint8_t *pData, uint32_t dataLen );

	void HandleBroadcastMessage( uint8_t *pData, uint32_t dataLen );
	void HandleDedicatedMessage( uint8_t *pData, uint32_t dataLen );
	void HandleFastMessage( uint8_t *pData, uint32_t dataLen );

	void SendBroadcastResponse( uint8_t *pData, uint32_t dataLen );
	void SendDedicatedResponse( uint8_t *pData, uint32_t dataLen );
	void SendFastResponse( uint8_t *pData, uint32_t dataLen );

	void SendSecurityParameters( uint8_t *pData, uint32_t dataLen );

	void HandleHeartBeatRequest( uint8_t *pData, uint32_t dataLen );
	void HandleIntegrityRequest( uint8_t *pData, uint32_t dataLen );
	void HandleAccessPointSetupRequest( uint8_t *pData, uint32_t dataLen );
	void HandleAccessPointDestroyRequest( uint8_t *pData, uint32_t dataLen );
	void HandleAccessPointInfoRequest( uint8_t *pData, uint32_t dataLen );

	bool GetAPIDForName( uint8_t *pAPName, uint8_t nameLength, uint32_t &foundAPID );
	CAccessPoint *GetAPForID( uint32_t apID );
	uint32_t GetAccessPointCount( void );

	void RunCipher( uint32_t v[2], uint32_t key[4] );

private:
	CMessageQueue *m_pRLLToRRLQueue;
	CMessageQueue *m_pRRLToRLLQueue;
	CMessageQueue *m_pInterMessageQueue;

	// List of access points
	CDoubleList m_apList;
	

	uint32_t m_localSecretKey[4];

	uint32_t m_tickCount;
};

#endif // __RRL_H__
