#
#  RTEMS_MAKEFILE_PATH is typically set in an environment variable
#

PGM=${ARCH}/challenge.exe

# optional managers required
MANAGERS=all

# C source names
CSRCS = chal.c io.c crc.c s_malloc.c msglib.c mission.c
ASOBJS = 
COBJS = $(CSRCS:%.c=${ARCH}/%.o)

include $(RTEMS_MAKEFILE_PATH)/Makefile.inc
include $(RTEMS_CUSTOM)
include $(PROJECT_ROOT)/make/leaf.cfg

OBJS= $(COBJS) $(CXXOBJS) $(ASOBJS)
LDFLAGS += -Wl,-u -Wl,flag -Wl,-s
CFLAGS_OPTIMIZE_V = -O0 -g -ffunction-sections -fdata-sections

all:    ${ARCH} $(PGM) 

$(PGM): $(OBJS)
	$(make-exe) 

