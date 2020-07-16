#
#  RTEMS_MAKEFILE_PATH is typically set in an environment variable
#

PGM=${ARCH}/test_malloc.exe

# optional managers required
MANAGERS=all

# C source names
CSRCS = s_malloc.c test_malloc.c
ASOBJS = 
COBJS = $(CSRCS:%.c=${ARCH}/%.o)

include $(RTEMS_MAKEFILE_PATH)/Makefile.inc
include $(RTEMS_CUSTOM)
include $(PROJECT_ROOT)/make/leaf.cfg

CFLAGS_OPTIMIZE_V += -DTEST
OBJS= $(COBJS) $(CXXOBJS) $(ASOBJS)

all:    ${ARCH} $(PGM) 

$(PGM): $(OBJS)
	$(make-exe) 

