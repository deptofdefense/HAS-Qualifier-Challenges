#CC           = avr-gcc
#CFLAGS       = -Wall -mmcu=atmega16 -Os -Wl,-Map,test.map
#OBJCOPY      = avr-objcopy
CC           = gcc
LD           = gcc
AR           = ar
ARFLAGS      = rcs
CFLAGS       = -Wall -O3 -c -g
LDFLAGS      = -Wall -O3 -g

default: chal.exe

.SILENT:
.PHONY:  lint clean benchmark

chal.o : chal.c aes.h aes.o
	echo [CC] $@ $(CFLAGS)
	$(CC) $(CFLAGS) -o  $@ $<

aes.o : aes.c aes.h
	echo [CC] $@ $(CFLAGS)
	$(CC) $(CFLAGS) -o $@ $<

cache.o : cache.c 
	echo [CC] $@ $(CFLAGS)
	$(CC) $(CFLAGS) -o $@ $<

chal.exe : chal.o aes.o cache.o
	echo [LD] $@
	$(LD) $(LDFLAGS) -o $@ $^

clean:
	rm -f *.o *.exe
