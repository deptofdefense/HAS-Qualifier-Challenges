#include "common.h"	
#include "synovauartreg.h"

#if X86_TARGET
#include <fcntl.h>      /* Needed only for _O_RDWR definition */
#include <stdio.h>
#endif

#include <stdlib.h>

#if X86_TARGET
#else
volatile uint32_t *WRITE_DATA_REG = (uint32_t*)(SYNOVA_UART2_ADDR + UART_WRITE_DATA);
volatile uint32_t *WRITE_CONTROL_REG = (uint32_t*)(SYNOVA_UART2_ADDR + UART_WRITE_CONTROL);
volatile uint32_t *READ_DATA_REG = (uint32_t*)(SYNOVA_UART2_ADDR + UART_READ_DATA);
volatile uint32_t *READ_CONTROL_REG = (uint32_t*)(SYNOVA_UART2_ADDR + UART_READ_CONTROL);
#endif

CIOConnection *g_iodata;

extern void CIO_ReadInterrupt( void ) asm ("CIO_ReadInterrupt");
extern void CIO_WriteInterrupt( void ) asm ("CIO_WriteInterrupt");

inline void CIO_TurnOnInterrupts( void )
{
	*(WRITE_CONTROL_REG) |= 0x1;
	*(READ_CONTROL_REG) |= 0x1;
}

inline void CIO_EnableReadInterrupt( void )
{
	__asm__
        __volatile__
        (
        "mfc0 $a0, $12 \n"
        "ori $a0, $a0, 0x1001 \n"              /* IM4 and IEc */
        "mtc0 $a0, $12\n"
        : : : "%a0"
        );
}

inline void CIO_DisableReadInterrupt( void )
{
	 __asm__
        __volatile__
        (
        "mfc0 $a0, $12 \n"
	"lui $a1, 0xffff\n"
        "ori $a1, 0xefff\n"
        "and $a0, $a1 \n"              /* IM4 and IEc */
        "mtc0 $a0, $12\n"
        : : : "%a0", "%a1"
        );
}

inline void CIO_EnableWriteInterrupt( void )
{
        __asm__
        __volatile__
        (
        "mfc0 $a0, $12 \n"
        "ori $a0, $a0, 0x2001 \n"              /* IM5 and IEc */
        "mtc0 $a0, $12\n"
        : : : "%a0"
        );
}

inline void CIO_DisableWriteInterrupt( void )
{
         __asm__
        __volatile__
        (
        "mfc0 $a0, $12 \n"
	"lui $a1, 0xffff\n"
        "ori $a1, 0xdfff\n"
        "and $a0, $a1 \n"              /* IM5 and IEc */
        "mtc0 $a0, $12\n"
        : : : "%a0", "%a1"
        );
}

void CIO_ReadInterrupt( void )
{
	uint32_t in_word = (*READ_DATA_REG);	// Read clears interrupt

	if ( (*g_iodata).m_readBufferSize+4 > MAX_BUFFER_SIZE )
	{
		// TODO: Handle read buffer overrun
		return;
	}

	// Unpack and save
	(*g_iodata).m_readBuffer[(*g_iodata).m_readBufferWritePos++] = (in_word >> 24) & 0xFF;
	if ( (*g_iodata).m_readBufferWritePos >= MAX_BUFFER_SIZE )
		(*g_iodata).m_readBufferWritePos = 0;

	(*g_iodata).m_readBuffer[(*g_iodata).m_readBufferWritePos++] = (in_word >> 16) & 0xFF;
	if ( (*g_iodata).m_readBufferWritePos >= MAX_BUFFER_SIZE )
		(*g_iodata).m_readBufferWritePos = 0;

	(*g_iodata).m_readBuffer[(*g_iodata).m_readBufferWritePos++] = (in_word >> 8) & 0xFF;
	if ( (*g_iodata).m_readBufferWritePos >= MAX_BUFFER_SIZE )
		(*g_iodata).m_readBufferWritePos = 0;

	(*g_iodata).m_readBuffer[(*g_iodata).m_readBufferWritePos++] = (in_word) & 0xFF;
	if ( (*g_iodata).m_readBufferWritePos >= MAX_BUFFER_SIZE )
		(*g_iodata).m_readBufferWritePos = 0;

	(*g_iodata).m_readBufferSize += 4;
}

