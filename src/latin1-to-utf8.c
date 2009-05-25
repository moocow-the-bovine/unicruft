/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: latin1-to-utf8.c
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: latin1 -> utf8: filter
 *--------------------------------------------------------------------------*/

#include "unicruft.h"
#include "uxConfig.h"
#include "uxBuffer.h"

#define FILTER_MAIN main
#include "filter-main.h"

/*======================================================================
 * Filter
 */

//--------------------------------------------------------------
// Filter: Help
#define INFILE_HELP "Latin-1 input file"
#define OUTFILE_HELP "UTF-8 output file"

//--------------------------------------------------------------
// Filter: Globals
uxBuffer *l1buf = NULL;
uxBuffer *u8buf = NULL;
#define BUFSIZE 8192

//--------------------------------------------------------------
// Filter: Init & Cleanup

#define FILTER_INIT    filter_init();
void filter_init(void)
{
  l1buf = linebuf;
  u8buf = ux_buffer_new(NULL,0,BUFSIZE);
  assert(l1buf!=NULL);
  assert(u8buf!=NULL);
}

#define FILTER_CLEANUP filter_cleanup();
void filter_cleanup(void)
{
  //if (l1buf) ux_buffer_free(l1buf,0);
  if (u8buf) ux_buffer_free(u8buf,1);
}

//--------------------------------------------------------------
// Filter: filter line

void filter_line(void)
{
  u8buf->len = 0;
  ux_buffer_latin1_to_utf8(l1buf, u8buf);
  ux_buffer_fwrite(u8buf, f_out);
}
#define FILTER_CODE filter_line();

/*======================================================================
 * MAIN
 */
#include "filter-main.c"
