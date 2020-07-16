#ifndef EEPROM_H
#define EEPROM_H

#include "I2CDevice.h"

class Eeprom : public I2CDevice
{
  public:
    Eeprom(const char * dev_name, unsigned mem_len, char * flag);
    virtual ~Eeprom();
    virtual void init();
    unsigned adrsNotFlag(unsigned len_to_read);
    int start();

  protected:

  private:
    void  wrote();
    unsigned  m_flag_adrs;
    unsigned  m_flag_len;
    unsigned  m_pre,m_post;     // lens of eeprom preceding and succeeding the flag

};

#endif // EEPROM_H