void CIO_WriteInterrupt( void )
{
	uint32_t write_word = 0;

	if ( (*g_iodata).m_writeBufferSize < 4 )
	{
		// Write complete -- clear pending interrupt
		(*WRITE_CONTROL_REG) |= UART_CR_INT_CLEAR_BIT;
		return;
	}

	write_word |= ((*g_iodata).m_writeBuffer[(*g_iodata).m_writeBufferReadPos++] << 24);
	if ( (*g_iodata).m_writeBufferReadPos >= MAX_BUFFER_SIZE )
		(*g_iodata).m_writeBufferReadPos = 0;

	write_word |= ((*g_iodata).m_writeBuffer[(*g_iodata).m_writeBufferReadPos++] << 16);
	if ( (*g_iodata).m_writeBufferReadPos >= MAX_BUFFER_SIZE )
		(*g_iodata).m_writeBufferReadPos = 0;

	write_word |= ((*g_iodata).m_writeBuffer[(*g_iodata).m_writeBufferReadPos++] << 8);
	if ( (*g_iodata).m_writeBufferReadPos >= MAX_BUFFER_SIZE )
		(*g_iodata).m_writeBufferReadPos = 0;

	write_word |= ((*g_iodata).m_writeBuffer[(*g_iodata).m_writeBufferReadPos++]);
	if ( (*g_iodata).m_writeBufferReadPos >= MAX_BUFFER_SIZE )
		(*g_iodata).m_writeBufferReadPos = 0;

	(*WRITE_DATA_REG) = write_word;

	(*g_iodata).m_writeBufferSize -= 4;
}

CIOConnection::CIOConnection( )
	: m_readBufferSize(0), m_readBufferReadPos(0), m_readBufferWritePos(0), m_writeBufferSize(0), m_writeBufferReadPos(0), m_writeBufferWritePos(0)
{
	CIO_EnableReadInterrupt();
	CIO_EnableWriteInterrupt();

	CIO_TurnOnInterrupts();
}

int32_t CIOConnection::ReadData( uint8_t *pBuffer, uint32_t maxLen )
{
	uint32_t readCount = 0;
	unsigned char curChar;

#if X86_TARGET
#else
	CIO_DisableReadInterrupt();
	// UART reads 4-bytes at a time (nonblocking read)
	while ( m_readBufferSize > 0 && readCount < maxLen )
	{
		pBuffer[readCount] = m_readBuffer[m_readBufferReadPos++];

		// Check for read buffer wrap-around
		if ( m_readBufferReadPos >= MAX_BUFFER_SIZE )
			m_readBufferReadPos = 0;

		readCount++;
		m_readBufferSize--;
	}	
	CIO_EnableReadInterrupt();
#endif

	return (readCount);
}
	
int32_t CIOConnection::WriteData( uint8_t *pBuffer, uint32_t maxLen )
{
	uint32_t writeCount = 0;

#if X86_TARGET
	return write( 1, pBuffer, maxLen );
#else
	CIO_DisableWriteInterrupt();
	while ( writeCount < maxLen )
	{
		if ( m_writeBufferSize > MAX_BUFFER_SIZE )
		{
			// Write buffer overflow!
			return -1;
		}

		m_writeBuffer[m_writeBufferWritePos++] = pBuffer[writeCount];
		
		// Check for write wrap buffer wrap-around
		if ( m_writeBufferWritePos >= MAX_BUFFER_SIZE )
			m_writeBufferWritePos = 0;

		writeCount++;
		m_writeBufferSize++;

	}

	// Check write control register -- if write FIFO is ready and an interrupt is not pending... start writing with interrupt
	uint32_t WRITE_CR_REG_VALUE = *(WRITE_CONTROL_REG);
	if ( WRITE_CR_REG_VALUE & UART_CR_RDY_BIT && !(WRITE_CR_REG_VALUE & UART_CR_INT_SET_BIT) )
		*(WRITE_CONTROL_REG) |= UART_CR_INT_SET_BIT;

	CIO_EnableWriteInterrupt();

	return writeCount;
#endif
}

bool CIOConnection::IsInputAvailable( void )
{
#if X86_TARGET
	fd_set fds;
	int maxfd;
	struct timeval timeout;

	timeout.tv_sec = 0;
	timeout.tv_usec = 0;

	maxfd = fileno(stdin);
	
	FD_ZERO( &fds );
	FD_SET( fileno(stdin), &fds );

	select( maxfd+1, &fds, NULL, NULL, &timeout );

	if ( FD_ISSET( fileno(stdin), &fds ) )
		return (true);
	else
		return (false);
#else
	
	return (m_readBufferSize > 0);
#endif
}
