#ifndef __CIO_CONNECTION_H__
#define __CIO_CONNECTION_H__

#define MAX_BUFFER_SIZE	2048

class CIOConnection
{
public:
	CIOConnection();

	int32_t ReadData( uint8_t *pBuffer, uint32_t maxLen );
	int32_t WriteData( uint8_t *pBuffer, uint32_t maxLen );

	bool IsInputAvailable( void );

	int32_t ReadAvailableInput( uint8_t *pBuffer, uint32_t maxLen );

public:
	uint8_t m_readBuffer[MAX_BUFFER_SIZE];
	uint8_t m_writeBuffer[MAX_BUFFER_SIZE];

	uint32_t m_readBufferSize;
	uint32_t m_readBufferWritePos;
	uint32_t m_readBufferReadPos;
	
	uint32_t m_writeBufferSize;
	uint32_t m_writeBufferWritePos;
	uint32_t m_writeBufferReadPos;
};

#endif // __CIO_CONNECTION_H__

