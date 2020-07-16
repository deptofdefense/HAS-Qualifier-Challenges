/*******************************************************************************

This device simulates the power system controller.

Its memory is organized as follows:

uint32_t flags;
float    volts_rail_0;
float    volts_rail_1;
float    volts_rail_2;
...
float    volts_rail_n;

The lower bits of the flags register indicate whether the corresponding power
rail is turned on on off. (1: ON)

Each rail, when enabled, hovers around some bus-voltage-ish number, else
it hovers around zero.

I chose the following as rail voltages:

+1.8
+3.3  (EEPROM)
+5    (LEON3 OBC)
-5
+12
-12

The order of the rails in memory is randomized based on the seed associated
with the challenge

******************************************************************************/
#ifndef EPS_H
// ----------------------------------------------------------------------------
#define EPS_H
// ----------------------------------------------------------------------------
#include "I2CDevice.h"
// ----------------------------------------------------------------------------
extern     bool      g_eep_powered;

class Eps : public I2CDevice
{
  public:
    Eps(const char * dev_name, unsigned mem_len);

    uint8_t eepBit() {return m_eep_bit;};
    uint8_t obcBit() {return m_obc_bit;};
    bool    eepPowered() {return g_eep_powered;};
    bool    obcPowered() {return m_obc_powered;};

    virtual   ~Eps();
  protected:
    uint32_t  *m_flags;                 // points to bitflags
    float     *m_fp;                    // points to voltage rail array
    unsigned  m_shuf[EPS_NUM_RAILS];    // shuffled rail indices
    unsigned  m_unshuf[EPS_NUM_RAILS];  // complement of above
  private:
    void  wrote();
    float     jitter();
    void      refreshRailsArray();
    uint8_t   m_eep_bit;
    bool      m_obc_powered;
    uint8_t   m_obc_bit;
};
// ----------------------------------------------------------------------------
#endif // EPS_H
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
