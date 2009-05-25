#!/usr/bin/perl -w
# -*- Mode: CPerl; coding: utf-8 -*-

use Encode qw(encode decode);
use utf8;

print
  encode('utf8',
	 join("\n",
	      "Auml: \x{c4}",
	      "Auml/l1: A\x{a8}",
	      "Auml/u8: A\x{308}",
	      "",
	      "auml: \x{e4}",
	      "auml/l1: a\x{a8}",
	      "auml/u8: a\x{308}",
	      "",
	      "acirc: \x{e2}",
	      "acirc/l1: a^",
	      "acirc/u8: a\x{302}",
	      "ucirc: \x{fb}",
	      "ucirc/l1: u^",
	      "ucirc/u8: u\x{302}",
	      "",
	      "a+^e: a\x{364}",
	      "a+^x: a\x{36f}",
	     )
	 ."\n"
	);
