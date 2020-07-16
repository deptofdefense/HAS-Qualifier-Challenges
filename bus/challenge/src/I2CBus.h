#ifndef __I2CBUS_H__
#define __I2CBUS_H__

#include "I2CDevice.h"

class I2CBus
{
  public:
    I2CBus();
    virtual ~I2CBus();
    void addDevice(I2CDevice * device);
    int start();
    t_i2c_flag putByte(uint8_t b, uint8_t * rb);
    int stop();
  protected:

  private:
    unsigned      m_num_devs;
    I2CDevice     *m_devices[16];
    bool          m_in_xfer;
    bool          m_reading;
};

#endif // __I2CBUS_H__
