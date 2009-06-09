#!/usr/bin/perl -w
#-*- Mode: CPerl; coding: utf-8 -*-

use lib qw(./blib/lib ./blib/arch);
use Unicruft qw(:all);
#no warnings 'utf8';

our $linebuffer = 1;

if ($linebuffer) {
  while (<>) {
    print Unicruft::ux_utf8_to_latin1_de($_);
    #print Unicruft::utf8_to_latin1_de($_);
  }
}
else {
  local $/=undef;
  print Unicruft::ux_utf8_to_latin1_de(<>);
  #print Unicruft::utf8_to_latin1_de(<>);
}
