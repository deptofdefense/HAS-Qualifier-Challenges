/*******************************************************************************
Base class of I2C slave devices
******************************************************************************/
#include "I2CDevice.h"
#include "helpers.h"
// ----------------------------------------------------------------------------
#define TAG "DEV"
// ----------------------------------------------------------------------------
uint8_t g_slave_addresses[16];
unsigned g_num_slaves=0;
// ---------------------------------------------------------------------------
bool i2cSlaveAddressValid(uint8_t a)
{
  // if already taken, the address is invalid.
  for(unsigned i = 0; i<g_num_slaves;i++)
    if(g_slave_addresses[i]==a)
      return false;

  // if reserved by the i2c spec, it's invalid.
  if (
      (a==0b00000000)||    // gen call and start byte
      (a==0b00000010)||    // cbus address
      (a==0b00000100)||    // resv
      (a==0b00000110)
     )
    return false;
  unsigned ma = a&0b11111000;
  if(
      (ma==0b00001000)||  // hs-mode master
      (ma==0b11110000)||  // 10 bit slave addresses
      (ma==0b11111000)    // reserved
    )
    return false;

  return true;
}
// ---------------------------------------------------------------------------
void genRandomI2CAddress(uint8_t * dev_adrs)
{
  uint8_t adrs;
  while(true)
  {
    adrs = (rand()%256)&0xfe;
    if (i2cSlaveAddressValid(adrs))
    {
      *dev_adrs = adrs;
      g_slave_addresses[g_num_slaves++]=adrs;
      return;
    }
  }
}
// ---------------------------------------------------------------------------
I2CDevice::I2CDevice(const char * dev_name, unsigned mem_len):
  m_mem_len(mem_len),m_dev_name(dev_name)
{
  genRandomI2CAddress(&m_dev_adrs);
  m_mem_buf = (uint8_t *)malloc(m_mem_len);
  for(unsigned i=0;i<m_mem_len;i++)
    m_mem_buf[i]=rand()%256;
  _lw("*** Init device - \"%s\"",m_dev_name);
  _li("  i2c_adrs  : 0x%02x",m_dev_adrs);
  _li("  mem_len   : 0x%04x",m_mem_len);

  m_state=IDLE;
}
// ---------------------------------------------------------------------------
I2CDevice::~I2CDevice()
{
  _li("Freeing Device - \"%s\"",m_dev_name);
  free(m_mem_buf);
}
// ---------------------------------------------------------------------------
void I2CDevice::memDump()
{
  _lh("Contents", m_mem_buf, m_mem_len);
}
// ---------------------------------------------------------------------------
void I2CDevice::memDumpSegment(unsigned start, unsigned len)
{
  _lh("Read", m_mem_buf+start, len);
}
// ---------------------------------------------------------------------------
int I2CDevice::start()
{
  if(m_state==IDLE)
  {
    m_state=STARTED;
  }

  m_write=false;
  m_mem_adrs=0;
  m_byte_count = 0;

  return 0;
}
// ---------------------------------------------------------------------------
int I2CDevice::stop()
{
  if((m_state==XFER)&&m_write)
    wrote();
  m_state=IDLE;
  return 0;
}
// ---------------------------------------------------------------------------
t_i2c_flag I2CDevice::putByte(uint8_t b, uint8_t *rb)
{
  if(m_state==IDLE)
  {
    return NAK;
  } else if(m_state==STARTED)  // check if slave address is us
  {
    if((b&0xfe)==m_dev_adrs)
    {
      m_write=b&1;
      _lp("%s addressed. slave_id=0x%02x write=%d",m_dev_name,b&0xfe,m_write);
      m_state=ADRS0;
      m_mem_adrs=0;
      m_byte_count=0;
      fprint(b);
      return ACK;
    } else
    {
      m_state=IDLE;
      return NAK;
    }
  } else if (m_state==ADRS0)
  {
    m_mem_adrs=((unsigned)b)<<8;
    m_state=ADRS1;
    fprint(b);
    return ACK;
  } else if (m_state==ADRS1)
  {
    m_mem_adrs|=b;
    _lp("%s mem_adrs=0x%04x",m_dev_name,m_mem_adrs);
    m_state=XFER;
    if(m_mem_adrs>=m_mem_len)
      return NAK;
    fprint(b);
    return ACK;
  } else if(m_state==XFER)
  {
    unsigned eff_adrs = m_mem_adrs+m_byte_count;
    bool in_bounds = ((eff_adrs>=0)&&(eff_adrs<m_mem_len));
    if(m_write)
    {
      if(in_bounds)
      {
        *rb=b;
        m_mem_buf[eff_adrs]=b;
        fprint(*rb);
        m_byte_count++;
        return ACK;
      } else
      {
        return NAK;
      }

    } else
    {
      *rb=0;
      if(in_bounds)
      {
        *rb=m_mem_buf[eff_adrs];
        fprint(*rb);
        m_byte_count++;
        return ACK;
      } else
      {
        return NAK;
      }
    }


  }
  return NAK;
}

void  I2CDevice::wrote()
{

}

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
