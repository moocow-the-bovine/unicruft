/* -*- Mode: Flex; coding: utf-8 -*- */

/*======================================================================
 * Flex Options
 */

/*-- automake handles output file for us --*/
/*%option outfile="uxDEyy.c"*/
%option outfile="lex.yy.c" 

/*-- ... but not the header-file ... --*/
%option header-file="uxDEyy.h"

%option 8bit
%option reentrant
%option prefix="ux_de_yy"
%option full
/*%option fast*/
/*%option debug*/
/*%option perf-report*/
/*%option trace*/

%top{

/*======================================================================
 * flex %top section, copied to generated header
 */
/** \file uxDEyy.h
 *  \brief low-level flex scanner header for latin1/de preprocessor
 */

#include <uxBuffer.h>

#ifndef UX_DE_YY_HAVE_DATA_DECL
#define UX_DE_YY_HAVE_DATA_DECL

/** \brief latin/DE preprocessor flex scanner data */
typedef struct {
  uxBuffer *obuf;    ///< \details output buffer
} uxDEyyData;

/** \struct yy_buffer_state
 *  \brief low-level flex input buffer struct
 */

#endif /* UX_DE_YY_HAVE_DATA_DECL */

}

%{
/*======================================================================
 * User C-file definitions & prototypes
 */

#undef yywrap
static int ux_de_yywrap(yyscan_t yyscanner);

#define YY_EXTRA_TYPE uxDEyyData*

/** flex utility: output a single character */
static inline
void ux_deyy_putc(uxDEyyData *data, char c)
{
  //ux_buffer_append_char(pp->obuf, c);
  data->obuf->str[data->obuf->len++] = c;
}

/** flex utility: output binary bytes */
static inline
void ux_deyy_putbytes(uxDEyyData *data, const char *bytes, size_t len)
{
  //ux_buffer_append_data(data->obuf, bytes, len);
  memcpy(data->obuf->str+data->obuf->len, bytes, len);
  data->obuf->len += len;
}

/** flex utility: output NUL-terminated string */
static inline
void ux_deyy_puts(uxDEyyData *data, const char *s)
{
  //ux_buffer_append_str(data->obuf, s);
  ux_deyy_putbytes(data, s, strlen(s));
}

/** Utility macro: output a single character */
#define MAPTOC(c) ux_deyy_putc(yyextra,(c))

/** Utility macro: output a byte string */
#define MAPTOS(str,len) ux_deyy_putbytes(yyextra,(str),(len))

%}

/*======================================================================
 * Start States
 */

/*%s XOFF XLEN TOFF TLEN TEXT ATEOF*/

/*======================================================================
 * Flex Definitions
 */

/*--------------------------------------------------------------
 * DIACRITICS
 */
/* L_UMLAUT: U+00a8: latin-1 DIAERESIS (UMLAUT) */
L_UMLAUT (\xC2\xA8)

/* C_UMLAUT: U+00308 COMBINING LATIN DIAERESIS (UMLAUT) ABOVE */
C_UMLAUT (\xCC\x88)

/* UMLAUT: either of the above uml�ute ... */
UMLAUT  ({L_UMLAUT}|{C_UMLAUT})

/* U_CIRC: U+0302: COMBINING CIRCUMFLEX ACCENT (^) ABOVE */
L_CIRC (^)
C_CIRC (\xcc\x82)
 /*CIRC   ({L_CIRC}|{C_CIRC})*/
CIRC {C_CIRC}

/*--------------------------------------------------------------
 * Combining Letters
 */
/* CC_A: U+0363: COMBINING LATIN SMALL LETTER A */
CC_A (\xcd\xa3)

/* CC_E: U+0364: COMBINING LATIN SMALL LETTER E */
CC_E (\xcd\xa4)

/* CC_I: U+0365: COMBINING LATIN SMALL LETTER I */
CC_I (\xcd\xa5)

