/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: uxUnidecode.h
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: Text::Unidecode(3pm) routines
 *--------------------------------------------------------------------------*/

/** \file
 *  \brief context-insensitive character mapping tables & utilities
 */

#ifndef UX_UNIDECODE_H
#define UX_UNIDECODE_H

#include <uxBuffer.h>

/** \brief unicode codepoint lookup table */
typedef struct {
  const size_t   len;  ///< \details number of entries
  const char *data[];  ///< \details translation strings indexed by unicode codepoint
} uxLookupTable;

/** \brief Unicode -> ASCII translation lookup table
 *  \details transliteration target strings indexed by unicode codepoint:
 *  <code>const char *cx = UNIDECODE_ASCII[(unsigned int)ucs4_codepoint];</code>
 *  All entries should be non-NULL, although they may be empty (""s).
 */
extern const uxLookupTable UNIDECODE_ASCII;

/** \brief Unicode -> Latin-1 override table 
 * \details this is a small (256-element) lookup table which maps all
 *  latin-1 codepoints (U+0000-U+00FF) to themselves.
 */
extern const uxLookupTable UNIDECODE_LATIN1;

/** \brief maximum strlen()-length of known transliterations */
#ifndef UNIDECODE_TARGET_MAXLEN
# define UNIDECODE_TARGET_MAXLEN 13
#endif

//--------------------------------------------------------------
/** Get translation target string for a codepoint.
 *  \param tab user lookup table or NULL
 *  \param wc codepoint to translate
 *  \returns string translation for \a wc, which may be empty
 *    but should never be NULL.
 *  \li implicitly falls back to translations from UNIDECODE_ASCII
 *  \li Basically a safe wrapper for <code>tab->data[wc]</code>
 *  \li ::UNIDECODE_ASCII is always used as a fallback lookup table
 *      for out-of-range codepoints
 */
static inline
const char *ux_unidecode_wc_target(const uxLookupTable *tab, ucs4 wc)
{
  return (tab && wc < tab->len
	  ? tab->data[wc]
	  : (wc < UNIDECODE_ASCII.len
	     ? UNIDECODE_ASCII.data[wc]
	     : ""));
}

//--------------------------------------------------------------
/** Get number of bytes required for translating a codepoint,
 *  not counting terminating NUL.  
 *  \param tab user lookup table or NULL
 *  \param wc codepoint whose length is to be looked up
 *  \returns number of bytes required for translation of \a wc
 *  \li implicitly falls back to translations from UNIDECODE_ASCII
 *  \li Basically a safe wrapper for <code>strlen(tab->data[wc])</code>
 *  \li ::UNIDECODE_ASCII is always used as a fallback lookup table
 *      for out-of-range codepoints
 */
static inline
size_t ux_unidecode_wc_len(const uxLookupTable *tab, ucs4 wc)
{
  return wc > 0 ? strlen(ux_unidecode_wc_target(tab,wc)) : 1;
}

//--------------------------------------------------------------
/** Append translation for a single UCS-4 character to an 8-bit string buffer
 *  \param tab user lookup table or NULL
 *  \param wc unicode codepoint of character to translate
 *  \param dst output ASCII string buffer
 *  \returns number of bytes written to \a dst
 *  \li implicitly falls back to translations from UNIDECODE_ASCII
 *  \li always NULL-terminates output buffer
 *  \li may auto-grow output buffer
 */
static inline
size_t ux_unidecode_wc(const uxLookupTable *tab, ucs4 wc, uxBuffer *dst)
{
  const char *ux = ux_unidecode_wc_target(tab,wc);
  size_t   uxlen = ux_unidecode_wc_len(tab,wc);
  ux_buffer_reserve(dst, dst->len + uxlen + 1);
  strcpy(&dst->str[dst->len], ux);
  dst->len += uxlen;
  dst->str[dst->len] = '\0';
  return uxlen;
}

//--------------------------------------------------------------
/** like wx_unidecode_wc() without boundary checking. */
static inline
size_t ux_unidecode_wc_nolen(const uxLookupTable *tab, ucs4 wc, uxBuffer *dst)
{
  const char *ux = ux_unidecode_wc_target(tab,wc);
  size_t   uxlen = ux_unidecode_wc_len(tab,wc);
  //ux_buffer_reserve(dst, dst->len + uxlen + 1);
  strcpy(&dst->str[dst->len], ux);
  dst->len += uxlen;
  dst->str[dst->len] = '\0';
  return uxlen;
}


//--------------------------------------------------------------
/** Append translation for a UCS-4 wide string buffer to an 8-bit string buffer
 *  \param tab user lookup table or NULL
 *  \param src source wide string buffer to be translated
 *  \param dst destination ASCII string buffer
 *  \returns number of bytes written to \a dst
 *  \li implicitly falls back to translations from UNIDECODE_ASCII
 *  \li always NULL-terminates output buffer
 *  \li may auto-grow output buffer
 */
size_t ux_unidecode_ws(const uxLookupTable *tab, const uxWBuffer *src, uxBuffer *dst);

//--------------------------------------------------------------
/** Append translation for a UTF-8 wide string buffer to an 8-bit string buffer
 *  \param tab user lookup table or NULL
 *  \param src source UTF-8 string buffer to be translated
 *  \param dst destination ASCII string buffer
 *  \returns number of bytes written to \a dst
 *  \li implicitly falls back to translations from UNIDECODE_ASCII
 *  \li always NULL-terminates output buffer
 *  \li may auto-grow output buffer
 */
size_t ux_unidecode_us(const uxLookupTable *tab, const uxBuffer *src, uxBuffer *dst);

#endif /* UX_UNIDECODE_H */
