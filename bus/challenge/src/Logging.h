///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
#ifndef __LOGGING_H__
#define __LOGGING_H__

#define AE "\x1b["
#define DK "0;"
#define LT "1;"
#define aRST AE    "0m"
#define F_BK AE DK "30m"
#define F_RD AE DK "31m"
#define F_GN AE DK "32m"
#define F_YL AE DK "33m"
#define F_BU AE DK "34m"
#define F_MG AE DK "35m"
#define F_CY AE DK "36m"
#define F_WH AE DK "37m"
#define B_BK AE DK "40m"
#define B_RD AE DK "41m"
#define B_GN AE DK "42m"
#define B_YL AE DK "43m"
#define B_BU AE DK "44m"
#define B_MG AE DK "45m"
#define B_CY AE DK "46m"
#define B_WH AE DK "47m"
#define F_LBK AE LT "30m"
#define F_LRD AE LT "31m"
#define F_LGN AE LT "32m"
#define F_LYL AE LT "33m"
#define F_LBU AE LT "34m"
#define F_LMG AE LT "35m"
#define F_LCY AE LT "36m"
#define F_LWH AE LT "37m"
#define B_LBK AE LT "40m"
#define B_LRD AE LT "41m"
#define B_LGN AE LT "42m"
#define B_LYL AE LT "43m"
#define B_LBU AE LT "44m"
#define B_LMG AE LT "45m"
#define B_LCY AE LT "46m"
#define B_LWH AE LT "47m"

#ifdef LOG_ENABLE
  void _lg(const char * tag, const char *format, ...);
  void _lginit(const char * tag, const char *format, ...);
  void _lgexit(const char * tag, const char *format, ...);
  void _lgHex(const char * tag, const char * label, uint8_t * data, unsigned sz);
  #define _l(...) _lg(TAG,__VA_ARGS__)                    // log plain
  #define _le(...) _lg(TAG,F_LRD __VA_ARGS__)             // log err
  #define _lw(...) _lg(TAG,F_LYL __VA_ARGS__)             // log warning
  #define _li(...) _lg(TAG,F_LCY __VA_ARGS__)             // log info
  #define _lp(...) _lg(TAG,F_LGN __VA_ARGS__)             // log info
  #define _lh(...) _lgHex(TAG,__VA_ARGS__)                    // log plain
#else
  #define _l(...)
  #define _le(...)
  #define _lw(...)
  #define _li(...)
  #define _lp(...)
  #define _lh(...)
  #define _l(...)
  #define _lg(...)
  #define _lgv(...)
  #define _lginit(...)
  #define _lgexit(...)
  #define _lgHex(...)
#endif

#endif
///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
