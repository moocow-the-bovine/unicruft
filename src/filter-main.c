/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: filter-main.c
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: utf8 -> latin1: filter programs: main
 * Usage:
 *   + To create a simple C filter program, write a 'myfilter.c' file with:
 *     #define FILTER_MAIN    MAIN_FUNCNAME       //-- default: main; define this BEFORE you #include <filter-main.h>
 *     #define INFILE_HELP    "help string for input file"  //-- default: "input file"
 *     #define OUTFILE_HELP   "help string for output file" //-- default: "output file"
 *     #define FILTER_INIT    INIT_CODE           //-- default: empty
 *     #define FILTER_CODE    CODE_FOR_FILTER     //-- default: empty
 *     #define FILTER_CLEANUP CLEANUP_CODE        //-- default: empty
 *   + CODE_FOR_FILTER may use global variables defined in filter-main.h
 *   + then just #include <filter-main.c> into 'myfilter.c'
 *--------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>


#include "config.h"
#include "unicruft.h"
#include "filter-main.h"

#ifndef FILTER_CODE
# warning "FILTER_CODE undefined"
# define FILTER_CODE /*CODE:empty*/
#endif

#ifndef FILTER_INIT
# define FILTER_INIT /*INIT:empty*/
#endif

#ifndef FILTER_CLEANUP
# define FILTER_CLEANUP /*CLEANUP:empty*/
#endif

#ifndef FILTER_MAIN
# define FILTER_MAIN main
#endif

#ifndef INFILE_HELP
# warning "INFILE_HELP undefined"
# define INFILE_HELP "input file"
#endif

#ifndef OUTFILE_HELP
# warning "OUTFILE_HELP undefined"
# define OUTFILE_HELP "output file"
#endif

/*======================================================================
 * Globals
 */
const char *prog = "filter-main";

FILE *f_in = NULL;
FILE *f_out = NULL;

const char *filename_in = "-";
const char *filename_out = "-";

uxBuffer *linebuf = NULL;

/*======================================================================
 * MAIN
 */
int FILTER_MAIN (int argc, const char **argv)
{
  //-- initialization
  prog = *argv;
  linebuf = ux_buffer_new(NULL,0,FILTER_INITIAL_LINEBUF_SIZE);
  assert(linebuf!=NULL);

  //-- command-line: usage
  if (argc > 1 && (strcmp(argv[1],"-h")==0 || strcmp(argv[1],"-?")==0 || strcmp(argv[1],"--help")==0)) {
    fprintf(stderr, "(%s version %s / %s)\n", PACKAGE, PACKAGE_VERSION, PACKAGE_SVNID);
    fprintf(stderr, "Usage:\n");
    fprintf(stderr, " + %s [INFILE [OUTFILE]]\n", prog);
    fprintf(stderr, " + INFILE  : " INFILE_HELP " (default=stdin)\n");
    fprintf(stderr, " + OUTFILE : " OUTFILE_HELP " (default=stdout)\n");
    fprintf(stderr, " + \"-\" may be used in place of any filename to indicate standard (in|out)put\n");
    exit(0);
  }

  //-- command-line: input file
  if (argc > 1) {
    filename_in = argv[1];
    if ( strcmp(filename_in,"-")!=0 && !(f_in=fopen(filename_in,"rb")) ) {
      fprintf(stderr, "%s: open failed for input file `%s': %s\n", prog, filename_in, strerror(errno));
      exit(1);
    }
  } else {
    filename_in = "-";
    f_in = stdin;
  }

  //-- command-line: output file
  if (argc > 2) {
    filename_out = argv[2];
    if ( strcmp(filename_out,"-")==0 ) {
      f_out = stdout;
    }
    else if ( !(f_out=fopen(filename_out,"wb")) ) {
      fprintf(stderr, "%s: open failed for output file `%s': %s\n", prog, filename_out, strerror(errno));
      exit(1);
    }
  } else {
    filename_out = "-";
    f_out = stdout;
  }

  //-- ye olde loope
  FILTER_INIT ;
  while ( ux_buffer_getline(linebuf,f_in) >= 0 ) {
    FILTER_CODE ;
  }
  FILTER_CLEANUP ;

  //-- cleanup
  if (linebuf) { ux_buffer_free(linebuf,1); linebuf=NULL; }
  if (f_in && f_in != stdin) { fclose(f_in); f_in=NULL; }
  if (f_out && f_out != stdout) { fclose(f_out); f_out=NULL; }

  return 0;
}
