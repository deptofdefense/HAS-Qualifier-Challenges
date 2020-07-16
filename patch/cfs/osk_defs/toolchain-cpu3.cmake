# This example toolchain file describes the cross compiler to use for
# the target architecture indicated in the configuration file.

# Basic cross system configuration
set(CMAKE_SYSTEM_NAME       RTEMS)
set(CMAKE_SYSTEM_PROCESSOR  sparc)
set(CMAKE_SYSTEM_VERSION    5)
set(RTEMS_TOOLS_PREFIX      "/opt/rtems/${CMAKE_SYSTEM_VERSION}")
set(RTEMS_BSP_PREFIX        "/opt/rtems/${CMAKE_SYSTEM_VERSION}")
set(RTEMS_BSP               leon3)

# specify the cross compiler - adjust accord to compiler installation
# This uses the compiler-wrapper toolchain that buildroot produces
set(TARGET_PREFIX           "${CMAKE_SYSTEM_PROCESSOR}-rtems${CMAKE_SYSTEM_VERSION}-")
#set(CPUTUNEFLAGS            "-msoft-float")

SET(CMAKE_C_COMPILER        "${RTEMS_TOOLS_PREFIX}/bin/${TARGET_PREFIX}gcc")
SET(CMAKE_CXX_COMPILER      "${RTEMS_TOOLS_PREFIX}/bin/${TARGET_PREFIX}g++")
SET(CMAKE_LINKER            "${RTEMS_TOOLS_PREFIX}/bin/${TARGET_PREFIX}ld")
SET(CMAKE_ASM_COMPILER      "${RTEMS_TOOLS_PREFIX}/bin/${TARGET_PREFIX}as")
SET(CMAKE_STRIP             "${RTEMS_TOOLS_PREFIX}/bin/${TARGET_PREFIX}strip")
SET(CMAKE_NM                "${RTEMS_TOOLS_PREFIX}/bin/${TARGET_PREFIX}nm")
SET(CMAKE_AR                "${RTEMS_TOOLS_PREFIX}/bin/${TARGET_PREFIX}ar")
SET(CMAKE_OBJDUMP           "${RTEMS_TOOLS_PREFIX}/bin/${TARGET_PREFIX}objdump")
SET(CMAKE_OBJCOPY           "${RTEMS_TOOLS_PREFIX}/bin/${TARGET_PREFIX}objcopy")

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM   NEVER)

# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY   ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE   ONLY)

SET(CMAKE_PREFIX_PATH                   /)

# these settings are specific to cFE/OSAL and determines which
# abstraction layers are built when using this toolchain
SET(CFE_SYSTEM_PSPNAME                  leon3-rtems)
SET(OSAL_SYSTEM_BSPTYPE                 sis-rtems)
SET(OSAL_SYSTEM_OSTYPE                  rtems)
SET(CMAKE_EXE_EXPORTS_C_FLAG "-Wl,--export-dynamic")
#SET(RTEMS_RELOCADDR "0x4000000")
SET(RTEMS_BSP_C_FLAGS "-msoft-float -mcpu=leon3")
SET(SOFT_FLOAT 1)