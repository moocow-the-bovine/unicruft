#!/usr/bin/perl -w

use Getopt::Long (':config'=>'no_ignore_case');
use Encode qw(encode decode);

##======================================================================
## Globals

our ($help);

our $tabfile = '-';                  ##-- default table data file (perl code, expanded)
our $cfile   = '-';                  ##-- default output file
our $tabname = 'UNIDECODE_ASCII';    ##-- output: variable name for C 

GetOptions(
	   ##-- general
	   'help|h' => \$help,

	   ##-- misc
	   'tab-name|tabname|name|n=s' => \$tabname,
	   'output|o=s' => \$cfile,
	  );

if ($help) {
  print STDERR <<EOF;
Usage: $0 [OPTIONS] [TABFILE]
 Options:
   -help              # this help message
   -tab-name NAME     # output table name
   -output FILE       # output C file
EOF
  exit 0;
}

##-- command-line args
$tabfile = shift if (@ARGV);

##======================================================================
## Subs

sub c_table_str {
  my $s = shift;
  $s = '' if (!defined($s));

  ##-- Text::Unidecode catch-all: "[?]"
  #; (leave alone)
  $s =~ s/\s*\[\?\]\s*//sg;  ##-- ... map to empty
  #$s =~ s/\[\?\]/\#/sg;      ##-- ... map to '#'
  #$s =~ s/\[\?\]/\_/sg;      ##-- ... map to '_'

  ##-- Quotes
  $s = '"'
    if ($s eq ',,'                ##-- U+201E, U+301F: low double quotes
	|| $s eq "''"             ##-- U+2033: high double quotes
	|| $s eq '``'             ##-- U+2036: double backquotes
	#|| $s eq "\x{ab}"         ##-- U+00ab: <<: see latin1-de-maketable.perl
	#|| $s eq "\x{bb}"         ##-- U+00ab: >>: see latin1-de-maketable.perl
       );

  ##-- Text::Unidecode strangeness
  $s =~ s/\[JIS\]/(JIS)/sg; ##-- "[JIS]" = 12292 = 0x3004 = "Japanese Industrial Standard" symbol
  $s =~ s/\[d\d+\]/\_/sg;   ##-- e.g. "[d7]" = 10304 = 0x2840 = "Braille pattern dots-7"; all of these appear to be Braille

  $s =~ s/(["\\])/\\$1/sg;
  $s =~ s/\n/\\n/sg;
  $s =~ s/\t/\\t/sg;
  $s =~ s/\r/\\r/sg;
  #$s =~ s/\l/\\l/sg;
  #  $s =~ s/([^ [:alpha:][:digit:][:punct:]])/sprintf("\\x%x",ord($1))/sge;
  $s =~ s/([^[:print:]])/sprintf("\\x%x",ord($1))/sge;
  #return "0" if ($s eq '');  ##-- use NULL for empties
  return "\"$s\"";
}

##======================================================================
## MAIN

##-- load transliteration table data
our (@table);
if ($tabfile ne '-') {
  do $tabfile
    or die("$0: could not load transliteration table from '$tabfile': $!");
} else {
  local $/= undef;
  $tabstr = <STDIN>;
  eval $tabstr;
  die("$0: could not load transliteration table from STDIN: $@") if ($@);
}
foreach (@table) {
  utf8::upgrade($_) if (defined($_) && !utf8::is_utf8($_));
}

##-- dump table data as a pretty C constant array
open(OUT,">$cfile")
  or die("$0: open failed for output C file '$cfile': $!");

our $clen = 8;

print OUT
  (
   ##-- header: include
   "#include <uxUnidecode.h>\n",
   "\n",
   ##-- header: table decl
   "const uxLookupTable ${tabname} = {\n",
   "  ", scalar(@table), ",  /*-- number of entries --*/\n",
   "  {\n",
   "  ",
   ##
   ##-- table: data
   (map {
     $tabstr = c_table_str($table[$_]);
     (sprintf(" %-${clen}s", $tabstr),
      ($_ < $#table ? ',' : ' '),
      (($_+1) % 8 == 0
       ? sprintf("  /*-- U+%0.4X .. U+%0.4X --*/\n  ", ($_-7, $_))
       : qw()),
      )
   } (0..$#table)),
   ##
   ##-- table: footer
   "}\n",
   "};\n",
  );
