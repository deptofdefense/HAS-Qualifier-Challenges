#ifndef __PDU_POOL_H__
#define __PDU_POOL_H__

class CPDUFragment
{
public:
	friend class CPDUFragmentPool;

public:
	CPDUFragment( uint8_t fragmentNumber, uint8_t *pData, uint8_t dataLen );
	
	uint8_t *GetData( void ) { return m_pData; };
	uint8_t GetDataLength( void ) { return m_dataLen; };
	uint8_t GetFragmentNumber( void ) { return m_fragmentNumber; };

private:
	uint8_t *m_pData;
	uint8_t m_dataLen;
	uint8_t m_fragmentNumber;

	CPDUFragment *m_pNext;
	CPDUFragment *m_pPrev;
};

class CPDUFragmentPool
{
private:
	static const uint32_t PDU_POOL_RESERVE_MEMORY_SIZE = 0x10000;

public:
	CPDUFragmentPool( );
	~CPDUFragmentPool( );

	void InitPool( uint8_t fragmentMaxSize );

	CPDUFragment *AllocateFragment( uint8_t fragmentNumber, uint8_t *pData, uint8_t dataLen );
	void FreeFragment( CPDUFragment *pFragment );
	
private:
	uint8_t *m_pPoolData;

	CPDUFragment *m_pFreeList;
	uint32_t m_freePDUCount;
	uint32_t m_usePDUCount;
};

class CFragmentBuffer : public CDoubleLink
{
public:
	static const uint8_t MAX_PACKET_FRAGMENTS = 16;

public:
        CFragmentBuffer( uint16_t sequenceNumber, CPDUFragmentPool *pFragmentPool );
        ~CFragmentBuffer( );

        uint16_t GetSequenceNumber( void ) { return m_sequenceNumber; };

        bool AddFragment( bool bLastFragment, uint8_t fragNumber, uint8_t *pData, uint16_t dataLen );
        bool HasAllFragments( void );
        uint16_t GetAssembledSize( void );
        bool AssemblePacket( uint8_t *pOutBuffer, uint16_t bufferMaxLen, uint16_t &bufferOutLen );

private:
	CPDUFragmentPool *m_pFragmentPool;
        CPDUFragment *m_pSegments[MAX_PACKET_FRAGMENTS];
        uint16_t m_sequenceNumber;
        uint8_t m_lastFragmentNumber;
        bool m_bHasLastFragment;
};

#endif // __PDU_POOL_H__
