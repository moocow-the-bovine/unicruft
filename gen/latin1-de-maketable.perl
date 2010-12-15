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
   '�'=>' ',  '�'=>'!',   '�'=>'�',   '�'=>'�',   '�'=>'�',   '�'=>'�',   '�'=>'�',   '�'=>'�',  ##-- 0xa0 .. 0xa7
   '�'=>'�',  '�'=>'�',   '�'=>'a',   '�'=>'"',   '�'=>'�',   '�'=>'�',   '�'=>'�',   '�'=>'�',  ##-- 0xa8 .. 0xaf
   '�'=>'�',  '�'=>'+/-', '�'=>'2',   '�'=>'3',   '�'=>'�',   '�'=>'�',   '�'=>'�',   '�'=>'�',  ##-- 0xb0 .. 0xb7
   '�'=>'',   '�'=>'1',   '�'=>'o',   '�'=>'"',   '�'=>'1/4', '�'=>'1/2', '�'=>'3/4', '�'=>'?',  ##-- 0xb8 .. 0xbf

   '�'=>'A',  '�'=>'A',   '�'=>'A',   '�'=>'A',   '�'=>'�',   '�'=>'A',   '�'=>'AE',  '�'=>'C',  ##-- 0xc0 .. 0xc7
   '�'=>'E',  '�'=>'E',   '�'=>'E',   '�'=>'E',   '�'=>'I',   '�'=>'I',   '�'=>'EI',  '�'=>'I',  ##-- 0xc8 .. 0xcf
   '�'=>'D',  '�'=>'N',   '�'=>'O',   '�'=>'O',   '�'=>'O',   '�'=>'O',   '�'=>'�',   '�'=>'x',  ##-- 0xd0 .. 0xd7
   '�'=>'�',  '�'=>'U',   '�'=>'U',   '�'=>'AU',  '�'=>'�',   '�'=>'Y',   '�'=>'Th',  '�'=>'�',  ##-- 0xd8 .. 0xdf
   '�'=>'a',  '�'=>'a',   '�'=>'a',   '�'=>'a',   '�'=>'�',   '�'=>'a',   '�'=>'ae',  '�'=>'c',  ##-- 0xe0 .. 0xe7
   '�'=>'e',  '�'=>'e',   '�'=>'e',   '�'=>'e',   '�'=>'i',   '�'=>'i',   '�'=>'ei',  '�'=>'i',  ##-- 0xe8 .. 0xef
   '�'=>'d',  '�'=>'n',   '�'=>'o',   '�'=>'o',   '�'=>'o',   '�'=>'o',   '�'=>'�',   '�'=>'�',  ##-- 0xf0 .. 0xf7
   '�'=>'�',  '�'=>'u',   '�'=>'u',   '�'=>'au',  '�'=>'�',   '�'=>'y',   '�'=>'th',  '�'=>'y',  ##-- 0xf8 .. 0xff
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
