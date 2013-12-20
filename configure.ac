dnl Process this file with autoconf to produce a configure script.
AC_PREREQ(2.5)

dnl Some handy macros
define([THE_PACKAGE_NAME],    [unicruft])
define([THE_PACKAGE_VERSION], [0.17])
define([THE_PACKAGE_MAINTAINER],  [jurish@bbaw.de])

AC_INIT(THE_PACKAGE_NAME, THE_PACKAGE_VERSION, THE_PACKAGE_MAINTAINER)

dnl source && aux dir
AC_CONFIG_AUX_DIR(.)
AC_CONFIG_MACRO_DIR([m4])

dnl canonical target (sets $target, $target_(cpu|vendor|os) : used for bindist)
AC_CANONICAL_TARGET

dnl use automake
AM_INIT_AUTOMAKE(THE_PACKAGE_NAME, THE_PACKAGE_VERSION)

dnl use autoheader
AM_CONFIG_HEADER([src/uxConfigAuto.h])
dnl ... link to overrides
AC_CONFIG_LINKS(src/uxConfigNoAuto.h:src/uxConfigAuto.h.in)

dnl default prefix
AC_PREFIX_DEFAULT(/usr/local)

##-- save user flags
AX_SAVE_USERFLAGS()

##-- use GNU extensions
AC_GNU_SOURCE()

##-- check for compilers (may alter CFLAGS, CXXFLAGS)
AC_PROG_CC
dnl AC_PROG_CXX
dnl AC_LANG(C++)

##-- DISTCHECK: simulate missing development-only packages
AX_ARG_DISTCHECK()

##-- flex, bison (also automake LEX, YACC)
AX_CHECK_FLEX()
AX_CHECK_BISON()
AX_GNU_LEXYACC()

dnl v--- needed if Makefile.am uses _LTLIBRARIES targets
AC_PROG_LIBTOOL

dnl v--- for static-only libraries (non-libtool)
dnl AC_PROG_RANLIB

##---------------------------------------------------------------
## svn info
##  + keyword substitution requires property svn:keywords set on
##    this file:
##    $ svn propset svn:keywords "HeadURL Id" configure.ac
##  + or even:
##    $ svn propset svn:keywords "HeadURL Id Date Rev Author" configure.ac
AC_PATH_PROG([SVNVERSION],[svnversion],[no])

AC_MSG_CHECKING([for SVN HeadURL])
SVNURL=`echo '$HeadURL: svn+ssh://odo.dwds.de/home/svn/dev/dta-tokwrap/trunk/configure.ac $' \
  | sed -e's/^\$HeadURL:[ ]*//1' -e's/\/configure.ac[ ]*\$$//1'`
AC_MSG_RESULT([$SVNURL])

AC_MSG_CHECKING([for SVN revision of working copy])
if test -n "$SVNVERSION" -a "$SVNVERSION" != "no"; then
  SVNREV=`$SVNVERSION -n`
else
  SVNREV='exported'
fi
AC_MSG_RESULT([$SVNREV])

SVNID="${SVNURL} @ ${SVNREV}"
AC_SUBST(SVNURL)
AC_SUBST(SVNREV)
AC_SUBST(SVNID)
AC_DEFINE_UNQUOTED(PACKAGE_SVNURL, "$SVNURL", [Subversion HeadURL of package sources])
AC_DEFINE_UNQUOTED(PACKAGE_SVNREV, "$SVNREV", [Current SVN revision of package sources])
AC_DEFINE_UNQUOTED(PACKAGE_SVNID,  "$SVNID",  [Subversion identifier for package sources])
##
## svn info
##---------------------------------------------------------------

##---------------------------------------------------------------
## getline
AC_CHECK_FUNCS([getline getdelim])
## /getline
##---------------------------------------------------------------


#---------------------------------------------------------------
# short package include-dir
spkgincludedir="\${includedir}/AC_PACKAGE_NAME"
AC_SUBST(spkgincludedir)
# short package include-dir
#---------------------------------------------------------------

#---------------------------------------------------------------
# share/package dir
sharepkgdir="\${prefix}/share/AC_PACKAGE_NAME"
AC_SUBST(sharepkgdir)

dnl pkgxsldir="\${sharepkgdir}/stylesheets"
dnl AC_SUBST(pkgxsldir)
# share/package dir
#---------------------------------------------------------------

##-- pkg-config
dnl AX_CHECK_PKGCONFIG  dnl-- only for packages which need to call pkg-config
AX_PKGCONFIG_DIR        dnl-- only for packages which install their own .pc file(s)

##-- perl
AX_CHECK_PERL()

##-- Getopt::Gen, optgen.perl
AX_CHECK_GOG()

##-- expat
dnl AX_CHECK_EXPAT()
dnl if test "$ENABLE_EXPAT" != "yes"; then
dnl  AC_MSG_ERROR([could not find expat XML parser library: refusing to continue!])
dnl fi

##-- debug
AX_CHECK_DEBUG()

###-- restore user FLAGS
AX_RESTORE_USERFLAGS()

##----------------------------------------------------------------------
## compiler characteristics
AC_C_INLINE
AC_C_CONST
AX_CHECK_COMPILER_FLAGS([-fPIC],[CFLAGS="$CFLAGS -fPIC"],[])
AX_CHECK_COMPILER_FLAGS([-DPIC],[CFLAGS="$CFLAGS -DPIC"],[])

dnl make a couple of jokes for user's amusement.
dnl cf. http://www.gnu.org/fun/jokes/gcc.html
AX_CHECK_COMPILER_FLAGS([-fkeep-programmers-inline],[],[])
AX_CHECK_COMPILER_FLAGS([-vomit-frame-pointer],[],[])
## /compiler stuff
##----------------------------------------------------------------------


##vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
## Documentation
##
AX_DOC_COMMON()
AX_DOC_DOXYGEN()
AX_DOC_POD()       dnl-- needed for README.pod formatting
dnl AX_DOC_DOT()

DOC_MAN1_GOGS="unicruft.gog"
AX_DOC_GOG()
AX_DOC_GOG_LINKS([src],[doc/programs])

dnl AC_CONFIG_LINKS([doc/programs/dta-tokwrap.perl.pod:DTA-TokWrap/dta-tokwrap.perl])
dnl AC_CONFIG_LINKS([doc/programs/dtatw-add-c.perl.pod:scripts/dtatw-add-c.perl])
dnl AC_CONFIG_LINKS([doc/programs/dtatw-add-w.perl.pod:scripts/dtatw-add-w.perl])
dnl AC_CONFIG_LINKS([doc/programs/dtatw-add-s.perl.pod:scripts/dtatw-add-s.perl])
dnl AC_CONFIG_LINKS([doc/README.pod:README.pod])
##
## /Documentation
##^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


##----------------------------------------------------------------------
## output
##
AC_CONFIG_FILES(doc/libunicruft/mainpage.dox doc/libunicruft/libunicruft.doxy doc/libunicruft/Makefile)
AC_CONFIG_FILES(doc/programs/Makefile)
AC_CONFIG_FILES(doc/Makefile)
AC_CONFIG_FILES(src/Makefile)
AC_CONFIG_FILES(Makefile)
AC_CONFIG_FILES(unicruft.pc)
AC_OUTPUT
