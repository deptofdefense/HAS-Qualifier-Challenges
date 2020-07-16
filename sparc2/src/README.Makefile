The Makefile system used in these examples is dependent on the
environment variable RTEMS_MAKEFILE_PATH being set. This can be
set on each command line that invokes "make" or it can be exported
into your environment.

RTEMS_MAKEFILE_PATH points to the installed BSP image you are compiling
for. It is composed as follows:

  @prefix@/@target@/BSP

where:

  - prefix is the BSP install point or prefix
  - target is the tool target (e.g. sparc-rtems5)
  - BSP is the BSP you are building for (e.g. erc32)

A coupte of examples:

export RTEMS_MAKEFILE_PATH=${HOME}/rtems-work/tools/5/sparc-rtems5/erc32
make clean
make

OR:

RTEMS_MAKEFILE_PATH=${HOME}/rtems-work/tools/5/sparc-rtems5/erc32 make clean
RTEMS_MAKEFILE_PATH=${HOME}/rtems-work/tools/5/sparc-rtems5/erc32 make

You can switch a build from one BSP to another by changing the value
of RTEMS_MAKEFILE_PATH but be careful to "make clean" on the old BSP
before building the new one.

Deprecration Warning: This style of Makefile has been included in RTEMS
since the earliest days. However, it is being replaced by the use of waf
and something akin to pkgconfig to obtain compilation settings. The intent
is to make it easier for users to configure their preferred build system
for an RTEMS application.
