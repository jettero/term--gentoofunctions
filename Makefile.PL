# vi:set syntax=perl:

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'Term::GentooFunctions',
    'VERSION_FROM' => 'GentooFunctions.pm',
    'PREREQ_PM'    => { 
        'Term::Size'       => 0,
        'Term::ANSIColor'  => 0,
        'Term::ANSIScreen' => 0,
    },
);
