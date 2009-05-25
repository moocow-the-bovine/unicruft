/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: uxCommon.h
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: common typedefs etc.
 *--------------------------------------------------------------------------*/
/** \file
 *  \brief common typedefs and macros, incl. assert()
 */

#ifndef UX_COMMON_H
#define UX_COMMON_H

#include <uxConfig.h>

/** \brief typedef for unicode codepoints */
typedef unsigned int ucs4;

/** \brief useful alias */
#ifndef uchar
# define uchar unsigned char
#endif

/** \brief utf8.h wants this */
#ifndef u_int32_t
# define u_int32_t ucs4
#endif

//-- ENABLE_ASSERT : if defined, debugging assertions will be enabled
#define ENABLE_ASSERT 1
//#undef ENABLE_ASSERT

#if !defined(assert)
# if defined(ENABLE_ASSERT)
# include <stdio.h>
#  define assert2(test,label) \
     if (!(test)) { \
       fprintf(stderr, PACKAGE ": %s:%d: assertion failed: (%s): %s\n", __FILE__, __LINE__, #test, (label)); \
       exit(255); \
     }
#  define assert(test) \
     if (!(test)) { \
       fprintf(stderr, PACKAGE ": %s:%d: assertion failed: (%s)\n", __FILE__, __LINE__, #test); \
       exit(255); \
     }
# else  /* defined(ENABLE_ASSERT) -> false */
#  define assert(test)
#  define assert2(test,label)
# endif /* defined(ENABLE_ASSERT) */
#endif /* !defined(assert) */

#endif /* UX_COMMON_H */
