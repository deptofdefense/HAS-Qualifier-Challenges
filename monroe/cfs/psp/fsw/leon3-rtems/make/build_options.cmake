# This indicates where to install target binaries created during the build
set(INSTALL_SUBDIR "eeprom")
#add_definitions("-D_RTEMS_OS_ -D__SPARC__")
#add_definitions("-D_EB -DENDIAN=_EB -DSOFTWARE_BIG_BIT_ORDER")
add_definitions("-DSOFTWARE_BIG_BIT_ORDER")