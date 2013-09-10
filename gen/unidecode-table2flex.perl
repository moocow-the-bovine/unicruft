#!/usr/bin/perl -w

use Getopt::Long (':config'=>'no_ignore_case');
use Encode qw(encode decode);
use Unicode::CharName qw(uname ublock);

##======================================================================
## Globals

our ($help);

our $tabfile  = 'unidecode-table.PL'; ##-- default table data file (perl code, expanded)
our $template = '-';                  ##-- template file
our $replace  = '__RULES__';          ##-- replace this string with generated rules
our $outfile  = '-';                  ##-- default output file
our $outfunc  = 'MAPTOS';             ##-- output function or macro, MAPTOS(target,len)
our $outfunc1 = 'MAPTOC';             ##-- output function or macro for length=1: MAPTOC(target,char)
our $outfunc0 = 'MAPTO0';             ##-- output function or macro for length=0: MAPTO0(target)

our $ignore_id    = 1;  ##-- no rules for identity translations?
our $ignore_empty = 0;  ##-- no rules for empty targets?

GetOptions(
	   ##-- general
	   'help|h' => \$help,

	   ##-- misc
	   'table-file|table|tabfile|tf|t=s' => \$tabfile,
	   'replace|r=s' => \$replace,
	   'ignore-identity|ignore-id|ii!' => \$ignore_id,
	   'ignore-empty|ie!'    => \$ignore_empty,
	   'outfunc|func|of|f=s' => \$outfunc,
	   'outfunc1|func1|of1|f1=s' => \$outfunc1,
	   'outfunc0|func0|of0|f0=s' => \$outfunc0,
	   'output|o=s' => \$outfile,
	  );

if ($help) {
  print STDERR <<EOF;
Usage: $0 [OPTIONS] [TEMPLATE_FILE]
 Options:
   -help              # this help message
   -tabfile NAME      # input table file (unidecode-table.PL)
   -replace STRING    # replace STRING with generated rules
   -ignore-id         # no rules for identity translations
   -ignore-empty      # no rules for empty-target translations
   -outfunc FUNC      # str-output function name (MAPTOS; called as FUNC(\$target_str,\$len))
   -outfunc1 FUNC1    # char-output function name (MAPTOC; called as FUNC(\$target_chr))
   -outfunc0 FUNC0    # null-output function name (MAPTO0; called as FUNC())
   -output FILE       # output C file
EOF
  exit 0;
}

##======================================================================
## Subs

sub safe_xlate_target {
  my $s = shift;
  $s = '' if (!defined($s));

  ##-- Text::Unidecode catch-all: "[?]"
  $s =~ s/\s*\[\?\]\s*//sg;  ##-- ... truncate
  #$s =~ s/\[\?\]/\#/sg;      ##-- ... map to '#'
  #$s =~ s/\[\?\]/\_/sg;       ##-- ... map to '_'
  #... keep ...

  ##-- Text::Unidecode strangeness
  $s =~ s/\[JIS\]/(JIS)/sg; ##-- "[JIS]" = 12292 = 0x3004 = "Japanese Industrial Standard" symbol
  $s =~ s/\[d\d+\]/\_/sg;   ##-- e.g. "[d7]" = 10304 = 0x2840 = "Braille pattern dots-7"; all of these appear to be Braille

  return $s
}

sub c_hex_str {
  my $s = shift;
  return join('', map {sprintf("\\x%X",$_)} unpack('C0C*',$s));
}

