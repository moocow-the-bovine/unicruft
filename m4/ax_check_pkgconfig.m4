dnl -*- Mode: autoconf -*-

##---------------------------------------------------------------
AC_DEFUN([AX_CHECK_PKGCONFIG],
[
##-- pkg-config : program
##
AC_ARG_VAR(PKG_CONFIG, [How to run the pkg-config program])
AC_ARG_VAR(PKG_CONFIG_PATH, [Directories to search for pkg-config])

AC_MSG_CHECKING([for PKG_CONFIG])
AC_MSG_RESULT([$PKG_CONFIG])

AC_MSG_CHECKING([for PKG_CONFIG_PATH])
AC_MSG_RESULT([$PKG_CONFIG_PATH])

if test -z "$PKG_CONFIG" ; then
  AC_PATH_PROG(PKG_CONFIG,pkg-config,[])
fi
])

##---------------------------------------------------------------
AC_DEFUN([AX_PKGCONFIG_DIR],
[
AC_MSG_CHECKING([where to install pkg-config .pc file(s)])

##-- pkg-config: destination directory
AC_ARG_WITH(pkgconfig-dir,
	AC_HELP_STRING([--with-pkgconfig-dir=DIR],
		       [install pkg-config metafile(s) in DIR (default=LIBDIR/pkgconfig)]),
	[ac_cv_pkgconfigdir="$withval"])


if test -z "$ac_cv_pkgconfigdir" ; then
  ac_cv_pkgconfigdir="\$(libdir)/pkgconfig"
fi
pkgconfigdir="$ac_cv_pkgconfigdir"
AC_SUBST(pkgconfigdir)

AC_MSG_RESULT([$pkgconfigdir])
##
## pkg-config
##^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
])
