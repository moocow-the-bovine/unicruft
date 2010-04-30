#!/usr/bin/perl -w

use Getopt::Long (':config'=>'no_ignore_case');
use Data::Dumper;
our $UNIDECODE_TABDIR = "Text-Unidecode-0.04/lib/Text/Unidecode";

use vars ('@Text::Unidecode::Char');

##======================================================================
## Globals

our ($help);
our @includes = qw();
GetOptions(
	   ##-- general
	   'help|h' => \$help,

	   ##-- misc
	   'include|I=s' => \@includes,
	  );

if ($help) {
  print STDERR <<EOF;
Usage: $0 [OPTIONS]
 Options:
   -help              # this help message
   -include PLFILE    # include PLFILE (override \@table contents; see also unidecode-table2c.perl -I flag)
EOF
  exit 0;
}


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

##-- load includes (overrides)
foreach $incfile (@includes) {
  do $incfile
    or die("$0: include failed for file '$incfile': $!");
}

##-- dump table
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = 1;
print Data::Dumper->Dump([\@table],['*table']);
