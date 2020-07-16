#include "common.h"

/*
 * This is an OpenSSL-compatible implementation of the RSA Data Security, Inc.
 * MD5 Message-Digest Algorithm (RFC 1321).
 *
 * Homepage:
 * http://openwall.info/wiki/people/solar/software/public-domain-source-code/md5
 *
 * Author:
 * Alexander Peslyak, better known as Solar Designer <solar at openwall.com>
 *
 * This software was written by Alexander Peslyak in 2001.  No copyright is
 * claimed, and the software is hereby placed in the public domain.
 * In case this attempt to disclaim copyright and place the software in the
 * public domain is deemed null and void, then the software is
 * Copyright (c) 2001 Alexander Peslyak and it is hereby released to the
 * general public under the following terms:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted.
 *
 * There's ABSOLUTELY NO WARRANTY, express or implied.
 *
 * (This is a heavily cut-down "BSD license".)
 *
 * This differs from Colin Plumb's older public domain implementation in that
 * no exactly 32-bit integer data type is required (any 32-bit or wider
 * unsigned integer data type will do), there's no compile-time endianness
 * configuration, and the function prototypes match OpenSSL's.  No code from
 * Colin Plumb's implementation has been reused; this comment merely compares
 * the properties of the two independent implementations.
 *
 * The primary goals of this implementation are portability and ease of use.
 * It is meant to be fast, but not as fast as possible.  Some known
 * optimizations are not included to reduce source code size and avoid
 * compile-time configuration.
 */

// MD5 Wrapper based on the code from above

/*
 * The basic MD5 functions.
 *
 * F and G are optimized compared to their RFC 1321 definitions for
 * architectures that lack an AND-NOT instruction, just like in Colin Plumb's
 * implementation.
 */
#define F(x, y, z)			((z) ^ ((x) & ((y) ^ (z))))
#define G(x, y, z)			((y) ^ ((z) & ((x) ^ (y))))
#define H(x, y, z)			(((x) ^ (y)) ^ (z))
#define H2(x, y, z)			((x) ^ ((y) ^ (z)))
#define I(x, y, z)			((y) ^ ((x) | ~(z)))
 
/*
 * The MD5 transformation for all four rounds.
 */
#define STEP(f, a, b, c, d, x, t, s) \
	(a) += f((b), (c), (d)) + (x) + (t); \
	(a) = (((a) << (s)) | (((a) & 0xffffffff) >> (32 - (s)))); \
	(a) += (b);
 
/*
 * SET reads 4 input bytes in little-endian byte order and stores them
 * in a properly aligned word in host byte order.
 *
 * The check for little-endian architectures that tolerate unaligned
 * memory accesses is just an optimization.  Nothing will break if it
 * doesn't work.
 */
#if defined(__i386__) || defined(__x86_64__) || defined(__vax__)
#define SET(n) \
	(*(uint32_t *)&ptr[(n) * 4])
#define GET(n) \
	SET(n)
#else
#define SET(n) \
	(m_block[(n)] = \
	(uint32_t)ptr[(n) * 4] | \
	((uint32_t)ptr[(n) * 4 + 1] << 8) | \
	((uint32_t)ptr[(n) * 4 + 2] << 16) | \
	((uint32_t)ptr[(n) * 4 + 3] << 24))
#define GET(n) \
	(m_block[(n)])
#endif
 
/*
 * This processes one or more 64-byte data blocks, but does NOT update
 * the bit counters.  There are no alignment requirements.
 */
