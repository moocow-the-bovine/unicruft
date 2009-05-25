/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: utf8-de-pp.c
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: utf8 -> latin1/de: preprocessor
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
#define OUTFILE_HELP "UTF-8/de output file"

//--------------------------------------------------------------
// Filter: Globals
uxBuffer *ibuf=NULL;
uxBuffer *obuf=NULL;
uxDEpp   *pp=NULL;

#define OBUFSIZE 8192

//--------------------------------------------------------------
// Filter: Init & Cleanup
#define FILTER_INIT filter_init();
void filter_init(void)
{
  ibuf = linebuf;
  obuf = ux_buffer_new(NULL,0,OBUFSIZE);
  pp   = ux_depp_new();
  assert(ibuf!=NULL);
  assert(obuf!=NULL);
  assert(pp!=NULL);
}

#define FILTER_CLEANUP filter_cleanup();
void filter_cleanup(void)
{
  //if (ibuf) ux_buffer_free(ibuf,0);
  if (obuf) ux_buffer_free(obuf,1);
}

//--------------------------------------------------------------
// Filter: filter line

#define FILTER_CODE filter_line()
void filter_line(void)
{
  obuf->len=0;
  ux_depp_scan_buffer(pp,ibuf,obuf);
  ux_buffer_fwrite(obuf, f_out);
}

/*======================================================================
 * MAIN
 */
#include "filter-main.c"
