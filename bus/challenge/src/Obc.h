#ifndef OBC_H
#define OBC_H

#include "I2CDevice.h"

class Obc : public I2CDevice
{
  public:
    Obc(const char * dev_name, unsigned mem_len);
    virtual ~Obc();

  protected:

  private:
    void  wrote();

};

#endif // OBC_H
