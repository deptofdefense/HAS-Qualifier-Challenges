dnl acinclude.m4 -- This file is part of VMIPS.
dnl It is used to build the configure script. See configure.in for details.

dnl Local macro: VMIPS_CXX_ATTRIBUTE_NORETURN
dnl Check for availability of __attribute__((noreturn)) syntax for specifying
dnl that a function will never return. Defines HAVE_ATTRIBUTE_NORETURN if it
dnl works. We assume that if the attribute-adorned function compiles without
dnl giving a warning, then it is supported.

AC_DEFUN([VMIPS_CXX_ATTRIBUTE_NORETURN],
[AC_CACHE_CHECK([whether specifying that a function will never return works],
[vmips_cv_cxx_attribute_noreturn],
[if test "x$GXX" = "xyes" 
 then
   (CXXFLAGS="-Werror $CXXFLAGS"
    AC_LANG_CPLUSPLUS
    AC_TRY_COMPILE([#include <cstdlib>
      __attribute__((noreturn)) void die(void) { abort(); }],
      [],exit 0,exit 1))
   if test $? -eq 0
   then
     vmips_cv_cxx_attribute_noreturn=yes
   else
     vmips_cv_cxx_attribute_noreturn=no
   fi
 else
   vmips_cv_cxx_attribute_noreturn=no
 fi])
if test "$vmips_cv_cxx_attribute_noreturn" = yes
then
  AC_DEFINE(HAVE_ATTRIBUTE_NORETURN, 1,
  [Define if __attribute__((noreturn)) syntax can be used to specify
   that a function will never return.])
fi])

dnl Local macro: VMIPS_CXX_ATTRIBUTE_FORMAT
dnl Check for availability of __attribute__((format (...))) syntax for
dnl specifying that a function takes printf-style arguments. Defines
dnl HAVE_ATTRIBUTE_PRINTF if it works. As with VMIPS_CXX_ATTRIBUTE_NORETURN,
dnl we assume that if the attribute-adorned function compiles without giving
dnl a warning, then it is supported.

AC_DEFUN([VMIPS_CXX_ATTRIBUTE_FORMAT],
[AC_CACHE_CHECK([whether specifying that a function takes printf-style arguments works], [vmips_cv_cxx_attribute_format],
[if test "x$GXX" = "xyes"
then
  (CXXFLAGS="-Werror $CXXFLAGS"
   AC_LANG_CPLUSPLUS
   AC_TRY_COMPILE([#include <cstdlib>
     __attribute__((format(printf, 1, 2)))
     void myprintf(char *fmt, ...) { abort(); }],[],exit 0,exit 1))
  if test $? -eq 0
  then
    vmips_cv_cxx_attribute_format=yes
  else
    vmips_cv_cxx_attribute_format=no
  fi
else
  vmips_cv_cxx_attribute_format=no
fi])
if test "x$vmips_cv_cxx_attribute_format" = "xyes"
then
  AC_DEFINE(HAVE_ATTRIBUTE_FORMAT, 1,
  [True if __attribute__((format (...))) syntax can be used to specify
   that a function takes printf-style arguments.])
fi])

dnl Local macro: VMIPS_CXX_TEMPLATE_FUNCTIONS
dnl Check for template function handling bug in, for example, pre-2.95 g++.
dnl Abort with a configuration-time error if the test program doesn't compile.

AC_DEFUN([VMIPS_CXX_TEMPLATE_FUNCTIONS],
[AC_CACHE_CHECK([whether you can pass a template function to a function whose return type is the same as the type of its parameter],
[vmips_cv_cxx_template_functions],
[(AC_LANG_CPLUSPLUS
  AC_TRY_COMPILE([
    template<class F> F x(F f) { }
    template<class T> void y(T t) { }
    void z(void) { x(y<int>); }
  ],[],exit 0,exit 1))
if test $? -eq 0
then
  vmips_cv_cxx_template_functions=yes
else
  vmips_cv_cxx_template_functions=no
fi])
if test "x$vmips_cv_cxx_template_functions" = "xno"
then
  AC_MSG_ERROR([your C++ compiler's template function handling is buggy; see INSTALL])
fi])

dnl Local macro: VMIPS_TYPE_SOCKLEN_T
dnl #define socklen_t to int if socklen_t is not in sys/socket.h.

AC_DEFUN([VMIPS_TYPE_SOCKLEN_T],
[AC_CACHE_CHECK([for socklen_t], [vmips_cv_type_socklen_t],
[AC_TRY_COMPILE(
[#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>],
[socklen_t foo; foo = 1; return 0;],
vmips_cv_type_socklen_t=yes, vmips_cv_type_socklen_t=no)])
if test "x$vmips_cv_type_socklen_t" = "xno"
then
  AC_DEFINE(socklen_t, int,
    [Define to the type pointed to by the third argument to getsockname,
     if it is not socklen_t.])
fi])

dnl Local macro: VMIPS_LINK_STATIC_GETPWNAM
dnl Can libtool compile statically linked programs that call getpwnam()?
dnl On Solaris the answer is no, and we must dynamically link with libdl.
dnl Based on AC_TRY_LINK from acgeneral.m4.

AC_DEFUN([VMIPS_LINK_STATIC_GETPWNAM],
[AC_CACHE_CHECK([whether programs calling getpwnam can be statically linked],
[vmips_cv_link_static_getpwnam],[cat > conftest.$ac_ext <<EOF
[#]line __oline__ "configure"
#include "confdefs.h"
#include <stdio.h>
#include <pwd.h>
int main() {
struct passwd *p;
p = getpwnam("root");
printf("%s\n", p->pw_name);
return 0; }
EOF
vmips_cv_link_static_getpwnam=no
if AC_TRY_COMMAND(./libtool --mode=compile $CXX $CXXFLAGS -c -o conftest.o conftest.$ac_ext 2>&AC_FD_CC 1>&AC_FD_CC)
then
  if AC_TRY_COMMAND(./libtool --mode=link $CXX $CXXFLAGS -all-static -o conftest${ac_exeext} conftest.o 2>&AC_FD_CC 1>&AC_FD_CC)
  then
    vmips_cv_link_static_getpwnam=yes
  fi
fi
if test "x$vmips_cv_link_static_getpwnam" = "xyes"
then
  true
else
  echo "configure: failed program was:" >&AC_FD_CC
  cat conftest.$ac_ext >&AC_FD_CC
fi
rm -rf conftest*])
if test "x$vmips_cv_link_static_getpwnam" = "xyes"
then
  SOLARIS_DL_HACK=""
else
  SOLARIS_DL_HACK="/usr/lib/libdl.so"
fi
AC_SUBST(SOLARIS_DL_HACK)])

