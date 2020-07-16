#include "Eeprom.h"
#include "Eps.h"

#define TAG "EEP"

Eeprom::Eeprom(const char * dev_name, unsigned mem_len, char * flag):I2CDevice(dev_name,mem_len)
{
  for(unsigned i=0;i<m_mem_len;i+=64)
  {
    char jbuf[16];
    sprintf(jbuf,"Juicy Data %02x",i/64);
    strcpy((char *)(m_mem_buf+i),jbuf);
  }

  char fbuf[160];
  //strcpy(fbuf,"FLAG{");
  //strcat(fbuf,flag);
  //strcat(fbuf,"}");
  strcpy(fbuf,flag);
  m_flag_len = strlen(fbuf)+1;
  m_flag_adrs = rand()%(m_mem_len-m_flag_len);
  m_pre = m_flag_adrs;
  m_post = m_mem_len-(m_flag_adrs+m_flag_len);
  strcpy((char *)(m_mem_buf+m_flag_adrs),fbuf);

  _li("  flag_adrs : 0x%04x",m_flag_adrs);
  _li("  flag_len  : 0x%02x",m_flag_len);
  _li("  flag_pre  : 0x%04x",m_pre);
  _li("  flag_post : 0x%04x",m_post);
  memDump();
}

Eeprom::~Eeprom()
{
  //dtor
}

void Eeprom::init()
{
}

void Eeprom::wrote()
{
}

// ---------------------------------------------------------------------------
int Eeprom::start()
{
  if(m_state==IDLE)
  {
    if(g_eep_powered)
      m_state=STARTED;
  }

  m_write=false;
  m_mem_adrs=0;
  m_byte_count = 0;

  return 0;
}

// pick a random address to read that doesnt
// reveal the flag
unsigned Eeprom::adrsNotFlag(unsigned len_to_read)
{
  bool gotone=false;
  unsigned res;
  if((len_to_read<=m_pre)&&(len_to_read<=m_post)) // theres room before and after the flag for this read
  {
    gotone=true;
    if(rand()%2)
    {
      res = rand()%(m_pre-len_to_read);
    }
    else
    {
      res = rand()%(m_post-len_to_read)+(m_flag_adrs+m_flag_len);
    }
  } else if (len_to_read<=m_pre)  // theres only room before the flag
  {
    gotone=true;
    res=rand()%(m_pre-len_to_read);
  } else // theres only room after the flag
  {
    gotone=true;
    res=rand()%(m_post-len_to_read)+(m_flag_adrs+m_flag_len);
  }
  if(!gotone)
  {
    printf("CRASH. ADRS_NOT_FLAG");
    while(1);
  }
  _lw("Read EEP adrs: 0x%04x",res);
  return res;
}
