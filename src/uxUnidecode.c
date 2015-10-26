/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: uxUnidecode.c
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: Text::Unidecode(3pm) routines
 *--------------------------------------------------------------------------*/

#include "uxUnidecode.h"
#include "uxUtf8.h"

#include <string.h>


//--------------------------------------------------------------
size_t ux_unidecode_ws(const uxLookupTable *tab, const uxWBuffer *src, uxBuffer *dst)
{
  size_t srci, dst_needed=0;

  //-- compute required length
  for (srci=0; srci < src->len; srci++) {
    dst_needed += ux_unidecode_wc_len(tab, src->wstr[srci]);
  }
  ux_buffer_reserve(dst, dst->len+dst_needed+1);

  //-- translate
  for (srci=0; srci < src->len; srci++) {
    ux_unidecode_wc_nolen(tab, src->wstr[srci], dst);
  }
  dst->str[dst->len] = '\0';
  return dst_needed;
}

//--------------------------------------------------------------
size_t ux_unidecode_us(const uxLookupTable *tab, const uxBuffer *src, uxBuffer *dst)
{
  int srci;
  size_t dst_needed=0;
  ucs4 wc;

  //-- compute required length
  for (srci=0; (size_t)srci < src->len; ) {
    wc = u8_nextcharn(src->str, src->len, &srci);
    dst_needed += ux_unidecode_wc_len(tab, wc);
  }
  ux_buffer_reserve(dst, dst->len + dst_needed + 1);

  //-- translate
  for (srci=0; (size_t)srci < src->len; ) {
    wc = u8_nextcharn(src->str, src->len, &srci);
    ux_unidecode_wc_nolen(tab, wc, dst);
  }
  dst->str[dst->len] = '\0';
  return dst_needed;
}
