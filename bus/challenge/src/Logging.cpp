///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
#include "common.h"
// ----------------------------------------------------------------------------
#ifdef LOG_ENABLE
// ----------------------------------------------------------------------------
pthread_mutex_t mtx_log;
// ----------------------------------------------------------------------------
void _lg(const char * tag, const char *format, ...)
{
  va_list args;
  time_t t;
  struct tm tmp;
  t = time(NULL);
  localtime_r(&t,&tmp);
  pthread_mutex_lock(&mtx_log);
  printf( F_WH "%02d%02d%02d" F_LWH "%02d%02d%02d %s %s",
          (tmp.tm_year+1900)%100, tmp.tm_mon+1, tmp.tm_mday, tmp.tm_hour,
          tmp.tm_min, tmp.tm_sec, tag,
          F_WH);
  va_start(args, format);
  vprintf(format, args);
  va_end(args);
  printf("\r\n");
  pthread_mutex_unlock(&mtx_log);
}
// ----------------------------------------------------------------------------
void _lginit(const char * tag, const char *format, ...)
{
  pthread_mutex_init(&mtx_log, NULL);
  va_list args;
  time_t t;
  struct tm tmp;
  t = time(NULL);
  localtime_r(&t,&tmp);
  pthread_mutex_lock(&mtx_log);
  printf( F_WH "%02d%02d%02d" F_LWH "%02d%02d%02d %s " F_LWH ,(tmp.tm_year+1900)%100,
          tmp.tm_mon+1, tmp.tm_mday, tmp.tm_hour, tmp.tm_min, tmp.tm_sec, tag);
  va_start(args, format);
  vprintf(format, args);
  va_end(args);
  printf("\r\n");
  pthread_mutex_unlock(&mtx_log);
}
// ----------------------------------------------------------------------------
void _lgexit(const char * tag, const char *format, ...)
{
  va_list args;
  time_t t;
  struct tm tmp;
  t = time(NULL);
  localtime_r(&t,&tmp);
  pthread_mutex_lock(&mtx_log);
  printf( F_WH "%02d%02d%02d" F_LWH "%02d%02d%02d %s " F_LWH,(tmp.tm_year+1900)%100,
          tmp.tm_mon+1, tmp.tm_mday, tmp.tm_hour, tmp.tm_min, tmp.tm_sec, tag);
  va_start(args, format);
  vprintf(format, args);
  va_end(args);
  printf("\r\n");
  pthread_mutex_unlock(&mtx_log);
  pthread_mutex_destroy(&mtx_log);
}
// ----------------------------------------------------------------------------
void _lgHex(const char * TAG, const char * label, uint8_t * data, unsigned sz)
{
  char lbuf[80]="",abuf[17]="",wbuf[16],cbuf[2],bc=0;
  unsigned a=0;

  _l(F_LWH "*** %s: ",label);
  for(unsigned b=0;b<sz;b++)
  {
    uint8_t c=data[b];
    sprintf(wbuf,"%02x",c);
    strcat(lbuf,wbuf);
    if((c>=32)&&(c<=126))
      sprintf(cbuf,"%c",c);
    else
      sprintf(cbuf,".");
    strcat(abuf,cbuf);
    if(++bc==16)
    {
      _l(  F_LCY "%04x: " F_CY "%s " F_LCY "%s",
            a, lbuf, abuf);
      a+=16;
      bc=0;
      lbuf[0]=0;
      abuf[0]=0;
    }
  }
  if(bc)
  {
    uint8_t sbuf[33]="                                ";
    sbuf[32-bc*2]=0;
    _l(  F_LCY "%04x: " F_CY "%s%s " F_LCY "%s",
          a, lbuf, sbuf,abuf);
  }
}
// ----------------------------------------------------------------------------
#endif
// ----------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////

