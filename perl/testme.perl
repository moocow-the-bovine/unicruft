#!/usr/bin/perl -w
#-*- Mode: CPerl; coding: utf-8 -*-

use lib qw(./blib/lib ./blib/arch);
use Unicruft;
use Encode qw(encode decode);
no bytes;
use utf8;

no warnings 'utf8';

BEGIN {
  #binmode(\*STDOUT,':utf8');
}

##--------------------------------------------------------------
## utils: dump string

## $dump = dumpstr($str)
sub dumpstr {
  my $str = shift;
  return
    ("'$str': u8=".(utf8::is_utf8($str) ? 1 : 0)
     ."; len=" . length($str) . "; blen=" . bytes::length($str)
    );
}

##--------------------------------------------------------------
## test: info

sub test_info {
  print "Unicruft v$Unicruft::VERSION, lib version=", Unicruft::library_version, "\n";
}
test_info();

##--------------------------------------------------------------
## test: latin -> utf8

sub test_lu {
  print "----\ntest_lu\n";

  our $sl = "\x{e4}\x{f6}\x{fc}"; ##-- "äöü" == "&auml;&ouml;&uuml;"
  utf8::upgrade($sl);
  our $su = Unicruft::latin1_to_utf8($sl);
  print "test_lu/utf8", "\n sl=", dumpstr($sl), "\n su=", dumpstr($su), "\n";

  our $slb = encode('latin1',$sl);
  our $sub = Unicruft::latin1_to_utf8($slb);
  print "test_lu/bytes", "\n slb=", dumpstr($slb), "\n sub=", dumpstr($sub), "\n";
}
#test_lu();

##--------------------------------------------------------------
## test: utf8 -> ascii

sub test_ua {
  print "----\ntest_ua:\n";
  our $su = "Auml=(ÄA¨Ä); ucirc=(ûu^û); a^e=(aͤ); oelig=(œ); pi_eps=(πε)";
  print " su/in=", dumpstr($su), "\n";
  our $sa = Unicruft::utf8_to_ascii($su);
  print "test_ua/utf8:", "\n su=", dumpstr($su), "\n sa=", dumpstr($sa), "\n";

  our $sub = encode('utf8',$su);
  our $sab = Unicruft::utf8_to_ascii($sub);
  print "test_ua/bytes:", "\n sub=", dumpstr($sub), "\n sab=", dumpstr($sab), "\n";
}
#test_ua();

##--------------------------------------------------------------
## test: utf8 -> latin1

sub test_ul {
  print "----\ntest_ul:\n";
  our $su = "Auml=(ÄA¨Ä); ucirc=(ûu^û); a^e=(aͤ); oelig=(œ); pi_eps=(πε)";
  print " su/in=", dumpstr($su), "\n";
  our $sa = Unicruft::utf8_to_latin1($su);
  print "test_ul/utf8:", "\n su=", dumpstr($su), "\n sa=", dumpstr($sa), "\n";

  our $sub = encode('utf8',$su);
  our $sab = Unicruft::utf8_to_latin1($sub);
  print "test_ul/bytes:", "\n sub=", dumpstr($sub), "\n sab=", dumpstr($sab), "\n";
}
#test_ul();

##--------------------------------------------------------------
## test: utf8 -> latin1/de

sub test_ud {
  print "----\ntest_ud:\n";
  our $su = shift;
  $su = "Auml=(ÄA¨Ä); ucirc=(ûu^û); a^e=(aͤ); oelig=(œ); pi_eps=(πε)" if (!defined($su));
  print " su/in=", dumpstr($su), "\n";
  our $sa = Unicruft::utf8_to_latin1_de($su);
  print "test_ud/utf8:", "\n su=", dumpstr($su), "\n sa=", dumpstr($sa), "\n";

  our $sub = encode('utf8',$su);
  our $sab = Unicruft::utf8_to_latin1_de($sub);
  print "test_ud/bytes:", "\n sub=", dumpstr($sub), "\n sab=", dumpstr($sab), "\n";
}
#test_ud();
test_ud('<?xml version="1.0" encoding="UTF-8"?>'."\n");

##--------------------------------------------------------------
## MAIN

sub main_dummy {
  foreach $i (1..3) {
    print "--dummy($i)--\n";
  }
}
main_dummy();

