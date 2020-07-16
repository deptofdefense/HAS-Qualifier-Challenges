/**
 * @file aes.h
 * @brief AES (Advanced Encryption Standard)
 *
 * @section License
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 *
 * Copyright (C) 2010-2019 Oryx Embedded SARL. All rights reserved.
 *
 * This file is part of CycloneCrypto Open.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 * @author Oryx Embedded SARL (www.oryx-embedded.com)
 * @version 1.9.6
 **/

#ifndef _AES_H
#define _AES_H

//Dependencies
//#include "core/crypto.h"
#include <stdint.h>
#include <stdlib.h>

//AES block size
#define AES_BLOCK_SIZE 16
//Common interface for encryption algorithms
#define AES_CIPHER_ALGO (&aesCipherAlgo)

#define LOAD32LE(p) ( \
    ((uint32_t)(((uint8_t *)(p))[0]) << 0) | \
    ((uint32_t)(((uint8_t *)(p))[1]) << 8) | \
    ((uint32_t)(((uint8_t *)(p))[2]) << 16) | \
    ((uint32_t)(((uint8_t *)(p))[3]) << 24))

#define STORE32LE(a, p) \
    ((uint8_t *)(p))[0] = ((uint32_t)(a) >> 0) & 0xFFU, \
    ((uint8_t *)(p))[1] = ((uint32_t)(a) >> 8) & 0xFFU, \
    ((uint8_t *)(p))[2] = ((uint32_t)(a) >> 16) & 0xFFU, \
    ((uint8_t *)(p))[3] = ((uint32_t)(a) >> 24) & 0xFFU
  
#define ROL32(a, n) (((a) << (n)) | ((a) >> (32 - (n))))


//C++ guard
#ifdef __cplusplus
extern "C" {
#endif

  typedef int error_t;
#define NO_ERROR 0
#define ERROR_INVALID_PARAMETER 1
#define ERROR_INVALID_KEY_LENGTH 2
  /**
   * @brief AES algorithm context
   **/


  typedef struct
  {
    uint32_t nr;
    uint32_t ek[60];
    uint32_t dk[60];
  } AesContext;


  //AES related constants
//  extern const CipherAlgo aesCipherAlgo;

  //AES related functions
  error_t aesInit(AesContext *context, const uint8_t *key, size_t keyLen);
  void aesEncryptBlock(AesContext *context, const uint8_t *input, uint8_t *output);
  void aesDecryptBlock(AesContext *context, const uint8_t *input, uint8_t *output);

  //C++ guard
#ifdef __cplusplus
}
#endif

#endif
