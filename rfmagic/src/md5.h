#ifndef __MD5_H__
#define __MD5_H__

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
 * See md5.c for more information.
 */

// C++ wrapper class for this implementation

class CMD5
{
public:
	CMD5( ) { };
	~CMD5( ) { };

	void InitDigest( void );
	void UpdateDigest( const uint8_t *pData, uint32_t dataLen );
	void GetDigest( uint8_t *pDest, uint32_t destLen );

private:
	const uint8_t *DoBody( const uint8_t *pData, uint32_t size );

private:
	uint32_t m_lo, m_hi;
	uint32_t m_a, m_b, m_c, m_d;
	uint8_t m_buffer[64];
	uint32_t m_block[16];
};

#endif // __MD5_H__
