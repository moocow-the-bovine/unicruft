/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: uxConfig.h
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: load autoheader macros
 *--------------------------------------------------------------------------*/

/** \file uxConfig.h
 *  \brief load autoheader macros without ugly preprocessor warnings
 *
 *  \file uxConfigAuto.h
 *  \brief autoheader macros
 *
 *  \file uxConfigNoAuto.h
 *  \brief #undef all known autoheader macros
 */

/* 
 * Define a sentinel preprocessor symbol U8L_CONFIG_H, just
 * in case someone wants to check whether we've already
 * (#include)d this file ....
 */
#ifndef UX_CONFIG_H
#define UX_CONFIG_H
#endif /* UX_CONFIG_H */

/* 
 * Putting autoheader files within the above #ifndef/#endif idiom
 * is potentially a BAD IDEA, since we might need to (re-)define
 * the package's autoheader-generated preprocessor symbols (e.g. after
 * (#include)ing in some config.h from another autoheader package
 */
#include "uxConfigNoAuto.h"
#include "uxConfigAuto.h"
