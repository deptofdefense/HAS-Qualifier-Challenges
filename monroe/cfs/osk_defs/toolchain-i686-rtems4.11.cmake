# This example toolchain file describes the cross compiler to use for
# the target architecture indicated in the configuration file.

# In this sample application, the cross toolchain is configured to
# use a compiler for the RTEMS operating system targeting the "pc686" BSP

# Note that to use this, the "RTEMS" platform module may need to be added 
# to the system-wide CMake installation as a default CMake does not yet 
# recognize RTEMS as a system name.  An example of this is distributed with
# the pc-rtems PSP.

# Basic cross system configuration
set(CMAKE_SYSTEM_NAME       RTEMS)
set(CMAKE_SYSTEM_PROCESSOR  i386)
set(CMAKE_SYSTEM_VERSION    5)
set(RTEMS_TOOLS_PREFIX      "/opt/rtems-${CMAKE_SYSTEM_VERSION}")
set(RTEMS_BSP_PREFIX        "/opt/rtems-${CMAKE_SYSTEM_VERSION}")
set(RTEMS_BSP               pc686)

# specify the cross compiler - adjust accord to compiler installation
# This uses the compiler-wrapper toolchain that buildroot produces
set(TARGET_PREFIX           "${CMAKE_SYSTEM_PROCESSOR}-rtems${CMAKE_SYSTEM_VERSION}-")
set(CPUTUNEFLAGS            "-march=i686 -mtune=i686")

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
SET(CFE_SYSTEM_PSPNAME                  pc-rtems)
SET(OSAL_SYSTEM_BSPTYPE                 pc-rtems)
SET(OSAL_SYSTEM_OSTYPE                  rtems)
