## -*- Mode: CPerl -*-
##
## File: unidecode-extra.PL
## Author: Bryan Jurish <jurish@bbaw.de>
## Description: overrides for unidecode-table2c.perl (utf8->ascii table)
##  + include this file in your call to unidecode-table2c.perl, e.g.:
##    $ ./unidecode-table2c.perl -I unidecode-extra.PL unidecode-table.PL -o ascii.c

$table[0xA75B] = "r";  ##-- U+A75B: Latin Small Letter R Rotunda
$table[0x204A] = "r";  ##-- U+204A: TIRONIAN SIGN ET (approximates r rotunda in early DTA texts)

$table[0x06E5] = "'";  ##-- Arabic / ARABIC SMALL WAW

$table[0x20B0] = "Pf"; ##-- Currency Symbols / German Penns Sign
$table[0x20B1] = "P"; ##-- Currency Symbols / Peso Sign (Phillipines)
$table[0x20B2] = "G"; ##-- Currency Symbols / Guarani Sign (Paraguay)
$table[0x20B3] = "A"; ##-- Currency Symbols / Austral Sign (Argentinia)
$table[0x20B4] = "H"; ##-- Currency Symbols / Hryvnia Sign (Ukraine)
$table[0x20B5] = "C"; ##-- Currency Symbols / Cedi Sign (Ghana)
$table[0x20B6] = "lt"; ##-- Currency Symbols / Livre Tournois Sign (13th-18th Century France)
$table[0x20B7] = "S"; ##-- Currency Symbols / Spesmilo Sign (historical, Esperonto)
$table[0x20B8] = "T"; ##-- Currency Symbols / Tenge Sign (Kazakhstan)

$table[0x221A] = "sqrt";      ##-- Mathematical Operators / SQUARE ROOT
$table[0x2114] = "Lb";        ##-- Letterlike Symbols / L B BAR SYMBOL
$table[0x222b] = "integral";  ##-- Mathematical Operators / INTEGRAL
$table[0x2609] = "Sun";       ##-- Miscellaneous Symbols / SUN
$table[0x2643] = "Jupiter";   ##-- Miscellaneous Symbols / JUPITER
$table[0x2219] = "Bullet";    ##-- Mathematical Operators / BULLET OPERATOR
$table[0x23d1] = "Breve";     ##-- Miscellaneous Technical / METRICAL BREVE
$table[0x221e] = "infinity";  ##-- Mathematical Operators / INFINITY
$table[0x2133] = "M";         ##-- Letterlike Symbols / SCRIPT CAPITAL M
$table[0x2202] = "partial";   ##-- Mathematical Operators / PARTIAL DIFFERENTIAL

$table[0xfffc] = '@';	##-- Specials / OBJECT REPLACEMENT CHARACTER

1; ##-- be happy
