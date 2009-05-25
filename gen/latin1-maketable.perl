#!/usr/bin/perl -w

use Data::Dumper;
use utf8;

##======================================================================
## MAIN

##-- create latin-1 identity map
our @table = map {chr($_)} (0..255);

##-- dump table
$Data::Dumper::Indent = 1;
$Data::Dumper::Useqq = 1;
print Data::Dumper->Dump([\@table],['*table']);