const uint8_t *CMD5::DoBody( const uint8_t *pData, uint32_t size)
{
	const uint8_t *ptr;
	uint32_t a, b, c, d;
	uint32_t saved_a, saved_b, saved_c, saved_d;
 
	ptr = (const uint8_t *)pData;
 
	a = m_a;
	b = m_b;
	c = m_c;
	d = m_d;
 
	do {
		saved_a = a;
		saved_b = b;
		saved_c = c;
		saved_d = d;
 
/* Round 1 */
		STEP(F, a, b, c, d, SET(0), 0xd76aa478, 7)
		STEP(F, d, a, b, c, SET(1), 0xe8c7b756, 12)
		STEP(F, c, d, a, b, SET(2), 0x242070db, 17)
		STEP(F, b, c, d, a, SET(3), 0xc1bdceee, 22)
		STEP(F, a, b, c, d, SET(4), 0xf57c0faf, 7)
		STEP(F, d, a, b, c, SET(5), 0x4787c62a, 12)
		STEP(F, c, d, a, b, SET(6), 0xa8304613, 17)
		STEP(F, b, c, d, a, SET(7), 0xfd469501, 22)
		STEP(F, a, b, c, d, SET(8), 0x698098d8, 7)
		STEP(F, d, a, b, c, SET(9), 0x8b44f7af, 12)
		STEP(F, c, d, a, b, SET(10), 0xffff5bb1, 17)
		STEP(F, b, c, d, a, SET(11), 0x895cd7be, 22)
		STEP(F, a, b, c, d, SET(12), 0x6b901122, 7)
		STEP(F, d, a, b, c, SET(13), 0xfd987193, 12)
		STEP(F, c, d, a, b, SET(14), 0xa679438e, 17)
		STEP(F, b, c, d, a, SET(15), 0x49b40821, 22)
 
/* Round 2 */
		STEP(G, a, b, c, d, GET(1), 0xf61e2562, 5)
		STEP(G, d, a, b, c, GET(6), 0xc040b340, 9)
		STEP(G, c, d, a, b, GET(11), 0x265e5a51, 14)
		STEP(G, b, c, d, a, GET(0), 0xe9b6c7aa, 20)
		STEP(G, a, b, c, d, GET(5), 0xd62f105d, 5)
		STEP(G, d, a, b, c, GET(10), 0x02441453, 9)
		STEP(G, c, d, a, b, GET(15), 0xd8a1e681, 14)
		STEP(G, b, c, d, a, GET(4), 0xe7d3fbc8, 20)
		STEP(G, a, b, c, d, GET(9), 0x21e1cde6, 5)
		STEP(G, d, a, b, c, GET(14), 0xc33707d6, 9)
		STEP(G, c, d, a, b, GET(3), 0xf4d50d87, 14)
		STEP(G, b, c, d, a, GET(8), 0x455a14ed, 20)
		STEP(G, a, b, c, d, GET(13), 0xa9e3e905, 5)
		STEP(G, d, a, b, c, GET(2), 0xfcefa3f8, 9)
		STEP(G, c, d, a, b, GET(7), 0x676f02d9, 14)
		STEP(G, b, c, d, a, GET(12), 0x8d2a4c8a, 20)
 
/* Round 3 */
		STEP(H, a, b, c, d, GET(5), 0xfffa3942, 4)
		STEP(H2, d, a, b, c, GET(8), 0x8771f681, 11)
		STEP(H, c, d, a, b, GET(11), 0x6d9d6122, 16)
		STEP(H2, b, c, d, a, GET(14), 0xfde5380c, 23)
		STEP(H, a, b, c, d, GET(1), 0xa4beea44, 4)
		STEP(H2, d, a, b, c, GET(4), 0x4bdecfa9, 11)
		STEP(H, c, d, a, b, GET(7), 0xf6bb4b60, 16)
		STEP(H2, b, c, d, a, GET(10), 0xbebfbc70, 23)
		STEP(H, a, b, c, d, GET(13), 0x289b7ec6, 4)
		STEP(H2, d, a, b, c, GET(0), 0xeaa127fa, 11)
		STEP(H, c, d, a, b, GET(3), 0xd4ef3085, 16)
		STEP(H2, b, c, d, a, GET(6), 0x04881d05, 23)
		STEP(H, a, b, c, d, GET(9), 0xd9d4d039, 4)
		STEP(H2, d, a, b, c, GET(12), 0xe6db99e5, 11)
		STEP(H, c, d, a, b, GET(15), 0x1fa27cf8, 16)
		STEP(H2, b, c, d, a, GET(2), 0xc4ac5665, 23)
 
/* Round 4 */
		STEP(I, a, b, c, d, GET(0), 0xf4292244, 6)
		STEP(I, d, a, b, c, GET(7), 0x432aff97, 10)
		STEP(I, c, d, a, b, GET(14), 0xab9423a7, 15)
		STEP(I, b, c, d, a, GET(5), 0xfc93a039, 21)
		STEP(I, a, b, c, d, GET(12), 0x655b59c3, 6)
		STEP(I, d, a, b, c, GET(3), 0x8f0ccc92, 10)
		STEP(I, c, d, a, b, GET(10), 0xffeff47d, 15)
		STEP(I, b, c, d, a, GET(1), 0x85845dd1, 21)
		STEP(I, a, b, c, d, GET(8), 0x6fa87e4f, 6)
		STEP(I, d, a, b, c, GET(15), 0xfe2ce6e0, 10)
		STEP(I, c, d, a, b, GET(6), 0xa3014314, 15)
		STEP(I, b, c, d, a, GET(13), 0x4e0811a1, 21)
		STEP(I, a, b, c, d, GET(4), 0xf7537e82, 6)
		STEP(I, d, a, b, c, GET(11), 0xbd3af235, 10)
		STEP(I, c, d, a, b, GET(2), 0x2ad7d2bb, 15)
		STEP(I, b, c, d, a, GET(9), 0xeb86d391, 21)
 
		a += saved_a;
		b += saved_b;
		c += saved_c;
		d += saved_d;
 
		ptr += 64;
	} while (size -= 64);
 
	m_a = a;
	m_b = b;
	m_c = c;
	m_d = d;
 
	return ptr;
}
 
