#!/usr/bin/perl -w

use Encode qw(encode decode);
use Benchmark qw(cmpthese timethese);


sub lu_pack   { pack('U0U*', unpack('C0C*', $_[0])); }
sub lu_encode { Encode::decode('latin1',$_[0]); }

sub ul_pack   { pack('C0C*', unpack('U0U*', $_[0])); }
sub ul_encode { Encode::encode('latin1',$_[0]); }

sub uu_pack   { utf8::is_utf8($_[0]) ? pack('C0C*', unpack('U0C*', $_[0])) : $_[0]; }
sub uu_encode { utf8::is_utf8($_[0]) ? Encode::encode('utf8',$_[0]) : $_[0]; }

@us = map {decode('UTF-8',$_)} map {chomp;$_} `cat test-strings.t`;
@ls = map {encode('latin1',$_)} @us;

use vars qw(@lup @lue @ulp @ule);
print "data loaded.\n";
cmpthese(-1, { 'lu_pack'=>sub { @lup=map {lu_pack($_)} @ls; }, 'lu_encode'=>sub { @lue=map {lu_encode($_)} @ls; }, });
cmpthese(-1, { 'ul_pack'=>sub { @ulp=map {ul_pack($_)} @us; }, 'ul_encode'=>sub { @ule=map {ul_encode($_)} @us; }, });
cmpthese(-1, { 'uu_pack'=>sub { @uup=map {uu_pack($_)} @us; }, 'uu_encode'=>sub { @uue=map {uu_encode($_)} @us; }, });

