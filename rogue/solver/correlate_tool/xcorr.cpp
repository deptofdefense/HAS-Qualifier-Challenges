/*--------------------------------------------------------------------
# Filename: xcorr.c
#  Purpose: Cross correlation in time domain
#  Author: Tom Richter
#  a lot of staff (normalization, calloc commands, ...) copy & pasted from
#  Obspy's xcorr.c (Hansruedi Maurer, Joachim Wassermann)
# Copyright (C) 2011 T. Richter - GNU GPL 3
#---------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <memory.h>

int min ( int a, int b ) {
  return (a<=b)?a:b;
}
int max ( int a, int b ) {
  return (a>=b)?a:b;
}

void xcorr(int16_t *tr1, int16_t *tr2, double *corp, int shift, int shift_zero,
           int twosided, int demean, int ndat1, int ndat2)
/*
Calculates the cross-correlation of data arrays tr1 and tr2.
The data is demeaned before. This means it makes a difference if zeros are
padded beforehand or not. The result is normalized.
input:
tr1, tr2:   data arrays with length ndat1, ndat2
shift:      shift by this amount
shift_zero: before cross-correlation the first data array is right-shifted
            by that amount of samples
            (The effect is a right-shift of the correlation function.)
twosided:   0 or 1. if 0 only the positive (right) side of the correlation
            function is returned
            (usefull for auto-correlation)
demean:     0 or 1. if 0 the data is not demeand
output:
corp: xcorrelation of length (twosided+1)*shift+1
*/
{
    int a, a2, b;
    double sum1;
    double sum2;
    float *tra1;
    float *tra2;
    int flag=0;
    int indadd;
    int bmin;
    int bmax;
    double cmax;
    double sum;
    int aind = (1-twosided) * shift;

    /*int nmax;
    nmax = max(ndat1, ndat2);
    nmax = max(nmax, min(ndat1, ndat2) + 2*shift);
    printf("%d", nmax);*/

    tra1 = new float[ndat1];
    tra2 = new float[ndat2];

    /*if (shift > (ndat1 + ndat2)/2)
    {
        printf("Warning!  Window is HUGE! ");
    }*/
    /*if (shift > fabs(ndat1 - ndat2)/2 )
    {
        printf("Zero padding ");
    }*/

    /* Demean data if demean >0 (Zero offset) */
    sum = 0;
    if (demean>0)
    {
        for (a=0;a<ndat1;a++)
        {
            sum += tr1[a];
        }
        sum /= ndat1;
        for (a=0;a<ndat1;a++)
        {
            tra1[a] = tr1[a] - (float)sum;
        }
        if(sum == 0.0)
            flag = 1;
        sum = 0;
        for (a=0;a<ndat2;a++)
        {
            sum += tr2[a];
        }
        sum /= ndat2;
        for (a=0;a<ndat2;a++)
        {
            tra2[a] = tr2[a] - (float)sum;
        } 
        if(sum == 0.0)
            flag += 1;
    }
    else
    {
        for (a=0;a<ndat1;a++)
        {
            tra1[a] = tr1[a];
        } 
        for (a=0;a<ndat2;a++)
        {
            tra2[a] = tr2[a];
        } 
    }
        
        
    /* Normalizing the traces  (max amp = 1) */        
    cmax = 0;        
    for (a=0;a<ndat1;a++)
    {
        if (fabs(tra1[a]) > cmax)
        {
            cmax = fabs(tra1[a]);
        }
    }
    for (a=0;a<ndat1;a++)
    {
        tra1[a] = tra1[a]/(float)cmax;
    }
    cmax = 0;

    for (a=0;a<ndat2;a++)
    {
        if (fabs(tra2[a]) > cmax)
        {
            cmax = fabs(tra2[a]);
        }
    }
    for (a=0;a<ndat2;a++)
    {
        tra2[a] = tra2[a]/(float)cmax;
    }

    /* xcorr ... */
    //printf("%d\n", flag);
    //printf("%d %d %d %d %d\n", ndat1, ndat2, shift, len, delta);
   
    
    if(flag == 0)
    {
         if (ndat1 >= ndat2)
         {
            indadd = (ndat1 - ndat2) / 2 - shift;
            a2 = aind - shift_zero + indadd;
            for (a=0;a<(2*shift+1-aind);a++, a2++)
            {
                bmin = max(0, -a2);
                bmax = min(ndat2, ndat1-a2);
                //printf("BMIN:BMAX:: %d:%d\n", bmin, bmax);
                corp[a]= 0;
                for (b=bmin;b<bmax;b++)
                {
                    corp[a] += tra1[b+a2]*tra2[b];
                }   
            }           
         }
         else
         {  // same as for ndat1 >= ndat2, only replaced as following:
            // ndat1 <-> ndat2, tra1 <-> tra2, corp[a]->corp[2*shift-a]
#if 0
            indadd = (ndat2 - ndat1) / 2 - shift;
            a2 = shift_zero + indadd;
            for (a=0;a<(2*shift+1-aind);a++,a2++)
            {
                bmin = max(0, -a2);
                bmax = min(ndat1, ndat2-a2);
                //printf("%d %d\n", bmin, bmax);
                corp[2*shift-a-aind]= 0;
                for (b=bmin;b<bmax;b++)
                {
                    corp[2*shift-a-aind] += tra2[b+a2]*tra1[b];
                }   
            }
#endif
            for ( a=0; a<(shift+1); a++ )
	    {
		corp[a] = 0;
                for ( b=0; b<ndat1; b++ )
		{
                    corp[a] += tra1[b] * tra2[b+a];
		}
	    }	    
         }
	
#if 0 
	 a2 = 0;
	 for ( a=0; a <shift+1; a++, a2++ )
	 {
		bmin = max( 0, a2 );
		bmax = min(ndat2, ndat1+a2);
		//printf( "BMIN:BMAX:: %d:%d\n", bmin, bmax );
		corp[a] = 0.0;

		for ( b = bmin; b < bmax; b++ )
		{
			corp[a] += tra1[b+a2] * tra2[b];
		}
	 }
#endif


        /* normalize xcorr function */
        sum1 = sum2 = 0.0;        
        for(a=0; a<ndat1;a++)
        {
            sum1 += (*(tra1+a))*(*(tra1+a));
        }
        for(a=0; a<ndat2;a++)
        {
            sum2 += (*(tra2+a))*(*(tra2+a));
        }
        sum1 = sqrt(sum1);
        sum2 = sqrt(sum2);
        cmax = 1/(sum1*sum2);
        for (a=0;a<(2*shift+1-aind);a++)
        {
            corp[a] *= cmax;
        }

        /*cmax = 0;
        shift_max = 1;
        for (a=0;a<(2*shift+1-aind);a++)
        {
            if (fabs(corp[a]) > cmax)
            {
                cmax = fabs(corp[a]);
                shift_max = a;
            }
        }
        corp_max = corp[shift_max];
        shift_max = shift_max - shift - 1 + aind;*/
    }
    else
    {
        for (a=0;a<(2*shift+1-aind);a++)
        {
            corp[a]=0;
            //shift_max = 0;
            //corp_max = 0;
        }
    }

    delete []tra1;
    delete []tra2;
}
