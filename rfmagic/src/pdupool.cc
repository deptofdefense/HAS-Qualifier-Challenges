#include "common.h"

CPDUFragment::CPDUFragment( uint8_t fragmentNumber, uint8_t *pData, uint8_t dataLen )
	: m_pNext( NULL ), m_pPrev( NULL ), m_fragmentNumber( fragmentNumber ), m_pData( pData ), m_dataLen( dataLen )
{

}

CPDUFragmentPool::CPDUFragmentPool( )
{
	m_pPoolData = new uint8_t[PDU_POOL_RESERVE_MEMORY_SIZE];

	m_pFreeList = NULL;
}

CPDUFragmentPool::~CPDUFragmentPool( )
{
	if ( m_pPoolData )
		delete m_pPoolData;
}

void CPDUFragmentPool::InitPool( uint8_t fragmentMaxSize )
{
	uint8_t fragmentDataStructSize = sizeof(CPDUFragment);

	// Round up 4-byte boundaries
	if ( fragmentDataStructSize % 4 != 0 )
		fragmentDataStructSize = ((fragmentDataStructSize >> 2)+1) << 2;

	// Round up 4-byte boundaries
	if ( fragmentMaxSize % 4 != 0 )
		fragmentMaxSize = ((fragmentMaxSize >> 2)+1) << 2;

	// Reset pool
	m_pFreeList = NULL;

	// Generate PDU pool
	m_freePDUCount = 0;
	for ( uint32_t bytePos = 0; bytePos <= (PDU_POOL_RESERVE_MEMORY_SIZE-(fragmentDataStructSize+fragmentMaxSize)); )
	{
		CPDUFragment *pNewFragment = (CPDUFragment *)(m_pPoolData+bytePos);	

		// Add at end...
		if ( m_pFreeList == NULL )
		{
			pNewFragment->m_pNext = pNewFragment->m_pPrev = NULL;

			m_pFreeList = pNewFragment;
		}
		else
		{
			pNewFragment->m_pNext = m_pFreeList;
			pNewFragment->m_pPrev = NULL;

			m_pFreeList->m_pPrev = pNewFragment;
		
			m_pFreeList = pNewFragment;	
		}

		m_freePDUCount++;

		// Save data	
		pNewFragment->m_pData = (m_pPoolData+bytePos+fragmentDataStructSize);

		// Increment	
		bytePos += fragmentDataStructSize+fragmentMaxSize;
	}

	debug_log( LOG_PRIORITY_LOW, "PDUPOOL::Init (size=%d) (items=%d) (%x,%x)", PDU_POOL_RESERVE_MEMORY_SIZE, m_freePDUCount, fragmentDataStructSize, fragmentMaxSize );

	m_usePDUCount = 0;
}

CPDUFragment *CPDUFragmentPool::AllocateFragment( uint8_t fragmentNumber, uint8_t *pData, uint8_t dataLen )
{
	if ( m_freePDUCount == 0 )
		return (NULL);

	if ( m_pFreeList == NULL )
		return (NULL);

	CPDUFragment *pNewFragment = m_pFreeList;
	
	m_pFreeList = pNewFragment->m_pNext;
	m_pFreeList->m_pPrev = NULL;

	pNewFragment->m_pNext = NULL;
	pNewFragment->m_pPrev = NULL;

	memcpy( pNewFragment->m_pData, pData, dataLen );
	pNewFragment->m_dataLen = dataLen;
	pNewFragment->m_fragmentNumber = fragmentNumber;

	m_freePDUCount--;
	m_usePDUCount++;

	return (pNewFragment);	
}

void CPDUFragmentPool::FreeFragment( CPDUFragment *pFragment )
{
	if ( pFragment == NULL )
		return;

	if ( (uint8_t*)pFragment < m_pPoolData || (uint8_t*)pFragment > (m_pPoolData+PDU_POOL_RESERVE_MEMORY_SIZE) )
	{
		debug_log( LOG_PRIORITY_HIGH, "PDUPOOL::Free Invalid fragment memory error" );
		return;
	}

	pFragment->m_pNext = m_pFreeList;
	m_pFreeList->m_pPrev = pFragment;

	pFragment->m_pPrev = NULL;

	m_pFreeList = pFragment;

	m_freePDUCount++;
	m_usePDUCount--;
}

CFragmentBuffer::CFragmentBuffer( uint16_t sequenceNumber, CPDUFragmentPool *pFragmentPool )
	: CDoubleLink( ), m_sequenceNumber( sequenceNumber ), m_lastFragmentNumber( 0 ), m_bHasLastFragment( false ), m_pFragmentPool( pFragmentPool )
{
	for ( uint32_t i = 0; i < MAX_PACKET_FRAGMENTS; i++ )
		m_pSegments[i] = NULL;
}

CFragmentBuffer::~CFragmentBuffer( )
{
	for ( uint32_t i = 0; i < MAX_PACKET_FRAGMENTS; i++ )
	{
		if ( m_pSegments[i] )
			m_pFragmentPool->FreeFragment( m_pSegments[i] );
		
		m_pSegments[i] = NULL;
	}
}

bool CFragmentBuffer::AddFragment( bool bLastFragment, uint8_t fragmentNumber, uint8_t *pData, uint16_t dataLen )
{
	if ( !pData )
		return (false);

	CPDUFragment *pNewFragment = m_pFragmentPool->AllocateFragment( fragmentNumber, pData, dataLen );

	if ( !pNewFragment )
		return (false);

	m_pSegments[fragmentNumber] = pNewFragment;

	if ( bLastFragment )
	{
		m_bHasLastFragment = true;
		m_lastFragmentNumber = fragmentNumber;
	}

	// Fragment added
	return (true);	
}

bool CFragmentBuffer::HasAllFragments( void )
{
	if ( !m_bHasLastFragment )
		return (false);

	uint8_t count = 0;
	for ( uint8_t i = 0; i < (m_lastFragmentNumber+1); i++ )
	{
		if ( m_pSegments[i] )
			count++;
	}

	if ( count == (m_lastFragmentNumber+1) )
		return (true);
	else
		return (false);
}

uint16_t CFragmentBuffer::GetAssembledSize( void )
{
	uint16_t size = 0;
	for ( uint8_t i = 0; i < (m_lastFragmentNumber+1); i++ )
	{
		if ( m_pSegments[i] )
			size += m_pSegments[i]->GetDataLength();
	}

	return (size);
}

bool CFragmentBuffer::AssemblePacket( uint8_t *pBuffer, uint16_t bufferMaxLen, uint16_t &bufferOutLen )
{
	uint32_t pos = 0;

	if ( GetAssembledSize() > bufferMaxLen )
		return (false);

	// BUG:: Assembled size could be less than this size (calculated below) due to out of range packets
	for ( uint8_t i = 0; i < MAX_PACKET_FRAGMENTS; i++ )
	{
		if ( m_pSegments[i] )
		{
			memcpy( pBuffer+pos, m_pSegments[i]->GetData(), m_pSegments[i]->GetDataLength() );

			pos += m_pSegments[i]->GetDataLength();
		}	
	}

	// Return out buffer length
	bufferOutLen = pos;
	return (true);
}
