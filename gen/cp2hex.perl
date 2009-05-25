#!/usr/bin/perl -w

use Encode qw(encode decode);

binmode(STDOUT);
foreach (@ARGV) {
  $_ =~ s/^U\+/0x/;
  $_ = hex($_) if ($_ =~ m/^0x|\\x/);
  $ustr = pack('U0U',$_);
  print
    sprintf("%d = U+%0.4X = '%s'~'%s' = %s\n", $_, $_, encode('utf8',$ustr), encode('latin1',$ustr),
	    join('', map {sprintf("\\x%0.2X",$_)} unpack('C0C*', $ustr)),
	   );
}
