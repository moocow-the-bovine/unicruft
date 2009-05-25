/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: utf8-to-latin1-de.c
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: utf8 -> latin1/de+pp: filter
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
#define OUTFILE_HELP "Latin-1/DE output file"

//--------------------------------------------------------------
// Filter: Globals
uxBuffer *buf1=NULL;
uxBuffer *buf2=NULL;
uxDEpp   *pp=NULL;

#define OBUFSIZE 8192

//--------------------------------------------------------------
// Filter: Init & Cleanup
#define FILTER_INIT filter_init();
void filter_init(void)
{
  buf1 = linebuf;
  buf2 = ux_buffer_new(NULL,0,OBUFSIZE);
  pp   = ux_depp_new();
  assert(buf1!=NULL);
  assert(buf2!=NULL);
  assert(pp!=NULL);
}

#define FILTER_CLEANUP filter_cleanup();
void filter_cleanup(void)
{
  //if (buf1) ux_buffer_free(buf1,0);
  if (buf2) ux_buffer_free(buf2,1);
}


//--------------------------------------------------------------
// Filter: filter line

#define FILTER_CODE filter_line()
void filter_line(void)
{
  buf2->len=0;
  ux_depp_scan_buffer(pp,buf1,buf2);

  buf1->len=0;
  ux_unidecode_us(&UNIDECODE_LATIN1, buf2, buf1);

  ux_buffer_fwrite(buf1, f_out);
}

/*======================================================================
 * MAIN
 */
#include "filter-main.c"
