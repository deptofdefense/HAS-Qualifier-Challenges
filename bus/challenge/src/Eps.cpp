/*******************************************************************************
This device simulates the power system controller.

See Eps.h for more info.
******************************************************************************/
#include "Eps.h"
// ----------------------------------------------------------------------------
#define TAG "EPS"
// ----------------------------------------------------------------------------
bool g_eep_powered;
// ----------------------------------------------------------------------------
float Eps::jitter()
{
  double pm1 = ((double)rand()*2.0/(double)RAND_MAX)-1.0; // [-1.0 ... 1.0]
  return pm1 * 0.04;
}
// ----------------------------------------------------------------------------
// refresh voltage rails array
// ----------------------------------------------------------------------------
void Eps::refreshRailsArray()
{
  unsigned i,j;
  for(i=0;i<EPS_NUM_RAILS;i++)  // for each rail,
  {
    j=m_shuf[i];
    float v = 0;            // if disabled, set to around zero
    if ((*m_flags)&(1<<j))  // if enabled, set to normal rail voltage
      v=EPS_RAIL_VALS[i];
    v+=jitter();            // with a little bit of jitter.
    if(i==EPS_EEP_IDX)
    {
      m_eep_bit = 1<<j;
      g_eep_powered = v>1.0;
    } else if(i==EPS_OBC_IDX)
    {
      m_obc_powered = v>1.0;
      m_obc_bit = 1<<j;
    }
    m_fp[j]=v;
  }
  #ifdef LOG_ENABLE
  for(i=0;i<EPS_NUM_RAILS;i++)
  {
    j=m_unshuf[i];
    _li("  Rail %2u: %0.2fV %s",i,m_fp[i],(j==1)?"(EEPROM)":(j==2)?"(OBC)":"");
  }
  _li("  Power states:");
  _li("    OBC     : %s",(m_obc_powered)?"ON":"OFF");
  _li("    EEPROM  : %s",(g_eep_powered)?"ON":"OFF");
  #endif
}
// ----------------------------------------------------------------------------
Eps::Eps(const char * dev_name, unsigned mem_len):
  I2CDevice(dev_name,mem_len)
{
  unsigned i,j,b;

  // +1.8
  // +3.3  (EEPROM)
  // +5    (LEON3 OBC)
  // -5
  // +12
  // -12

  // currently shuffling the order of these based on seed.
  // maybe it would be better not to.

  m_flags = (uint32_t *)m_mem_buf;
  m_fp = (float *)(m_mem_buf+4);

  // shuffle voltage rail positions

  for(i=0;i<EPS_NUM_RAILS;i++)
    m_shuf[i]=i;

  for (i = EPS_NUM_RAILS - 1; i > 0; i--)
  {
    j = rand() % (i + 1);
    b = m_shuf[i];
    m_shuf[i]=m_shuf[j];
    m_shuf[j]=b;
  }

  // make a deshuffler index
  for(i=0;i<EPS_NUM_RAILS;i++)
    m_unshuf[m_shuf[i]]=i;

  // init rail enable flags with
  // everything but EEP turned on initially

  uint32_t flags_init_unshuffled = 0b00000000000000000000000000111101;

  // shuffle those
  *m_flags = 0b00000000000000000000000000000000;
  for(i=0;i<EPS_NUM_RAILS;i++)
  {
    j=m_shuf[i];
    if(flags_init_unshuffled&(1<<i))
      *m_flags|=(1<<j);
  }

  refreshRailsArray();

  memDump();

}
// ----------------------------------------------------------------------------
Eps::~Eps()
{
}


void Eps::wrote()
{
  refreshRailsArray();
}

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
