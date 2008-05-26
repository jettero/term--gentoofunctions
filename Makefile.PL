# vi:set syntax=perl:

require 5.008;

use strict;
use ExtUtils::MakeMaker;

my $termsize = "Term::Size";
if( $^O =~ m/Win32/i ) {
    $termsize = "Term::Size::Win32";
}

WriteMakefile(
    'NAME'         => 'Term::GentooFunctions',
    'VERSION_FROM' => 'GentooFunctions.pm',
    'PREREQ_PM'    => { 
        $termsize          => 0,
        'Term::ANSIColor'  => 0,
        'Term::ANSIScreen' => 0,
        version => 0,
    },
);
