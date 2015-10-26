dnl -*- Mode: autoconf -*-

dnl AX_CHECK_DEBUG
dnl + sets/modifies vars:
dnl   ENABLE_DEBUG
dnl   OFLAGS
dnl   CFLAGS, USER_CFLAGS
dnl + autoheader defines
dnl   ENABLE_DEBUG
dnl + AC_SUBST vars
dnl   OFLAGS
AC_DEFUN([AX_CHECK_DEBUG],
[
##vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
## debug ?
##
AC_ARG_ENABLE(debug,
	AC_HELP_STRING([--enable-debug], [build debug version (default=no)]))

AC_MSG_CHECKING([whether to build a debug version])
if test "$enable_debug" == "yes" ; then
   AC_MSG_RESULT(yes)
   AC_MSG_CHECKING([for compiler debugging flags])

   dnl-- this breaks default shared-library building
   dnl-- on debian/sid:
   dnl    + automake 1.9.6
   dnl    + autoconf 2.59
   dnl    + libtool  1.5.20
   dnl
   dnl AC_DISABLE_SHARED
   if test "$GCC" == "yes" ; then
     OFLAGS="-g"
     AC_MSG_RESULT([(gcc): $OFLAGS])
   else
     AC_MSG_RESULT([(unknown compiler))])
     AC_MSG_WARN([unknown compiler: you must use CFLAGS to set compiler debugging flags])
     OFLAGS=""
   fi

   AC_DEFINE(DEBUG_ENABLED,1, [Define this to enable debugging code])
   DOXY_DEFINES="$DOXY_DEFINES DEBUG_ENABLED=1"
   CONFIG_OPTIONS="DEBUG=1"
else
  AC_MSG_RESULT(no)
  AC_MSG_CHECKING([for compiler optimization flags])

  if test "$GCC" == "yes"; then
   case "$USER_CFLAGS" in
    *-O*)
      AC_MSG_RESULT([from user CFLAGS])
      OFLAGS=""
      ;;
    *)
     #OFLAGS="-pipe -O2" ##-- sensible default
     OFLAGS="-pipe -O3"  ##-- this works pretty well too
     #OFLAGS="-pipe -O6"
     AC_MSG_RESULT([$OFLAGS])
     ;;
   esac

  else
    AC_MSG_RESULT([unknown])
    AC_MSG_WARN([unknown C compiler: you must use CFLAGS to set compiler optimization flags])
    OFLAGS=""
  fi
  #CONFIG_OPTIONS="$CONFIG_OPTIONS DEBUG=0"
  CONFIG_OPTIONS="DEBUG=0"
fi

##-- warnings?
AC_MSG_CHECKING([for compiler warning flags])
if test "$GCC" == "yes" ; then
   case "$USER_CFLAGS" in
    *-[Ww]*)
      AC_MSG_RESULT([user-specified])
      WFLAGS=""
      ;;
    *)
     WFLAGS="-W -Wall -Winline -Wno-unused -Wno-unused-variable -Wno-unused-parameter"
     AC_MSG_RESULT([$WFLAGS])
     ;;
   esac
else
  AC_MSG_RESULT([unknown])
  AC_MSG_WARN([unknown C compiler: you must use CFLAGS to set compiler warning flags])
fi


test -n "$OFLAGS" && USER_CFLAGS="$USER_CFLAGS $OFLAGS" && CFLAGS="$CLFAGS $OFLAGS"
test -n "$WFLAGS" && USER_CFLAGS="$USER_CFLAGS $WFLAGS" && CFLAGS="$CLFAGS $WFLAGS"
AC_SUBST(OFLAGS)
AC_SUBST(WFLAGS)
##
## /debug ?
##^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
])
