CC=mips-linux-gnu-gcc
AS=mips-linux-gnu-gcc
CXX=mips-linux-gnu-gcc

LINKER_SCRIPT=ld.script

TARGET ?= a.out

BUILD_DIR ?= ./build
SRC_DIRS ?= ./

SRCS := rll.cc \
	common.cc \
	messagequeue.cc \
	rrl.cc \
	timeframe.cc \
	md5.cc \
	lib_cpp/cpp.cc \
	pdupool.cc \
	lib/prng.c \
	lib/new_printf.c \
	lib/malloc.c \
	lib/memcmp.c \
	lib/stdlib.c \
	doublelist.cc \
	mac.cc \
	cioconnection.cc \
	main.cc

OBJS := $(SRCS:%=%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
LIB_INC_DIR := lib/ lib_cpp/
LIB_INC_FLAGS := $(addprefix -L ,$(LIB_INC_DIR))
INC_FLAGS := $(addprefix -I,$(INC_DIRS)) $(addprefix -isystem , $(LIB_INC_DIR))

ASFLAGS ?= $(INC_FLAGS) -EL -march=r3000 -mfp32 -fno-exceptions -fno-pic -mno-abicalls -ffreestanding -nostdinc -Os
CPPFLAGS ?= $(INC_FLAGS) -EL -march=r3000 -mfp32 -fno-exceptions -fno-pic -mno-abicalls -ffreestanding -nostdinc -MMD -MP -Os
CXXFLAGS ?= $(INC_FLAGS) -EL -march=r3000 -mfp32 -fno-exceptions -fno-pic -mno-abicalls -ffreestanding -nostdinc -Os
LDFLAGS ?= -EL -march=r3000 -mfp32 -fno-exceptions -fno-pic -mno-abicalls -ffreestanding -nostdinc -nostdlib -Os

$(TARGET): $(OBJS) setup.S.o
	$(CC) -T $(LINKER_SCRIPT) $(LIB_INC_FLAGS) -l mylibc -l mylibc++ setup.S.o $(OBJS) -o $@ $(LDFLAGS)

# assembly
%.S.o: %.S
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
%.cc.o: %.cc
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean

clean:
	$(RM) *.o *.d $(TARGET)

.PHONY: rom
rom:
	mips-linux-gnu-objcopy -O binary $(TARGET) $(TARGET).rom

-include $(DEPS)

MKDIR_P ?= mkdir -p


#all:
#mips-linux-gnu-gcc -EL -march=r3000 -mfp32 -fno-pic -mno-abicalls -ffreestanding -T ld.script setup.S echo.c -o echo
#	mips-linux-gnu-gcc -EL -march=r3000 -mfp32 -fno-pic -mno-abicalls -ffreestanding -nostartfiles -nostdlib -fno-builtin -T ld.script setup.S echo.c -o echo
#	mips-linux-gnu-objcopy -O binary echo

