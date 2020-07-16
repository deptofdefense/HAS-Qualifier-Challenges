#include "common.h"

CMessage::CMessage( uint8_t *pMessageData, uint32_t messageLen, tFPFreeFuncPtr fpFreeFunc )
	: CDoubleLink(), m_pData( pMessageData ), m_length( messageLen ), m_fpFreeFunc( fpFreeFunc )
{

}

CMessage::~CMessage( )
{
	if ( m_pData )
	{
		if ( m_fpFreeFunc )
			(*m_fpFreeFunc)( m_pData );
	}
}

CMessageQueue::CMessageQueue( const char *pName )
	: m_pQueueName( NULL ), m_queueCount( 0 )
{
	m_pQueueName = new char[strlen(pName)];

	strcpy( m_pQueueName, (char *)pName );
}

CMessageQueue::~CMessageQueue( )
{
	m_oList.DeleteAll();
}

bool CMessageQueue::SendMessage( CMessage *pMessage )
{
	if ( !pMessage )
		return (false);

	if ( m_queueCount >= MAX_QUEUE_COUNT )
		return (false);

	// --------------
	// Thread locking
	// --------------
#ifdef USE_MUTEX_LOCK
	m_oMutex.lock();
#endif // USE_MUTEX_LOCK
	
	bool bAddResult = m_oList.AddLast( pMessage );
	
	if ( bAddResult )
		m_queueCount++;

#ifdef USE_MUTEX_LOCK	
	m_oMutex.unlock();
#endif // USE_MUTEX_LOCK
	// --------------
	// Thread unlocking
	// --------------

	return bAddResult;
}

CMessage *CMessageQueue::RecvMessage( void )
{
	if ( m_queueCount == 0 )
		return (NULL);

	
	// --------------
	// Thread locking
	// --------------
#ifdef USE_MUTEX_LOCK
	m_oMutex.lock();
#endif // USE_MUTEX_LOCK
	
	CMessage *pMessage = (CMessage *)m_oList.RemoveFirst( );

	m_queueCount--;

#ifdef USE_MUTEX_LOCK	
	m_oMutex.unlock();
#endif // USE_MUTEX_LOCK
	// --------------
	// Thread unlocking
	// --------------

	return (pMessage);
}

bool CMessageQueue::HasMessages( void )
{
	// Atomic
	if ( m_queueCount > 0 )
		return (true);
	else
		return (false);
}

uint32_t CMessageQueue::MessageCount( void )
{
	// Atomic
	return (m_queueCount);
}
