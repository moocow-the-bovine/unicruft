/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: filter-main.h
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: utf8 -> latin1: filter programs: main
 * Usage:
 *   + To create a simple C filter program, write a 'myfilter.c' file with:
 *     #define INFILE_HELP "help string for input file"
 *     #define OUTFILE_HELP "help string for output file"
 *     #define FILTER_INIT    INIT_CODE
 *     #define FILTER_CODE    CODE_FOR_FILTER
 *     #define FILTER_CLEANUP CLEANUP_CODE
 *   + CODE_FOR_FILTER may use global variables defined in filter-main.h
 *   + then just #include "filter-main.c" into 'myfilter.c'
 *--------------------------------------------------------------------------*/
/** \file
 *  \brief declarations and prototypes for generic filters using filter-main.c
 */

#ifndef UX_FILTER_MAIN_H
#define UX_FILTER_MAIN_H

#include <stdio.h>
#include <stdlib.h>

#include "config.h"
#include "unicruft.h"

/*======================================================================
 * Globals
 */
extern const char *prog;         //-- program name

#define FILTER_INITIAL_LINEBUF_SIZE 8192
extern uxBuffer *linebuf;        //-- input line-buffer

extern FILE *f_in;               //-- input file
extern FILE *f_out;              //-- output file

extern const char *filename_in;  //-- input filename
extern const char *filename_out; //-- output filename

#ifdef FILTER_MAIN
extern int FILTER_MAIN (int argc, const char **argv);
#endif

#endif /* UX_FILTER_MAIN_H */
