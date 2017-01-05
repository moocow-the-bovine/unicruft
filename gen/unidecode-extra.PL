## -*- Mode: CPerl; coding: utf-8 -*-
##
## File: unidecode-extra.PL
## Author: Bryan Jurish <jurish@bbaw.de>
## Description: overrides for unidecode-table2c.perl (utf8->ascii table)
##  + include this file in your call to unidecode-table2c.perl, e.g.:
##    $ ./unidecode-table2c.perl -I unidecode-extra.PL unidecode-table.PL -o ascii.c

$table[0xA75B] = "r";  ##-- ꝛ U+A75B: Latin Small Letter R Rotunda
$table[0x204A] = "r";  ##-- ⁊ U+204A: TIRONIAN SIGN ET (approximates r rotunda in early DTA texts)

$table[0x06E5] = "'";  ##-- ۥ Arabic / ARABIC SMALL WAW

$table[0x20AC] = "EUR";  ##-- Currency Symbols / EURO SIGN
$table[0x20B0] = "Pf"; ##-- ₰ Currency Symbols / German Penns Sign
$table[0x20B1] = "P"; ##-- ₱ Currency Symbols / Peso Sign (Phillipines)
$table[0x20B2] = "G"; ##-- ₲ Currency Symbols / Guarani Sign (Paraguay)
$table[0x20B3] = "A"; ##-- ₳ Currency Symbols / Austral Sign (Argentinia)
$table[0x20B4] = "H"; ##-- ₴ Currency Symbols / Hryvnia Sign (Ukraine)
$table[0x20B5] = "C"; ##-- ₵ Currency Symbols / Cedi Sign (Ghana)
$table[0x20B6] = "lt"; ##-- ₶ Currency Symbols / Livre Tournois Sign (13th-18th Century France)
$table[0x20B7] = "S"; ##-- ₷ Currency Symbols / Spesmilo Sign (historical, Esperonto)
$table[0x20B8] = "T"; ##-- ₸ Currency Symbols / Tenge Sign (Kazakhstan)

$table[0x221A] = "sqrt";      ##-- √ Mathematical Operators / SQUARE ROOT
$table[0x2114] = "Lb";        ##-- ℔ Letterlike Symbols / L B BAR SYMBOL
$table[0x222b] = "integral";  ##-- ∫ Mathematical Operators / INTEGRAL
$table[0x2609] = "Sun";       ##-- ☉ Miscellaneous Symbols / SUN
$table[0x2643] = "Jupiter";   ##-- ♃ Miscellaneous Symbols / JUPITER
$table[0x2219] = "Bullet";    ##-- ∙ Mathematical Operators / BULLET OPERATOR
$table[0x23d1] = "Breve";     ##-- ⏑ Miscellaneous Technical / METRICAL BREVE
$table[0x221e] = "infinity";  ##-- ∞ Mathematical Operators / INFINITY
$table[0x2133] = "M";         ##-- ℳ Letterlike Symbols / SCRIPT CAPITAL M
$table[0x2202] = "partial";   ##-- ∂ Mathematical Operators / PARTIAL DIFFERENTIAL

$table[0xfffc] = '@';	##-- ￼ Specials / OBJECT REPLACEMENT CHARACTER

##--------------------------------------------------------------
## latin-c additions, Fri, 24 Jan 2014 12:28:43 +0100
$table[0x2C60] = "L"; ##-- Ⱡ LATIN CAPITAL LETTER L WITH DOUBLE BAR
$tabla[0x2C61] = "l"; ##-- ⱡ LATIN SMALL LETTER L WITH DOUBLE BAR
$table[0x2C62] = "L"; ##-- Ɫ LATIN CAPITAL LETTER L WITH MIDDLE TILDE
$table[0x2C63] = "P"; ##-- Ᵽ LATIN CAPITAL LETTER P WITH STROKE
$table[0x2C64] = "R"; ##-- Ɽ LATIN CAPITAL LETTER R WITH TAIL
$table[0x2C65] = "a"; ##-- ⱥ LATIN SMALL LETTER A WITH STROKE
$table[0x2C66] = "t"; ##-- ⱦ LATIN SMALL LETTER T WITH DIAGONAL STROKE
$table[0x2C67] = "H"; ##-- Ⱨ LATIN CAPITAL LETTER H WITH DESCENDER
$table[0x2C68] = "h"; ##-- ⱨ LATIN SMALL LETTER H WITH DESCENDER
$table[0x2C69] = "K"; ##-- Ⱪ LATIN CAPITAL LETTER K WITH DESCENDER
$table[0x2C6A] = "k"; ##-- ⱪ LATIN SMALL LETTER K WITH DESCENDER
$table[0x2C6B] = "Z"; ##-- Ⱬ LATIN CAPITAL LETTER Z WITH DESCENDER
$table[0x2C6C] = "z"; ##-- ⱬ LATIN SMALL LETTER Z WITH DESCENDER
$table[0x2C6D] = "A"; ##-- Ɑ LATIN CAPITAL LETTER ALPHA
$table[0x2C6E] = "M"; ##-- Ɱ LATIN CAPITAL LETTER M WITH HOOK
$table[0x2C6F] = "A"; ##-- Ɐ LATIN CAPITAL LETTER TURNED A
$table[0x2C70] = "A"; ##-- Ɒ LATIN CAPITAL LETTER TURNED ALPHA
$table[0x2C71] = "v"; ##-- ⱱ LATIN SMALL LETTER V WITH RIGHT HOOK
$table[0x2C72] = "W"; ##-- Ⱳ LATIN CAPITAL LETTER W WITH HOOK
$table[0x2C73] = "w"; ##-- ⱳ LATIN SMALL LETTER W WITH HOOK
$table[0x2C74] = "v"; ##-- ⱴ LATIN SMALL LETTER V WITH CURL
$table[0x2C75] = "H"; ##-- Ⱶ LATIN CAPITAL LETTER HALF H
$table[0x2C76] = "h"; ##-- ⱶ LATIN SMALL LETTER HALF H
$table[0x2C77] = "ph"; ##-- ⱷ LATIN SMALL LETTER TAILLESS PHI
$table[0x2C78] = "e"; ##-- ⱸ LATIN SMALL LETTER E WITH NOTCH
$table[0x2C79] = "r"; ##-- ⱹ LATIN SMALL LETTER TURNED R WITH TAIL
$table[0x2C7A] = "o"; ##-- ⱺ LATIN SMALL LETTER O WITH LOW RING INSIDE
$table[0x2C7B] = "E"; ##-- ⱻ LATIN LETTER SMALL CAPITAL TURNED E
$table[0x2C7C] = "j"; ##-- j LATIN SUBSCRIPT SMALL LETTER J
$table[0x2C7D] = "V"; ##-- V MODIFIER LETTER CAPITAL V
$table[0x2C7E] = "S"; ##-- Ȿ LATIN CAPITAL LETTER S WITH SWASH TAIL
$table[0x2C7F] = "Z"; ##-- Ɀ LATIN CAPITAL LETTER Z

##--------------------------------------------------------------
## RIDGES stuff, 2016-01-05
$table[0x2E17] = "-"; ##-- ⸗ DOUBLE OBLIQUE HYPHEN

1; ##-- be happy
