package Unicruft;

use 5.008004;
use strict;
use warnings;
use Carp;
use AutoLoader;
use Exporter;
use Encode qw(encode decode);

our @ISA = qw(Exporter);

our $VERSION = '0.02';

require XSLoader;
XSLoader::load('Unicruft', $VERSION);

# Preloaded methods go here.
#require Unicruft::Whatever;

# Autoload methods go after =cut, and are processed by the autosplit program.

##======================================================================
## Exports
##======================================================================
our %EXPORT_TAGS =
  (
   #all => ['latin1_to_utf8'],
   all => [],
  );
our @EXPORT_OK = @{$EXPORT_TAGS{all}};
our @EXPORT = qw();

##======================================================================
## Constants
##======================================================================

##======================================================================
## Wrappers
##======================================================================

## $u8str = latin1_to_utf8($l1str)
sub latin1_to_utf8 {
  ux_latin1_to_utf8(utf8::is_utf8($_[0]) ? encode('latin1',$_[0]) : $_[0]);
}

## $astr = utf8_to_ascii($u8str)
sub utf8_to_ascii {
  ux_utf8_to_ascii(utf8::is_utf8($_[0]) ? encode('utf8',$_[0]) : $_[0]);
}

## $l1str = utf8_to_latin1($u8str)
sub utf8_to_latin1 {
  ux_utf8_to_latin1(utf8::is_utf8($_[0]) ? encode('utf8',$_[0]) : $_[0]);
}

## $destr = utf8_to_latin1_de($u8str)
sub utf8_to_latin1_de {
  ux_utf8_to_latin1_de(utf8::is_utf8($_[0]) ? encode('utf8',$_[0]) : $_[0]);
}

##======================================================================
## Exports: finish
##======================================================================


1;

__END__

# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Unicruft - Perl interface to the unicruft transliteration library

=head1 SYNOPSIS

  use Unicruft;

  ##... stuff happens

=head1 DESCRIPTION

Not yet written.

=head1 SEE ALSO

Text::Unidecode(3pm),
unicruft(1),
perl(1).

=head1 AUTHOR

Bryan Jurish E<lt>jurish@bbaw.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Bryan Jurish

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.

=cut
