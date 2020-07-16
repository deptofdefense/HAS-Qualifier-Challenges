#ifndef __XCORR_H__
#define __XCORR_H__

void xcorr(int16_t *tr1, int16_t *tr2, double *corp, int shift, int shift_zero,
           int twosided, int demean, int ndat1, int ndat2);

#endif // __XCOR_H__
