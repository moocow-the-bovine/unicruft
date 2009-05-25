/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: utf8-to-ascii.c
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: utf8 -> latin1: filter
 *--------------------------------------------------------------------------*/

#include "unicruft.h"
#include "uxConfig.h"
#include "uxUtf8.h"

#define FILTER_MAIN main
#include "filter-main.h"

/*======================================================================
 * Filter
 */

//--------------------------------------------------------------
// Filter: Help
#define INFILE_HELP "UTF-8 input file"
#define OUTFILE_HELP "Latin-1 output file"

//--------------------------------------------------------------
// Filter: Globals
uxBuffer *u8buf=NULL;
uxBuffer *l1buf=NULL;

//--------------------------------------------------------------
// Filter: Init & Cleanup
#define FILTER_INIT filter_init();
void filter_init(void)
{
  l1buf = ux_buffer_new(NULL,0,UNIDECODE_TARGET_MAXLEN+1);
  u8buf = linebuf;
  assert(l1buf!=NULL);
  assert(u8buf!=NULL);
}

#define FILTER_CLEANUP filter_cleanup();
void filter_cleanup(void)
{
  if (l1buf) ux_buffer_free(l1buf,1);
  //if (u8buf) ux_buffer_free(u8buf,0);
}


//--------------------------------------------------------------
// Filter: filter line

#define FILTER_CODE filter_line()
void filter_line(void)
{
  l1buf->len=0;
  ux_unidecode_us(&UNIDECODE_LATIN1, u8buf, l1buf);
  ux_buffer_fwrite(l1buf, f_out);
}

/*======================================================================
 * MAIN
 */
#include "filter-main.c"