/* CC_O: U+0366: COMBINING LATIN SMALL LETTER O */
CC_O (\xcd\xa6)

/* CC_U: U+0367: COMBINING LATIN SMALL LETTER U */
CC_U (\xcd\xa7)

/* CC_C: U+0368: COMBINING LATIN SMALL LETTER C */
CC_C (\xcd\xa8)

/* CC_D: U+0369: COMBINING LATIN SMALL LETTER D */
CC_D (\xcd\xa9)

/* CC_H: U+036A: COMBINING LATIN SMALL LETTER H */
CC_H (\xcd\xaa)

/* CC_M: U+036B: COMBINING LATIN SMALL LETTER M */
CC_M (\xcd\xab)

/* CC_R: U+036C: COMBINING LATIN SMALL LETTER R */
CC_R (\xcd\xac)

/* CC_T: U+036D: COMBINING LATIN SMALL LETTER T */
CC_T (\xcd\xad)

/* CC_V: U+036E: COMBINING LATIN SMALL LETTER V */
CC_V (\xcd\xae)

/* CC_X: U+036F: COMBINING LATIN SMALL LETTER X */
CC_X (\xcd\xaf)

/*======================================================================
 * Flex Rules
 */
%%

 /*-------------------------------------------------------------
  * EOF
  */
<<EOF>>     { return 0; }

 /*-------------------------------------------------------------
  * Umlaute
  */
A{UMLAUT}   { MAPTOS("\xC3\x84",2); }
O{UMLAUT}   { MAPTOS("\xC3\x96",2); }
U{UMLAUT}   { MAPTOS("\xC3\x9C",2); }
a{UMLAUT}   { MAPTOS("\xC3\xA4",2); }
o{UMLAUT}   { MAPTOS("\xC3\xB6",2); }
u{UMLAUT}   { MAPTOS("\xC3\xBC",2); }
{UMLAUT}    { ; }

 /*-------------------------------------------------------------
  * Circumflex
  */
U{CIRC}     { MAPTOS("AU",2); }
u{CIRC}     { MAPTOS("au",2); }
{CIRC}      { ; }

 /*-------------------------------------------------------------
  * Combining Letters
  */
{CC_A} { MAPTOC('a'); }
{CC_E} { MAPTOC('e'); }
{CC_I} { MAPTOC('i'); }
{CC_O} { MAPTOC('o'); }
{CC_U} { MAPTOC('u'); }
{CC_C} { MAPTOC('c'); }
{CC_D} { MAPTOC('d'); }
{CC_H} { MAPTOC('h'); }
{CC_M} { MAPTOC('m'); }
{CC_R} { MAPTOC('r'); }
{CC_T} { MAPTOC('t'); }
{CC_V} { MAPTOC('v'); }
{CC_X} { MAPTOC('x'); }

 /*-------------------------------------------------------------
  * BLOCK: Latin-1 Supplement
  */
 /* + see also:
  *  ./uxTableLatinDE.c
  *  ../gen/latin1-de-maketable.perl
  *  ../gen/latin-de-xlate.csv
  *  ../gen/latin1-de-table.PL
  */
