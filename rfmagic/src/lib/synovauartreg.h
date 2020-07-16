
#ifndef __SYNOVAUARTREG_H__
#define __SYNOVAUARTREG_H__

// Physical Base Address/
#define SYNOVA_UART1_BASE           0x02000000

// Virtual (KSEG0) address
#define SYNOVA_UART1_ADDR           0xa2000000

#define SYNOVA_UART2_BASE           0x02000010
#define SYNOVA_UART2_ADDR           0xa2000010

/* register offsets */
#define UART_READ_CONTROL	0x0
#define UART_READ_DATA		0x4
#define UART_WRITE_CONTROL	0x8
#define UART_WRITE_DATA		0xc

#define UART_CR_IE_BIT		0x1	// Set to enable interrupts
#define UART_CR_RDY_BIT		0x2	// Set when data is ready to read from data register
#define	UART_CR_INT_SET_BIT	0x4	// Set when an interrupt is triggered (interrupt is cleared on read for READ_DATA and write to WRITE_DATA register)
#define UART_CR_INT_CLEAR_BIT	0x8	// Clear any pending interrupts

#endif // __SYNOVAUARTREG_H__
