/*******************************************************************************
******************************************************************************/

#ifndef __I2CDEVICE_H__
#define __I2CDEVICE_H__

#include "common.h"

extern uint8_t g_slave_addresses[16];
extern unsigned g_num_slaves;

typedef enum {
  ACK=0,
  NAK
} t_i2c_flag;

typedef enum {
  IDLE=0,
  STARTED,
  ADRS0,
  ADRS1,
  XFER
} t_i2c_state;

typedef enum {
  MEM_READ=0,
  MEM_WRITE
} t_i2c_rw;
class I2CDevice
{
  public:
    I2CDevice(const char * dev_name, unsigned mem_len);
    virtual       ~I2CDevice();
    uint8_t       *buf() {return m_mem_buf;};
    unsigned      len() {return m_mem_len;};
    const char    *name() {return m_dev_name;};
    unsigned      devAdrs() {return m_dev_adrs;};
    void          memDump();
    void          memDumpSegment(unsigned start, unsigned len);
    virtual int   start();
    int           stop();
    t_i2c_flag    putByte(uint8_t b, uint8_t *rb);
    virtual void  wrote();
  protected:
    unsigned      m_mem_len;
    uint8_t       *m_mem_buf;
    t_i2c_state   m_state;
    bool          m_write;
    uint8_t       m_mem_adrs;
    unsigned      m_byte_count;
  private:
    const char    *m_dev_name;
    uint8_t       m_dev_adrs;
};

#endif // __I2CDEVICE_H__