sub c_safe_str {
  my $s = shift;
  $s =~ s/([\"\'\\])/\\$1/sg; ##-- backslash, quotes
  $s =~ s/\x{00}/\\0/sg;  ##-- \x00: NUL
  $s =~ s/\x{07}/\\a/sg;  ##-- \x07: BEL (bell)
  $s =~ s/\x{08}/\\b/sg;  ##-- \x08: BS (backspace)
  $s =~ s/\t/\\t/sg;      ##-- \x09: HT (horizontal tab)
  $s =~ s/\n/\\n/sg;      ##-- \x0a: LF (newline)
  $s =~ s/\x{0C}/\\f/sg;  ##-- \x0C: FF (form feed)
  $s =~ s/\r/\\r/sg;      ##-- \x0D: CR (carriage return)
  $s =~ s/([^[:print:]])/sprintf("\\x%x",ord($1))/sge;
  return $s;
}

sub c_cmt_str {
  my $s = shift;
  $s =~ s/\\/\\\\/sg;     ##-- backslash
  $s =~ s/\x{00}/\\0/sg;  ##-- \x00: NUL
  $s =~ s/\x{07}/\\a/sg;  ##-- \x07: BEL (bell)
  $s =~ s/\x{08}/\\b/sg;  ##-- \x08: BS (backspace)
  $s =~ s/\t/\\t/sg;      ##-- \x09: HT (horizontal tab)
  $s =~ s/\n/\\n/sg;      ##-- \x0a: LF (newline)
  $s =~ s/\x{0C}/\\f/sg;  ##-- \x0C: FF (form feed)
  $s =~ s/\r/\\r/sg;      ##-- \x0D: CR (carriage return)
  return $s;
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
  $_ = '' if (!defined($_));
  utf8::upgrade($_);
}

##-- convert table to rules
our $block = '';
our $rules = '';

##-- rule formatting
our $c_hex_len   =  8;
our $out_str_len = 10;
our $out_n_len   =  2;
our $cmt_c_len   =  2;
our $func_len    = length($outfunc) > length($outfunc1) ? length($outfunc) : length($outfunc1);
our $name_len    = 42;

foreach $ci (0..$#table) {
  no warnings;

  ##-- get character
  $cu  = pack('U',$ci);
  $cub = encode('utf8',$cu);

  ##-- get target
  $cx = safe_xlate_target($table[$ci]);
  utf8::upgrade($cx) if (!utf8::is_utf8($cx));
  $cxb = encode('utf8',$cx);

  ##-- check whether we're ignoring this translation
  next if ($ignore_empty && $cxb eq '');
  next if ($ignore_id    && $cxb eq $cub);

  ##-- get unicode data
  $c_codepoint = sprintf("U+%0.4X", $ci);
  $c_name      = uname($ci) || '?';
  $c_block     = ublock($ci) || $block;

  ##-- maybe print new-block header
  if ($c_block ne $block) {
    $rules .= ("\n"
	       ." /*".('-' x 61)."\n"
	       ."  * BLOCK: $c_block\n"

	       ."  */\n"
	      );
    $block = $c_block;
  }

  ##-- Print rule
  $rules .= (sprintf("%-${c_hex_len}s { ", c_hex_str($cub))
	     .(length($cxb)==0
	       ? sprintf("%-${func_len}s(%-${out_str_len}s%s);",
			 $outfunc0, '', (' ' x ($out_n_len+1)))
	       : (length($cxb)==1
		  ? sprintf("%-${func_len}s(%-${out_str_len}s%s);",
			    $outfunc1, ("'".c_safe_str($cxb)."'"), (' ' x ($out_n_len+1)))
		  : sprintf("%-${func_len}s(%-${out_str_len}s,%${out_n_len}d);",
			    $outfunc, ('"'.c_safe_str($cxb).'"'), length($cxb))
		 ))
	     .sprintf(" } /*-- %s (%${cmt_c_len}s -> %-${cmt_c_len}s): %-${name_len}s --*/\n",
		      $c_codepoint, c_cmt_str($cub), c_cmt_str($cxb),
		      $c_name)
	    );
}

##-- load template & replace
{
  local $/=undef;
  $template_str = <>;
  $template_str =~ s/$replace/$rules/g;
}

##-- dump template
open(OUT,">$outfile")
  or die("$0: open failed for output file '$outfile': $!");

print OUT $template_str;
