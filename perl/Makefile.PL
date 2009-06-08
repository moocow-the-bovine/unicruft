use ExtUtils::MakeMaker;

##----------------------------------------------------------------------
## Configuration
##----------------------------------------------------------------------
if (system("pkg-config --atleast-version=0.01 unicruft") != 0) {
  die("Required module unicruft >= v0.01 not found!\n");
}

$UX_IFLAGS = join(' ', map { $s=`pkg-config --cflags-only-I $_`; chomp($s); $s } qw(unicruft));
$UX_LDFLAGS= join(' ', map { $s=`pkg-config --libs-only-L $_`; chomp($s); $s } qw(unicruft));
$UX_LIBS   = join(' ', map { $s=`pkg-config --libs-only-l $_`; chomp($s); $s } qw(unicruft));

##----------------------------------------------------------------------
## MAIN
##----------------------------------------------------------------------
WriteMakefile
  (
   NAME		=> 'Unicruft',
   DISTNAME	=> 'unicruft-perl',
   AUTHOR       => 'Bryan Jurish <moocow@ling.uni-potsdam.de>',
   ABSTRACT	=> 'Perl interface to unicruft transliteration library',
   VERSION_FROM	=> 'Unicruft.pm',

   ##-- user variables
   #CC           => 'c++',   ##-- your c++ compiler
   LIBS         => "$UX_LDFLAGS $UX_LIBS",      ##-- additional libraries
   DEFINE       => '-DHAVE_CONFIG_H',     ##-- additional defines
   INC          => $UX_IFLAGS,      ##-- additional includes
   CCFLAGS      => '',          ##-- additional flags
   OPTIMIZE    => '-O1 -pipe', ##-- optimization flags
   #OBJECT      => 'Gfsm.o GfsmPerl.o',

   ##-- install these
   EXE_FILES => [glob("bin/*.perl")],

   ##-- DEBUG
   #MAKEAPERL=>1,
   #LINKTYPE=>'static',
   #MAP_TARGET=>'gfsmperl',
   #CCFLAGS=>'-g',
   ##-- /DEBUG

   ##-- stuff that probably doesn't need to be changed
   #XSOPT        => '-C++',
   #TYPEMAPS     => ['perlobject.map', 'typemap'],
  );


#-----------------------------------------------------------------------
# Extensions
#-----------------------------------------------------------------------
##...

sub MY::depend {
  package MY;
  my $inherited = shift->SUPER::depend(@_);
  $inherited .= (
		 "\n\n"
		 ##-- included xs dependencies
		 ."Unicruft.c: "
		 .(''
		   ." Unicruft.xs"
		  )
		 ."\n\n"
		 ##-- c->o dependencies
		 ## -- more here
		 ."\n"
		);
  $inherited;
}

