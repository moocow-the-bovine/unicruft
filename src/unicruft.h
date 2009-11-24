/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: unicruft.h
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: top-level header
 *--------------------------------------------------------------------------*/
/** \file
 *  \brief top-level header
 *  \details does \b NOT #include uxUtf8.h by default!
 */

#ifndef _UNICRUFT_H
#define _UNICRUFT_H

#ifdef __cplusplus
extern "C" {
#endif

/*#include <uxUtf8.h>*/   /*-- available, but we shouldn't include it by default --*/
/*#include <uxConfig.h>*/ /*-- this gets read by uxCommon.h --*/
#include <uxCommon.h>
/*#include <uxBuffer.h>*/ /*-- this gets read by uxUnidecode.h --*/
#include <uxUnidecode.h>
#include <uxDEpp.h>

#ifdef __cplusplus
}
#endif

#endif /* _UNICRUFT_H */
