#ifndef __MESSAGE_QUEUE_H__
#define __MESSAGE_QUEUE_H__

typedef void (*tFPFreeFuncPtr)( uint8_t * );

class CMessage : public CDoubleLink
{
public:
	CMessage( uint8_t *pMessageData, uint32_t messageLen, tFPFreeFuncPtr fpFreeFunc );
	~CMessage( );

	uint8_t *GetData( void ) const { return m_pData; };
	uint32_t GetLength( void ) { return m_length; };

private:
	uint8_t *m_pData;
	uint32_t m_length;
	tFPFreeFuncPtr m_fpFreeFunc;	
};

class CMessageQueue
{
public:
	CMessageQueue( const char *pName );
	~CMessageQueue();

	bool SendMessage( CMessage *pMessage );

	CMessage *RecvMessage( void );

	bool HasMessages( void );
	uint32_t MessageCount( void );

private:
#ifdef USE_MUTEX_LOCK
	std::mutex m_oMutex;
#endif // USE_MUTEX_LOCK

	CDoubleList m_oList;
	char *m_pQueueName;
	uint32_t m_queueCount;
};

#endif // __MESSAGE_QUEUE_H__
