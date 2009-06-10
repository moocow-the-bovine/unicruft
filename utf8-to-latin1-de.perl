#!./ucperl -w
#-*- Mode: CPerl; coding: utf-8 -*-

use lib qw(./blib/lib ./blib/arch);
use Unicruft qw(:all);
#use Encode qw(encode decode);
#no warnings 'utf8';

our $linebuffer = 1;
our $warn_on_approx = 1;
our $want_output = 1;

our $nbytes_in  = 0;
our $nbytes_out = 0;

if ($linebuffer) {
  while (defined($in=<>)) {
    $out = Unicruft::ux_utf8_to_latin1_de($in);
    $nbytes_in  += length($in);
    $nbytes_out += length($out);
    if ($warn_on_approx) {
      #$in = decode('UTF-8',$in);
      $in = pack('U0C*', map { $_ < 256 ? $_ : ord('?') } unpack('U0U*',$in));
      if ($in =~ /^[\x{00}-\x{ff}]*$/ && $in ne $out) {
	($in1,$out1) = ($in,$out);
	$in1  =~ s/\n$/\\n/s;
	$out1 =~ s/\n$/\\n/s;
	$in1  = substr($in1,0,32)."..." if (length($in1) > 32);
	$out1 = substr($out1,0,32)."..." if (length($out1) > 32);
	warn("goof: '$in1' -> '$out1' (input byte $nbytes_in, output byte $nbytes_out)");
      }
    }
    print $out if ($want_output);
  }
}
else {
  local $/=undef;
  $out = Unicruft::utf8_to_latin1_de(<>);
  print $out if ($want_output);
}
