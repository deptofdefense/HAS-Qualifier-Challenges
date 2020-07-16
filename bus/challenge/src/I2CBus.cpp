#include "I2CBus.h"
// ----------------------------------------------------------------------------
#define TAG "BUS"
// ----------------------------------------------------------------------------
I2CBus::I2CBus()
{
  m_num_devs=0;
  m_in_xfer=false;
  m_reading=false;
}

I2CBus::~I2CBus()
{
  for(unsigned i=0;i<m_num_devs;i++)
    delete(m_devices[i]);
}

void I2CBus::addDevice(I2CDevice * device)
{
  _li("** Adding \"%s\" to bus.",device->name());
  m_devices[m_num_devs++]=device;
}

int I2CBus::start()
{
  for(unsigned i=0;i<m_num_devs;i++)
  {
    m_devices[i]->start();
  }
  if(m_in_xfer)
    fprint("^^");
  else
    fprint("^");
  m_in_xfer=true;
  return 0;
}

t_i2c_flag I2CBus::putByte(uint8_t b, uint8_t * rb)  // returns ack or nak
{

  struct timespec tm;
  tm.tv_sec = 0;
  tm.tv_nsec = 40000000;
  nanosleep(&tm,NULL);
  for(unsigned i=0;i<m_num_devs;i++)
  {
    if(m_devices[i]->putByte(b,rb)==ACK)
    {
      fprint("+");
      return ACK;
    }
  }
  fprint(b);
  fprint("-");
  return NAK;
}

int I2CBus::stop()
{
  for(unsigned i=0;i<m_num_devs;i++)
  {
    m_devices[i]->stop();
  }
  if(m_in_xfer)
  {
    fprint(".");
    m_in_xfer=false;
    return 0;
  }
  fprint("!");
  return -1;
}
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
