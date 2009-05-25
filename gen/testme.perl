#!/usr/bin/perl -w

use lib ('./lib');
use Encode qw(encode decode);
use File::Basename qw(basename);
use Text::Unidecode;

sub test1 {
  #my $x = unidecode('abc'); ##-- doesn't add anything to the table
  my $lu = pack("UUU", 228, 246, 252); ##-- &auml;&ouml;&uuml;
  my $la = unidecode($lu);

  print STDERR "$0: test1() finished\n";
}
#test1();

sub c_safe_str {
  my $s = shift;
  $s = '' if (!defined($s));
  $s =~ s/(["\\])/\\$1/sg;
  $s =~ s/\n/\\n/sg;
  $s =~ s/\t/\\t/sg;
  $s =~ s/\r/\\r/sg;
  #$s =~ s/\l/\\l/sg;
  $s =~ s/([^\w\d [:punct:]])/sprintf("\\x%x",ord($1))/sge;
  return $s;
}

sub test2 {
  my $tabpath = $INC{'Text/Unidecode.pm'};
  $tabpath =~ s/\.pm$//;
  my $nbanks = 0;
  foreach $bank (glob("$tabpath/x*.pm")) {
    eval( "require Text::Unidecode::".basename($bank,'.pm').";" );
    ++$nbanks;
  }
  print STDERR "test2(): loaded $nbanks from $tabpath/x*.pm\n";
  @Char = @Text::Unidecode::Char;

  ##-- dump: header
  open(OUT, ">testme.tab.c");
  print OUT
    (
     #"const char *UNIDECODE[] = {\n",
     "const char *UNIDECODE[", (@Char*256+1), "] = {\n",
    );

  ##-- dump: ASCII
  $nc = 0;
  @allc = qw();

  ##-- dump: blocks
  foreach $blki (0..$#Char) {
    print OUT
      ("\n  /*-- BLOCK $blki: ", sprintf("0x%0.4x..0x%0.4x", ($blki*256), ($blki*256+255)), " --*/",
       join(",",
	    map {
	      $allc[$nc] = $Char[$blki][$_],
	      ++$nc;
	      (($_ % 8 == 0 ? "\n " : '')
	       .' "'.(c_safe_str($Char[$blki][$_])).'"'
	      )
	    } (0..255)),
       ",\n");
  }

  ##-- dump: footer
  print OUT
    ("\n  0   /*-- end-of-table sentinel (NULL) --*/\n",
     "};\n");
  close(OUT);

  print STDERR "got $nc elts\n";
}
test2();
