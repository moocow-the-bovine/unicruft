#!/usr/bin/perl -w

use lib qw(./blib/lib ./blib/arch);
use Unicruft qw(:all);
use Encode qw(encode decode);

##--------------------------------------------------------------
## test: latin -> utf8

sub test_lu {
  our $sl = decode('latin1', 'fööbär');
  our $su = Unicruft::latin1_to_utf8($sl);
  #our $su = Unicruft::testme($sl);
  print "test_lu(): sl='$sl', su='$su'";
}
test_lu();


##--------------------------------------------------------------
## MAIN

sub main_dummy {
  foreach $i (0..3) {
    print "--dummy($i)--\n";
  }
}
main_dummy();

