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
  uxmLatin1ToUtf8,      //-- "lu"   : latin1 -> utf8
  uxmUtf8ToAscii,       //-- "ua"   : utf8   -> ascii
  uxmUtf8ToLatin1,      //-- "ul"   : utf8   -> latin1
  uxmUtf8ToLatin1_DE,   //-- "ud"   : utf8   -> latin1/de
  uxmUtf8ToUtf8_Latin1, //-- "uL"   : utf8   -> utf8/latin1
  uxmUtf8ToUtf8_DE,     //-- "uD"   : utf8   -> utf8/de
  uxmUtf8ToUtf8_DE_pp   //-- "uDpp" : utf8   -> utf8/de-pp
  /*, ... more here */
} uxMode;

/*--------------------------------------------------------------------------
 * Globals
 */
const char *progname = "unicruft";

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
  if      (strcmp(args.mode_arg, "lu")==0) mode=uxmLatin1ToUtf8;
  else if (strcmp(args.mode_arg, "ua")==0) mode=uxmUtf8ToAscii;
  else if (strcmp(args.mode_arg, "ul")==0) mode=uxmUtf8ToLatin1;
  else if (strcmp(args.mode_arg, "ud")==0) mode=uxmUtf8ToLatin1_DE;
  else if (strcmp(args.mode_arg, "uL")==0) mode=uxmUtf8ToUtf8_Latin1;
  else if (strcmp(args.mode_arg, "uD")==0) mode=uxmUtf8ToUtf8_DE;
  else if (strcmp(args.mode_arg, "uDpp")==0) mode=uxmUtf8ToUtf8_DE_pp;
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
 * MODE_main()
 */

//--------------------------------------------------------------
void latin1_to_utf8_main(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len = 0;
    ux_buffer_latin1_to_utf8(ibuf, obuf);
    ux_buffer_fwrite(obuf, f_out);
  }
}

//--------------------------------------------------------------
void utf8_to_ascii_main(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len=0;
    ux_unidecode_us(NULL, ibuf, obuf);
    ux_buffer_fwrite(obuf, f_out);
  }
}

//--------------------------------------------------------------
void utf8_to_latin1_main(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len=0;
    ux_unidecode_us(&UNIDECODE_LATIN1, ibuf, obuf);
    ux_buffer_fwrite(obuf, f_out);
  }
}


//--------------------------------------------------------------
void utf8_to_utf8_latin1_main(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len=0;
    ux_unidecode_us(&UNIDECODE_LATIN1, ibuf, obuf);
    ux_buffer_append_delim(obuf,'\0'); //-- we need this because uxUtf8.c scans to next char to find sequence lengths

    ibuf->len=0;
    ux_buffer_latin1_to_utf8(obuf,ibuf);
    ux_buffer_fwrite(ibuf, f_out);
  }
}

//--------------------------------------------------------------
void utf8_to_utf8_de_pp_main(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len=0;
    ux_depp_scan_buffer(pp, ibuf, obuf);
    ux_buffer_fwrite(obuf, f_out);
  }
}

//--------------------------------------------------------------
void utf8_to_latin1_de_main(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len=0;
    ux_depp_scan_buffer(pp,ibuf,obuf);
    ux_buffer_append_delim(obuf,'\0'); //-- we need this because uxUtf8.c scans to next char to find sequence lengths

    ibuf->len=0;
    ux_unidecode_us(&UNIDECODE_LATIN1, obuf, ibuf);
    ux_buffer_fwrite(ibuf, f_out);
  }
}

//--------------------------------------------------------------
void utf8_to_utf8_de_main(void)
{
  while ( ux_buffer_getline(ibuf,f_in) >= 0 ) {
    obuf->len=0;
    ux_depp_scan_buffer(pp,ibuf,obuf);
    ux_buffer_append_delim(obuf,'\0'); //-- we need this because uxUtf8.c scans to next char to find sequence lengths

    ibuf->len=0;
    ux_unidecode_us(&UNIDECODE_LATIN1, obuf, ibuf);
    ux_buffer_append_delim(ibuf,'\0'); //-- ... again

    obuf->len=0;
    ux_buffer_latin1_to_utf8(ibuf,obuf);
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
  case uxmLatin1ToUtf8:
    latin1_to_utf8_main();
    break;
  case uxmUtf8ToAscii:
    utf8_to_ascii_main();
    break;
  case uxmUtf8ToLatin1:
    utf8_to_latin1_main();
    break;
  case uxmUtf8ToLatin1_DE:
    utf8_to_latin1_de_main();
    break;
  case uxmUtf8ToUtf8_Latin1:
    utf8_to_utf8_latin1_main();
    break;
  case uxmUtf8ToUtf8_DE:
    utf8_to_utf8_de_main();
    break;
  case uxmUtf8ToUtf8_DE_pp:
    utf8_to_utf8_de_pp_main();
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
