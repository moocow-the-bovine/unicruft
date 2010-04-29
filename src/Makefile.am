## File: Makefile.am
## Description: automake file, src-level
##-----------------------------------------------------------------------

##-----------------------------------------------------------------------
## Includes
include $(top_srcdir)/Common.am

##-----------------------------------------------------------------------
## LIBRARIES

lib_LTLIBRARIES = libunicruft.la

libunicruft_la_SOURCES = \
	uxUtf8.c \
	uxBuffer.c \
	uxUnidecode.c \
	uxTableAscii.c \
	uxTableLatin1.c \
	uxDEyy.c \
	uxDEpp.c

#uxTableLatin1DE.c 

pkginclude_HEADERS = \
	unicruft.h \
	uxConfig.h \
	uxConfigAuto.h \
	uxConfigNoAuto.h \
	uxCommon.h \
	uxUnidecode.h \
	uxBuffer.h \
	uxDEyy.h \
	uxDEpp.h \
	uxUtf8.h

noinst_HEADERS = \
	config.h

##-----------------------------------------------------------------------
## Library versioning:
##  + for -version-info $(CUR):$(REV):$(AGE) :
##  + base lib is created as libMYLIB.so.$(CUR).$(AGE).$(REV)

## $(LIBCUR) : The most recent interface number that this library implements.
LIBCUR = 0

## $(LIBAGE)
## + The difference between the newest and oldest interfaces that 
##   library implements.  In other words, the library implements all the
##   interface numbers in the range from number `CURRENT - AGE' to `CURRENT'.
LIBAGE = 0

## $(LIBREV) : The implementation number of the CURRENT interface.
LIBREV = 0

libunicruft_la_LDFLAGS = -version-info $(LIBCUR):$(LIBREV):$(LIBAGE)
#libutf8latin_la_LIBADD  = gnulib/libgnu.la @gfsm_LIBS@ $(LIBS)
libunicruft_la_LIBADD  = $(LIBS)

##-----------------------------------------------------------------------
## PROGRAMS

bin_PROGRAMS = unicruft

#EXTRA_PROGRAMS = utf8-to-latin1-ppde
EXTRA_PROGRAMS = \
	utf8-to-ascii \
	latin1-to-utf8 \
	utf8-to-latin1 \
	utf8-de-pp \
	utf8-to-latin1-de


filter_deps = filter-main.h filter-main.c uxBuffer.h

utf8_to_ascii_SOURCES = utf8-to-ascii.c
utf8_to_ascii_LDADD = libunicruft.la
utf8-to-ascii.o: utf8-to-ascii.c $(filter_deps)

latin1_to_utf8_SOURCES = latin1-to-utf8.c
latin1_to_utf8_LDADD = libunicruft.la
latin1-to-utf8.o: latin1-to-utf8.c $(filter_deps)

utf8_to_latin1_SOURCES = utf8-to-latin1.c
utf8_to_latin1_LDADD = libunicruft.la
utf8-to-latin1.o: utf8-to-latin1.c $(filter_deps)

utf8_de_pp_SOURCES = utf8-de-pp.c
utf8_de_pp_LDADD = libunicruft.la
utf8-de-pp.o: utf8-de-pp.c $(filter_deps)

utf8_to_latin1_de_SOURCES = utf8-to-latin1-de.c
utf8_to_latin1_de_LDADD = libunicruft.la
utf8-to-latin1-de.o: utf8-to-latin1-de.c $(filter_deps)

#utf8_to_latin1_ppde_SOURCES = utf8-to-latin1-ppde.c
#utf8_to_latin1_ppde_LDADD = libunicruft.la
#utf8-to-latin1-ppde.o: utf8-to-latin1-ppde.c $(filter_deps)

extra: $(EXTRA_PROGRAMS)

##-----------------------------------------------------------------------
## Programs: flex stuff

if HAVE_FLEX
uxDEyy.h: uxDEyy.l
	$(FLEX) $<

uxDEyy.c: uxDEyy.l
	$(FLEX) $<
endif


##-----------------------------------------------------------------------
## Programs: gog stuff
SUFFIXES += .gog _cmdparser.c _cmdparser.cc _cmdparser.h

unicruft_SOURCES = unicruft_main.c unicruft_cmdparser.c unicruft_cmdparser.h
unicruft_main.o: unicruft_cmdparser.h
unicruft_LDADD = libunicruft.la

EXTRA_DIST += unicruft.gog


##-----------------------------------------------------------------------
## pre-compile rules: Getopt::Gen

OPTGENFLAGS = -u -l --no-handle-rcfile

if HAVE_OPTGEN
.gog_cmdparser.h:
	optgen.perl $(OPTGENFLAGS) --nopod -F $*_cmdparser $<

.gog_cmdparser.c:
	optgen.perl $(OPTGENFLAGS) --nopod -F $*_cmdparser $<

.gog.pod:
	optgen.perl $(OPTGENFLAGS) --nocfile --nohfile -F $* $<
endif


##-----------------------------------------------------------------------
## Dist

EXTRA_DIST += uxDEyy.l uxDEyy.c uxDEyy.h
