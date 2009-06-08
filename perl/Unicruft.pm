package Unicruft;

use 5.008004;
use strict;
use warnings;
use Carp;
use AutoLoader;
use Exporter;

our @ISA = qw(Exporter);

our $VERSION = '0.01';

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
