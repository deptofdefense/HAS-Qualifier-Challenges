# Makefile.am automatically generated by testcase-maker.
# If you make changes here they will go away.

VMIPSTOOL = ../../vmipstool -n -F ../../vmipsrc --ld-script=@top_srcdir@/sample_code/ld.script
AM_CFLAGS = -g -I@top_srcdir@ -I@top_srcdir@/sample_code
SETUP = ../../sample_code/setup.o

# empty 

# empty 

# simple_asm bdexcp
# multifile_asm -setup 0 bdexcp bdexcp.S
bdexcp_SOURCES = bdexcp.S
bdexcp.rom: bdexcp.exe
	$(VMIPSTOOL) --make-rom bdexcp.exe bdexcp.rom

# simple_c dzhello
# multifile_c dzhello dzhello.c
dzhello_LDFLAGS = $(SETUP)
dzhello_SOURCES = dzhello.c
dzhello.rom: dzhello.exe
	$(VMIPSTOOL) --make-rom dzhello.exe dzhello.rom

# simple_c emptymain
# multifile_c emptymain emptymain.c
emptymain_LDFLAGS = $(SETUP)
emptymain_SOURCES = emptymain.c
emptymain.rom: emptymain.exe
	$(VMIPSTOOL) --make-rom emptymain.exe emptymain.rom

# simple_asm exception
# multifile_asm -setup 0 exception exception.S
exception_SOURCES = exception.S
exception.rom: exception.exe
	$(VMIPSTOOL) --make-rom exception.exe exception.rom

# simple_c hello
# multifile_c hello hello.c
hello_LDFLAGS = $(SETUP)
hello_SOURCES = hello.c
hello.rom: hello.exe
	$(VMIPSTOOL) --make-rom hello.exe hello.rom

# simple_c hello2
# multifile_c hello2 hello2.c
hello2_LDFLAGS = $(SETUP)
hello2_SOURCES = hello2.c
hello2.rom: hello2.exe
	$(VMIPSTOOL) --make-rom hello2.exe hello2.rom

# simple_asm instcounts
# multifile_asm -setup 0 instcounts instcounts.S
instcounts_SOURCES = instcounts.S
instcounts.rom: instcounts.exe
	$(VMIPSTOOL) --make-rom instcounts.exe instcounts.rom

# makefile_fragment loser
loser_SOURCES = loser.S
loser.rom: loser.exe
	$(VMIPSTOOL) --make-rom loser.exe loser.tmp
	dd if=loser.tmp bs=4 count=1 of=loser.rom >/dev/null 2>&1
	rm loser.tmp

# empty 

# simple_asm poke2
# multifile_asm -setup 0 poke2 poke2.S
poke2_SOURCES = poke2.S
poke2.rom: poke2.exe
	$(VMIPSTOOL) --make-rom poke2.exe poke2.rom

# simple_asm sb-print
# multifile_asm -setup 0 sb-print sb-print.S
sb_print_SOURCES = sb-print.S
sb-print.rom: sb-print.exe
	$(VMIPSTOOL) --make-rom sb-print.exe sb-print.rom

# simple_asm simpledis
# multifile_asm -setup 0 simpledis simpledis.S
simpledis_SOURCES = simpledis.S
simpledis.rom: simpledis.exe
	$(VMIPSTOOL) --make-rom simpledis.exe simpledis.rom

# simple_asm unaligned
# multifile_asm -setup 0 unaligned unaligned.S
unaligned_SOURCES = unaligned.S
unaligned.rom: unaligned.exe
	$(VMIPSTOOL) --make-rom unaligned.exe unaligned.rom

noinst_PROGRAMS =  bdexcp dzhello emptymain exception hello hello2 instcounts loser poke2 sb-print simpledis unaligned

CCLD = $(VMIPSTOOL) --link
COMPILE = $(VMIPSTOOL) --compile $(AM_CFLAGS)
ASCOMPILE = $(VMIPSTOOL) --compile $(AM_CFLAGS)
CPPASCOMPILE = $(VMIPSTOOL) --compile $(AM_CFLAGS)
EXEEXT = .exe

CLEANFILES =  bdexcp.rom dzhello.rom emptymain.rom exception.rom hello.rom hello2.rom instcounts.rom loser.rom poke2.rom sb-print.rom simpledis.rom unaligned.rom

EXTRA_DIST =  outcheck.exp  badargs.par badoption.par bdexcp.par dzhello.par emptymain.par exception.par hello.par hello2.par instcounts.par loser.par nonexistent.par poke2.par sb-print.par simpledis.par unaligned.par

# 4 C testcases and 7 asm testcases.
# 4 custom makefile fragment testcases.
