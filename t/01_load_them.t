# vi:fdm=marker fdl=0 syntax=perl:
# $Id: 01_load_them.t,v 1.1 2006/01/26 15:35:38 jettero Exp $

use strict;
use Test;

plan tests => 1;

for my $p (qw(Term::GentooFunctions)) {
    eval "use $p";

    if( $@ ) {
        warn " $@\n";
        ok 0;

    } else {
        ok 1;
    }
}
