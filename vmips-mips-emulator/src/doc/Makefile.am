## Process this file with automake to produce Makefile.in.

info_TEXINFOS = vmips.texi
vmips_TEXINFOS = invoke.texi vmipstool.texi copyright.texi options.texi
dist_man_MANS = vmips.1 vmipstool.1
EXTRA_DIST = vmips.pdf vmips.html

options.texi: $(top_srcdir)/optiontbl.h
	cd $(srcdir) && ./makeoptdoc $@

AM_MAKEINFOFLAGS = --no-split

vmips.1: invoke.texi options.texi
	perl $(srcdir)/texi2pod.pl $< > vmips.pod
	pod2man --release="vmips "`cat $(top_srcdir)/VERSION` \
		--center="VMIPS Programmer's Manual" vmips.pod > $@

vmipstool.1: vmipstool.texi
	perl $(srcdir)/texi2pod.pl $< > vmipstool.pod
	pod2man --release="vmips "`cat $(top_srcdir)/VERSION` \
		--center="VMIPS Programmer's Manual" vmipstool.pod > $@

# We don't bother supporting DVIs.
dvi:
	@true

# Allow cleaning files built with special tools.
maintainer-clean-local:
	rm -f options.texi vmips.1 vmips.pod vmipstool.1 vmipstool.pod

