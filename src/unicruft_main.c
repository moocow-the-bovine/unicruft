/* -*- Mode: C; coding: UTF-8 -*- */

#ifdef HAVE_CONFIG_H
# include <config.h>
#endif

#include <unicruft.h>
#include "unicruft_cmdparser.h"

#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>


/*--------------------------------------------------------------------------
 * Types
 */

typedef enum {
  uxmUtf8ToAscii,
  uxmUtf8ToLatin1,
  uxmUtf8DEpp,
  uxmUtf8ToLatin1DE,
  uxmLatin1ToUtf8
  /*, ... more here */
} uxMode;

/*--------------------------------------------------------------------------
 * Globals
 */
char *progname = "gfsmintersect";

//-- options
struct gengetopt_args_info args;

//-- files
const char *filename_in  = NULL;
const char *filename_out = "-";

FILE *f_in  = NULL;
FILE *f_out = NULL;

//-- buffers
uxBuffer *ibuf = NULL;
uxBuffer *obuf = NULL;
uxDEpp   *pp   = NULL;

//-- conversion mode
uxMode mode = uxmUtf8ToAscii;

#define INITIAL_BUFFER_SIZE 8192

/*--------------------------------------------------------------------------
 * Option Processing
 */
void get_my_options(int argc, char **argv)
{
  if (cmdline_parser(argc, argv, &args) != 0)
    exit(1);

  //-- conversion mode
  if      (strcmp(args.mode_arg, "ua")==0) mode=uxmUtf8ToAscii;
  else if (strcmp(args.mode_arg, "ul")==0) mode=uxmUtf8ToLatin1;
  else if (strcmp(args.mode_arg, "ud")==0) mode=uxmUtf8ToLatin1DE;
  else if (strcmp(args.mode_arg, "udpp")==0) mode=uxmUtf8DEpp;
  else if (strcmp(args.mode_arg, "lu")==0)  mode=uxmLatin1ToUtf8;
  else {
    fprintf(stderr, "%s: Error: unknown conversion mode '%s'!\n", progname, args.mode_arg);
    exit(2);
  }

  //-- output file
  if (args.output_arg) filename_out = args.output_arg;
  if (strcmp(filename_out,"-")==0) {
    f_out = stdout;
  } else if  ( !(f_out=fopen(filename_out,"wb")) ) {
    fprintf(stderr, "%s: open failed for output file `%s': %s\n", progname, filename_out, strerror(errno));
    exit(1);
  }
}

/*--------------------------------------------------------------------------
 * prepare()
 */
void unicruft_prepare(void)
{
  ibuf = ux_buffer_new(NULL,0,INITIAL_BUFFER_SIZE);
  obuf = ux_buffer_new(NULL,0,INITIAL_BUFFER_SIZE);
  pp   = ux_depp_new();
  assert(ibuf != NULL);
  assert(obuf != NULL);
  assert(pp   != NULL);
}

void unicruft_cleanup(void)
{
  if (ibuf) ux_buffer_free(ibuf,1);
  if (obuf) ux_buffer_free(obuf,1);
  if (pp)   ux_depp_free(pp);
}

/*--------------------------------------------------------------------------
 * MODE_process_file()
 */

//--------------------------------------------------------------
void utf8_to_ascii_process_file(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len=0;
    ux_unidecode_us(NULL, ibuf, obuf);
    ux_buffer_fwrite(obuf, f_out);
  }
}

//--------------------------------------------------------------
void utf8_to_latin1_process_file(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len=0;
    ux_unidecode_us(&UNIDECODE_LATIN1, ibuf, obuf);
    ux_buffer_fwrite(obuf, f_out);
  }
}

//--------------------------------------------------------------
void utf8_de_pp_process_file(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len=0;
    ux_depp_scan_buffer(pp, ibuf, obuf);
    ux_buffer_fwrite(obuf, f_out);
  }
}

//--------------------------------------------------------------
void utf8_to_latin1_de_process_file(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len=0;
    ux_depp_scan_buffer(pp,ibuf,obuf);
    ux_buffer_append_char(obuf,'\0');
    obuf->len--;

    ibuf->len=0;
    ux_unidecode_us(&UNIDECODE_LATIN1, obuf, ibuf);

    ux_buffer_fwrite(ibuf, f_out);
  }
}

//--------------------------------------------------------------
void latin1_to_utf8_process_file(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len = 0;
    ux_buffer_latin1_to_utf8(ibuf, obuf);
    ux_buffer_fwrite(obuf, f_out);
  }
}

/*--------------------------------------------------------------------------
 * process_file()
 */
void unicruft_process_file(const char *filename)
{
  //-- open file
  filename_in = filename;
  if (!filename_in || strcmp(filename_in,"-")==0) {
    filename_in = "-";
    f_in = stdin;
  } else if ( !(f_in=fopen(filename_in,"rb")) ) {
    fprintf(stderr, "%s: open failed for input file `%s': %s\n", progname, filename_in, strerror(errno));
    exit(3);
  }
  
  //-- process
  switch (mode) {
  case uxmUtf8ToAscii:
    utf8_to_ascii_process_file();
    break;
  case uxmUtf8ToLatin1:
    utf8_to_latin1_process_file();
    break;
  case uxmUtf8DEpp:
    utf8_de_pp_process_file();
    break;
  case uxmUtf8ToLatin1DE:
    utf8_to_latin1_de_process_file();
    break;
  case uxmLatin1ToUtf8:
    latin1_to_utf8_process_file();
    break;
  //... more here ...
  default:
    fprintf(stderr, "%s: error unknown mode `%d'\n", progname, mode);
    exit(255);
  }

  //-- close
  if (f_in && f_in != stdin) fclose(f_in);
}

/*--------------------------------------------------------------------------
 * MAIN
 */
int main (int argc, char **argv)
{
  unsigned int i;
  get_my_options(argc,argv);

  //-- prepare buffer
  unicruft_prepare();

  //-- loop over files
  if (args.inputs_num==0) {
    unicruft_process_file("-");
  } else {
    for (i = 0; i < args.inputs_num; i++) {
      unicruft_process_file(args.inputs[i]);
    }
  }

  //-- cleanup
  unicruft_cleanup();

  return 0;
}
