#!/usr/bin/perl -w

use Data::Dumper;
our $UNIDECODE_TABDIR = "Text-Unidecode-0.04/lib/Text/Unidecode";

use vars ('@Text::Unidecode::Char');


##======================================================================
## MAIN

##-- load unidecode tables into Text::Unidecode::Char
#print STDERR "$0: loading transliteration data from $UNIDECODE_TABDIR/x*.pm...\n";
foreach $bankfile (glob("$UNIDECODE_TABDIR/x*.pm")) {
  #print STDERR "$0: loading bank '$bankfile'\n";
  do $bankfile;
  die("$0: load failed for '$bankfile': $@") if ($@);
  #eval( "require Text::Unidecode::".basename($bank,'.pm').";" );
}

##-- expand bank table
#print STDERR "$0: expanding transliteration table...\n";
our @banks = @Text::Unidecode::Char;
our @table = qw();
foreach $banki (0..$#banks) {
  $offset = $banki*256;
  @table[$offset..($offset+255)] = @{$banks[$banki]}[0..255];
}

##-- dump table
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = 1;
print Data::Dumper->Dump([\@table],['*table']);
