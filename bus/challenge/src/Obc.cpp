#include "Obc.h"
// ----------------------------------------------------------------------------
#define TAG "OBC"
// ----------------------------------------------------------------------------

Obc::Obc(const char * dev_name, unsigned mem_len):I2CDevice(dev_name,mem_len)
{
}

Obc::~Obc()
{
  //dtor
}


void Obc::wrote()
{
}
