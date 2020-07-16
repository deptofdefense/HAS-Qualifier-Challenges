## Process this file with automake to produce Makefile.in.

SUBDIRS = libopcodes_mips . sample_code @TESTCODE_DIR@ doc
REDHAT_PKG_FILES = vmips.spec vmips.spec.in
DEBIAN_PKG_FILES = debian/changelog debian/compat debian/control \
 debian/copyright debian/dirs debian/docs debian/info debian/rules \
 debian/source/format
EXTRA_DIST = VERSION $(REDHAT_PKG_FILES) \
 $(sysconf_DATA) $(DEBIAN_PKG_FILES)

# What are we building here?
bin_PROGRAMS = vmips vmipstool

# Defaults! Defaults for everyone!
AM_CXXFLAGS = -I$(top_srcdir)/libopcodes_mips \
 -DSYSCONFDIR=\"$(sysconfdir)\" -DPKGDATADIR=\"$(pkgdatadir)\" $(XTRACFLAGS)
AM_LDFLAGS = $(XTRALDFLAGS)
MOSTLYCLEANFILES = errs memdump.bin
CLEANFILES = romfile.rom vmips.out

# How to build the simulator:
vmips_SOURCES = cpu.cc cpzero.cc devicemap.cc \
  mapper.cc options.cc range.cc intctrl.cc \
  spimconsole.cc stub-dis.cc vmips.cc \
  deviceint.cc debug.cc remotegdb.cc clockdev.cc error.cc \
  clock.cc terminalcontroller.cc haltdev.cc decrtc.cc deccsr.cc \
  decstat.cc decserial.cc rommodule.cc fileutils.cc exeloader.cc fpu.cc \
  interactor.cc testdev.cc \
  cpu.h cpzero.h cpzeroreg.h deviceint.h \
  devicemap.h intctrl.h mapper.h memorymodule.h options.h optiontbl.h \
  range.h spimconsole.h spimconsreg.h \
  tlbentry.h vmips.h debug.h remotegdb.h \
  accesstypes.h deviceexc.h clockdev.h excnames.h error.h \
  clock.h task.h terminalcontroller.h haltdev.h devreg.h clockreg.h \
  haltreg.h wipe.h stub-dis.h decrtc.h decrtcreg.h deccsr.h deccsrreg.h \
  decstat.h decserial.h decserialreg.h rommodule.h gccattr.h mmapglue.h \
  types.h endiantest.h fileutils.h fpu.h interactor.h testdev.h
vmips_LDADD = libopcodes_mips/libopcodes_mips.a

# This library contains the subset of libbfd/libopcodes that we use.
# We build libopcodes_mips before trying to link vmips or vmipstool.
libopcodes_mips/libopcodes_mips.a:
	cd libopcodes_mips && $(MAKE) all

# Huh, huhuh, it says tool.
vmipstool_SOURCES = vmipstool.cc options.cc error.cc stub-dis.cc \
  fileutils.cc options.h error.h stub-dis.h endiantest.h fileutils.h
vmipstool_LDADD = libopcodes_mips/libopcodes_mips.a

# Install a sample vmipsrc.
sysconf_DATA = vmipsrc

# Miscellaneous targets.
tags: TAGS
	ctags *.cc

gcov:
	@for f in $(vmips_SOURCES); do echo $$f; gcov $$f; done