void CMD5::InitDigest( void )
{
	m_a = 0x67452301;
	m_b = 0xefcdab89;
	m_c = 0x98badcfe;
	m_d = 0x10325476;
 
	m_lo = 0;
	m_hi = 0;
}
 
void CMD5::UpdateDigest( const uint8_t *pData, uint32_t size )
{
	uint32_t saved_lo;
	uint32_t used, available;
 
	saved_lo = m_lo;
	if ((m_lo = (saved_lo + size) & 0x1fffffff) < saved_lo)
		m_hi++;
	m_hi += size >> 29;
 
	used = saved_lo & 0x3f;
 
	if (used) 
	{
		available = 64 - used;
 
		if (size < available) 
		{
			memcpy(&m_buffer[used], (void *)pData, size);
			return;
		}
 
		memcpy(&m_buffer[used], (void *)pData, available);
		pData = (const uint8_t *)pData + available;
		size -= available;
		DoBody(m_buffer, 64);
	}
 
	if (size >= 64) 
	{
		pData = DoBody( pData, size & ~(uint32_t)0x3f);
		size &= 0x3f;
	}
 
	memcpy( m_buffer, (void *)pData, size );
}
 
void CMD5::GetDigest( uint8_t *pDest, uint32_t destLen )
{
	if ( destLen < 16 )
		return;

	uint32_t used, available;
 
	used = m_lo & 0x3f;
 
	m_buffer[used++] = 0x80;
 
	available = 64 - used;
 
	if ( available < 8 ) 
	{
		memset( &m_buffer[used], 0, available );
		DoBody( m_buffer, 64 );
		used = 0;
		available = 64;
	}

	memset( (m_buffer+used), 0, available - 8);
 
	m_lo <<= 3;
	m_buffer[56] = m_lo;
	m_buffer[57] = m_lo >> 8;
	m_buffer[58] = m_lo >> 16;
	m_buffer[59] = m_lo >> 24;
	m_buffer[60] = m_hi;
	m_buffer[61] = m_hi >> 8;
	m_buffer[62] = m_hi >> 16;
	m_buffer[63] = m_hi >> 24;
 
	DoBody( m_buffer, 64 );
 
	pDest[0] = m_a;
	pDest[1] = m_a >> 8;
	pDest[2] = m_a >> 16;
	pDest[3] = m_a >> 24;
	pDest[4] = m_b;
	pDest[5] = m_b >> 8;
	pDest[6] = m_b >> 16;
	pDest[7] = m_b >> 24;
	pDest[8] = m_c;
	pDest[9] = m_c >> 8;
	pDest[10] = m_c >> 16;
	pDest[11] = m_c >> 24;
	pDest[12] = m_d;
	pDest[13] = m_d >> 8;
	pDest[14] = m_d >> 16;
	pDest[15] = m_d >> 24;

	// Reset to zer0
	m_lo = m_hi = 0;
	m_a = m_b = m_c = m_d = 0;
	memset( m_buffer, 0, 64 );
	memset( m_block, 0, 16*sizeof(uint32_t) );
}
