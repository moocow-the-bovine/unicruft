/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: uxDEpp.h
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: latin1/DE preprocessor: flex scanner wrapper
 *--------------------------------------------------------------------------*/
/** \file
 *  \brief latin1/DE preprocessor: flex scanner wrapper
 */

#ifndef UX_DE_PP_H
#define UX_DE_PP_H

/*#include <uxConfig.h>
#include <uxBuffer.h>
*/
#include <uxDEyy.h>

/** \brief top-level latin1/DE preprocessor struct (flex scanner wrapper) */
typedef struct {
  yyscan_t  scanner;   ///< \details underlying flex scanner, from uxDEyy.l
  uxDEyyData   data;   ///< \details extra data for flex scanner, from uxDEyy.l
} uxDEpp;


//======================================================================
/// \name Top-Level Methods
//@{

/** constructor */
uxDEpp *ux_depp_new(void);

/** destructor
 *  \param free_buffer (boolean): if true, I/O buffer \a buf and its data will be freed,
 *    otherwise user is responsible for freeing \a buf.
 */
void ux_depp_free(uxDEpp *pp);


/** top-level in-place pre-processing routine
 *  \param pp preprocessor struct as returned by ux_depp_new()
 *  \param in input UTF-8 string buffer
 *  \param out output UTF-8 string buffer (append), or NULL
 *  \returns \a out, or a newly created output buffer if \a out was passed as NULL
 *  \note
 *   \li \a in needs least <tt>in->len+2</tt> bytes allocated (for flex EOF sentinels);
 *       it will be auto-extended with ux_buffer_reserve() if required
 *   \li processed data is appended to \a out; for a "plain" conversion,
 *       just set <tt>out->len=0;</tt> before calling this function.
 *   \li user is responsible for allocating and freeing \a in
 *   \li if \a out is NULL, a new buffer will be allocated and returned,
 *       which is the user's responsibility to free.
 *   \li flex scanner may modify \a in in the course of scanning, although
 *       if all goes well it should be in its original state when this
 *       function returns.
 */
uxBuffer *ux_depp_scan_buffer(uxDEpp *pp, uxBuffer *in, uxBuffer *out);

/** top-level pre-processing routine guaranteed not to alter input buffer
 *  \param pp preprocessor struct as returned by ux_depp_new()
 *  \param in input UTF-8 string buffer
 *  \param out output UTF-8 string buffer (append), or NULL
 *  \returns \a out, or a newly created output buffer if \a out was passed as NULL
 *  \note
 *   \li unlike ux_depp_scan_buffer(), this routine copies \a in->str before scanning,
 *       so e.g. no extra space needs to be allocated for \a in.
 *   \li otherwise as for ux_depp_scan_buffer()
 */
uxBuffer *ux_depp_scan_const_buffer(uxDEpp *pp, const uxBuffer *in, uxBuffer *out);

//@}


#endif /* UX_DE_PP_H */
