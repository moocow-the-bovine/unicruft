#!/usr/bin/perl -w
#-*- coding: latin-1 -*-

use Data::Dumper;

our $MAKECSV = @ARGV && $ARGV[0] eq '-csv';

##======================================================================
## MAIN

##-- create latin-1 identity map
our @table = map {chr($_)} (0..255);

##-- kludges
my %xlate =
  (
   ' '=>' ',  '¡'=>'!',   '¢'=>'¢',   '£'=>'£',   '¤'=>'¤',   '¥'=>'¥',   '¦'=>'¦',   '§'=>'§',  ##-- 0xa0 .. 0xa7
   '¨'=>'¨',  '©'=>'©',   'ª'=>'a',   '«'=>'"',   '¬'=>'¬',   '­'=>'­',   '®'=>'®',   '¯'=>'¯',  ##-- 0xa8 .. 0xaf
   '°'=>'°',  '±'=>'+/-', '²'=>'2',   '³'=>'3',   '´'=>'´',   'µ'=>'µ',   '¶'=>'¶',   '·'=>'·',  ##-- 0xb0 .. 0xb7
   '¸'=>'',   '¹'=>'1',   'º'=>'o',   '»'=>'"',   '¼'=>'1/4', '½'=>'1/2', '¾'=>'3/4', '¿'=>'?',  ##-- 0xb8 .. 0xbf

   'À'=>'A',  'Á'=>'A',   'Â'=>'A',   'Ã'=>'A',   'Ä'=>'Ä',   'Å'=>'A',   'Æ'=>'AE',  'Ç'=>'C',  ##-- 0xc0 .. 0xc7
   'È'=>'E',  'É'=>'E',   'Ê'=>'E',   'Ë'=>'E',   'Ì'=>'I',   'Í'=>'I',   'Î'=>'EI',  'Ï'=>'I',  ##-- 0xc8 .. 0xcf
   'Ð'=>'D',  'Ñ'=>'N',   'Ò'=>'O',   'Ó'=>'O',   'Ô'=>'O',   'Õ'=>'O',   'Ö'=>'Ö',   '×'=>'x',  ##-- 0xd0 .. 0xd7
   'Ø'=>'Ö',  'Ù'=>'U',   'Ú'=>'U',   'Û'=>'AU',  'Ü'=>'Ü',   'Ý'=>'Y',   'Þ'=>'Th',  'ß'=>'ß',  ##-- 0xd8 .. 0xdf
   'à'=>'a',  'á'=>'a',   'â'=>'a',   'ã'=>'a',   'ä'=>'ä',   'å'=>'a',   'æ'=>'ae',  'ç'=>'c',  ##-- 0xe0 .. 0xe7
   'è'=>'e',  'é'=>'e',   'ê'=>'e',   'ë'=>'e',   'ì'=>'i',   'í'=>'i',   'î'=>'ei',  'ï'=>'i',  ##-- 0xe8 .. 0xef
   'ð'=>'d',  'ñ'=>'n',   'ò'=>'o',   'ó'=>'o',   'ô'=>'o',   'õ'=>'o',   'ö'=>'ö',   '÷'=>'÷',  ##-- 0xf0 .. 0xf7
   'ø'=>'ö',  'ù'=>'u',   'ú'=>'u',   'û'=>'au',  'ü'=>'ü',   'ý'=>'y',   'þ'=>'th',  'ÿ'=>'y',  ##-- 0xf8 .. 0xff
  );
foreach (@table) {
  $_ = $xlate{$_} if (exists($xlate{$_}));
}

##-- DEBUG / CSV
use Encode qw(encode decode);
use Unicode::CharName qw(uname ublock);
if ($MAKECSV) {
  foreach $ci (0..$#table) {
    next if ($table[$ci] eq chr($ci));
    print join("\t",
	       sprintf("U+%0.4X ~ \\x%0.2X ~ %3d", $ci, $ci, $ci),
	       ("latin1 ".encode('latin1',chr($ci)).' '.encode('latin1',$table[$ci])),
	       ("utf8 ".encode('utf8',chr($ci)).' '.encode('utf8',$table[$ci])),
	       (uname($ci)),
	      ), "\n";
  }
  exit 0;
}

##-- dump table
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = 1;
print Data::Dumper->Dump([\@table], ['*table']);
