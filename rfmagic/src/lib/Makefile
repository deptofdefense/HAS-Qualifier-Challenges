CC=mips-linux-gnu-gcc
AS=mips-linux-gnu-gcc
CXX=mips-linux-gnu-gcc
AR=mips-linux-gnu-ar

TARGET ?= libmylibc.a

BUILD_DIR ?= ./build/
SRC_DIRS ?= ./

SRCS := malloc.c  memcmp.c  new_printf.c  prng.c  stdlib.c
OBJS := $(SRCS:%=%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

ASFLAGS ?= $(INC_FLAGS) -EL -march=r3000 -mfp32 -fno-exceptions -fno-pic -mno-abicalls -ffreestanding -nostdinc
CPPFLAGS ?= $(INC_FLAGS) -EL -march=r3000 -mfp32 -fno-exceptions -fno-pic -mno-abicalls -ffreestanding -nostdinc -MMD -MP
CXXFLAGS ?= $(INC_FLAGS) -EL -march=r3000 -mfp32 -fno-exceptions -fno-pic -mno-abicalls -ffreestanding -nostdinc
LDFLAGS ?= -EL -march=r3000 -mfp32 -fno-exceptions -fno-pic -mno-abicalls -ffreestanding -nostdinc -nostdlib

$(TARGET): $(OBJS)
	$(AR) rcs $(TARGET) $(OBJS)

# assembly
%.S.o: %.S
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
%.c.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

.PHONY: clean

clean:
	$(RM) *.o *.d $(TARGET)

-include $(DEPS)


#all:
#mips-linux-gnu-gcc -EL -march=r3000 -mfp32 -fno-pic -mno-abicalls -ffreestanding -T ld.script setup.S echo.c -o echo
#	mips-linux-gnu-gcc -EL -march=r3000 -mfp32 -fno-pic -mno-abicalls -ffreestanding -nostartfiles -nostdlib -fno-builtin -T ld.script setup.S echo.c -o echo
#	mips-linux-gnu-objcopy -O binary echo