\xC2\xA0 { MAPTOC(' '          ); } /*-- U+00A0 (�  ->   ): NO-BREAK SPACE                             --*/
\xC2\xA1 { MAPTOC('!'          ); } /*-- U+00A1 (�¡ -> ! ): INVERTED EXCLAMATION MARK                  --*/
\xC2\xAA { MAPTOC('a'          ); } /*-- U+00AA (�ª -> a ): FEMININE ORDINAL INDICATOR                 --*/
\xC2\xB1 { MAPTOS("+/-"     , 3); } /*-- U+00B1 (�± -> +/-): PLUS-MINUS SIGN                           --*/
\xC2\xB2 { MAPTOC('2'          ); } /*-- U+00B2 (�² -> 2 ): SUPERSCRIPT TWO                            --*/
\xC2\xB3 { MAPTOC('3'          ); } /*-- U+00B3 (�³ -> 3 ): SUPERSCRIPT THREE                          --*/
\xC2\xB5 { MAPTOC('u'          ); } /*-- U+00B5 (�µ -> u ): MICRO SIGN                                 --*/
\xC2\xB9 { MAPTOC('1'          ); } /*-- U+00B9 (�¹ -> 1 ): SUPERSCRIPT ONE                            --*/
\xC2\xBA { MAPTOC('o'          ); } /*-- U+00BA (�º -> o ): MASCULINE ORDINAL INDICATOR                --*/
\xC2\xBC { MAPTOS("1/4"     , 3); } /*-- U+00BC (�¼ -> 1/4): VULGAR FRACTION ONE QUARTER               --*/
\xC2\xBD { MAPTOS("1/2"     , 3); } /*-- U+00BD (�½ -> 1/2): VULGAR FRACTION ONE HALF                  --*/
\xC2\xBE { MAPTOS("3/4"     , 3); } /*-- U+00BE (�¾ -> 3/4): VULGAR FRACTION THREE QUARTERS            --*/
\xC2\xBF { MAPTOC('?'          ); } /*-- U+00BF (�¿ -> ? ): INVERTED QUESTION MARK                     --*/
\xC3\x80 { MAPTOC('A'          ); } /*-- U+00C0 (À -> A ): LATIN CAPITAL LETTER A WITH GRAVE          --*/
\xC3\x81 { MAPTOC('A'          ); } /*-- U+00C1 (Á -> A ): LATIN CAPITAL LETTER A WITH ACUTE          --*/
\xC3\x82 { MAPTOC('A'          ); } /*-- U+00C2 (Â -> A ): LATIN CAPITAL LETTER A WITH CIRCUMFLEX     --*/
\xC3\x83 { MAPTOC('A'          ); } /*-- U+00C3 (Ã -> A ): LATIN CAPITAL LETTER A WITH TILDE          --*/
\xC3\x85 { MAPTOC('A'          ); } /*-- U+00C5 (Å -> A ): LATIN CAPITAL LETTER A WITH RING ABOVE     --*/
\xC3\x86 { MAPTOS("AE"      , 2); } /*-- U+00C6 (Æ -> AE): LATIN CAPITAL LETTER AE                    --*/
\xC3\x87 { MAPTOC('C'          ); } /*-- U+00C7 (Ç -> C ): LATIN CAPITAL LETTER C WITH CEDILLA        --*/
\xC3\x88 { MAPTOC('E'          ); } /*-- U+00C8 (È -> E ): LATIN CAPITAL LETTER E WITH GRAVE          --*/
\xC3\x89 { MAPTOC('E'          ); } /*-- U+00C9 (É -> E ): LATIN CAPITAL LETTER E WITH ACUTE          --*/
\xC3\x8A { MAPTOC('E'          ); } /*-- U+00CA (Ê -> E ): LATIN CAPITAL LETTER E WITH CIRCUMFLEX     --*/
\xC3\x8B { MAPTOC('E'          ); } /*-- U+00CB (Ë -> E ): LATIN CAPITAL LETTER E WITH DIAERESIS      --*/
\xC3\x8C { MAPTOC('I'          ); } /*-- U+00CC (Ì -> I ): LATIN CAPITAL LETTER I WITH GRAVE          --*/
\xC3\x8D { MAPTOC('I'          ); } /*-- U+00CD (Í -> I ): LATIN CAPITAL LETTER I WITH ACUTE          --*/
\xC3\x8E { MAPTOS("EI"      , 2); } /*-- U+00CE (Î -> EI): LATIN CAPITAL LETTER I WITH CIRCUMFLEX     --*/
\xC3\x8F { MAPTOC('i'          ); } /*-- U+00CF (Ï -> i ): LATIN CAPITAL LETTER I WITH DIAERESIS      --*/
\xC3\x90 { MAPTOC('D'          ); } /*-- U+00D0 (Ð -> D ): LATIN CAPITAL LETTER ETH                   --*/
\xC3\x91 { MAPTOC('N'          ); } /*-- U+00D1 (Ñ -> N ): LATIN CAPITAL LETTER N WITH TILDE          --*/
\xC3\x92 { MAPTOC('O'          ); } /*-- U+00D2 (Ò -> O ): LATIN CAPITAL LETTER O WITH GRAVE          --*/
\xC3\x93 { MAPTOC('O'          ); } /*-- U+00D3 (Ó -> O ): LATIN CAPITAL LETTER O WITH ACUTE          --*/
\xC3\x94 { MAPTOC('O'          ); } /*-- U+00D4 (Ô -> O ): LATIN CAPITAL LETTER O WITH CIRCUMFLEX     --*/
\xC3\x95 { MAPTOC('O'          ); } /*-- U+00D5 (Õ -> O ): LATIN CAPITAL LETTER O WITH TILDE          --*/
\xC3\x97 { MAPTOC('x'          ); } /*-- U+00D7 (× -> x ): MULTIPLICATION SIGN                        --*/
\xC3\x98 { MAPTOS("\xc3\x96", 2); } /*-- U+00D8 (Ø -> Ö): LATIN CAPITAL LETTER O WITH STROKE         --*/
\xC3\x99 { MAPTOC('U'          ); } /*-- U+00D9 (Ù -> U ): LATIN CAPITAL LETTER U WITH GRAVE          --*/
\xC3\x9A { MAPTOC('U'          ); } /*-- U+00DA (Ú -> U ): LATIN CAPITAL LETTER U WITH ACUTE          --*/
\xC3\x9B { MAPTOS("AU"      , 2); } /*-- U+00DB (Û -> AU): LATIN CAPITAL LETTER U WITH CIRCUMFLEX     --*/
\xC3\x9D { MAPTOC('Y'          ); } /*-- U+00DD (Ý -> Y ): LATIN CAPITAL LETTER Y WITH ACUTE          --*/
\xC3\x9E { MAPTOS("Th"      , 2); } /*-- U+00DE (Þ -> Th): LATIN CAPITAL LETTER THORN                 --*/
\xC3\xA0 { MAPTOC('a'          ); } /*-- U+00E0 (�  -> a ): LATIN SMALL LETTER A WITH GRAVE            --*/
\xC3\xA1 { MAPTOC('a'          ); } /*-- U+00E1 (�¡ -> a ): LATIN SMALL LETTER A WITH ACUTE            --*/
\xC3\xA2 { MAPTOC('a'          ); } /*-- U+00E2 (�¢ -> a ): LATIN SMALL LETTER A WITH CIRCUMFLEX       --*/
\xC3\xA3 { MAPTOC('a'          ); } /*-- U+00E3 (�£ -> a ): LATIN SMALL LETTER A WITH TILDE            --*/
\xC3\xA5 { MAPTOC('a'          ); } /*-- U+00E5 (�¥ -> a ): LATIN SMALL LETTER A WITH RING ABOVE       --*/
\xC3\xA6 { MAPTOS("ae"      , 2); } /*-- U+00E6 (�¦ -> ae): LATIN SMALL LETTER AE                      --*/
\xC3\xA7 { MAPTOC('c'          ); } /*-- U+00E7 (�§ -> c ): LATIN SMALL LETTER C WITH CEDILLA          --*/
\xC3\xA8 { MAPTOC('e'          ); } /*-- U+00E8 (�¨ -> e ): LATIN SMALL LETTER E WITH GRAVE            --*/
\xC3\xA9 { MAPTOC('e'          ); } /*-- U+00E9 (�© -> e ): LATIN SMALL LETTER E WITH ACUTE            --*/
\xC3\xAA { MAPTOC('e'          ); } /*-- U+00EA (�ª -> e ): LATIN SMALL LETTER E WITH CIRCUMFLEX       --*/
\xC3\xAB { MAPTOC('e'          ); } /*-- U+00EB (�« -> e ): LATIN SMALL LETTER E WITH DIAERESIS        --*/
\xC3\xAC { MAPTOC('i'          ); } /*-- U+00EC (�¬ -> i ): LATIN SMALL LETTER I WITH GRAVE            --*/
\xC3\xAD { MAPTOC('i'          ); } /*-- U+00ED (�­ -> i ): LATIN SMALL LETTER I WITH ACUTE            --*/
\xC3\xAE { MAPTOS("ei"      , 2); } /*-- U+00EE (�® -> ei): LATIN SMALL LETTER I WITH CIRCUMFLEX       --*/
\xC3\xAF { MAPTOC('i'          ); } /*-- U+00EF (�¯ -> i ): LATIN SMALL LETTER I WITH DIAERESIS        --*/
\xC3\xB0 { MAPTOC('d'          ); } /*-- U+00F0 (�° -> d ): LATIN SMALL LETTER ETH                     --*/
\xC3\xB1 { MAPTOC('n'          ); } /*-- U+00F1 (�± -> n ): LATIN SMALL LETTER N WITH TILDE            --*/
\xC3\xB2 { MAPTOC('o'          ); } /*-- U+00F2 (�² -> o ): LATIN SMALL LETTER O WITH GRAVE            --*/
\xC3\xB3 { MAPTOC('o'          ); } /*-- U+00F3 (�³ -> o ): LATIN SMALL LETTER O WITH ACUTE            --*/
\xC3\xB4 { MAPTOC('o'          ); } /*-- U+00F4 (�´ -> o ): LATIN SMALL LETTER O WITH CIRCUMFLEX       --*/
\xC3\xB5 { MAPTOC('o'          ); } /*-- U+00F5 (�µ -> o ): LATIN SMALL LETTER O WITH TILDE            --*/
\xC3\xB8 { MAPTOS("\xc3\xb6", 2); } /*-- U+00F8 (�¸ -> �¶): LATIN SMALL LETTER O WITH STROKE           --*/
\xC3\xB9 { MAPTOC('u'          ); } /*-- U+00F9 (�¹ -> u ): LATIN SMALL LETTER U WITH GRAVE            --*/
\xC3\xBA { MAPTOC('u'          ); } /*-- U+00FA (�º -> u ): LATIN SMALL LETTER U WITH ACUTE            --*/
\xC3\xBB { MAPTOS("au"      , 2); } /*-- U+00FB (�» -> au): LATIN SMALL LETTER U WITH CIRCUMFLEX       --*/
\xC3\xBD { MAPTOC('y'          ); } /*-- U+00FD (�½ -> y ): LATIN SMALL LETTER Y WITH ACUTE            --*/
\xC3\xBE { MAPTOS("th"      , 2); } /*-- U+00FE (�¾ -> th): LATIN SMALL LETTER THORN                   --*/
\xC3\xBF { MAPTOC('y'          ); } /*-- U+00FF (�¿ -> y ): LATIN SMALL LETTER Y WITH DIAERESIS        --*/

 /*-------------------------------------------------------------
  * DEFAULT: pass-through
  */
.|\n|\r { MAPTOC(yytext[0]); }

%%

/*======================================================================
 * User C Code
 */

static int ux_de_yywrap(yyscan_t yyscanner)
{
  return 1;
}

//#define uxDEMAIN
#ifdef uxDEMAIN
int main (void)
{
  yyscan_t scanner;
  yylex_init(&scanner);
  yyset_in(stdin, scanner);
  yyset_out(stdout, scanner);

  yylex(scanner);

  yylex_destroy(scanner);
  return 0;
}
#endif