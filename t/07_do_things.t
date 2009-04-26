use strict;
no warnings;

use Test;
use Term::GentooFunctions qw(:all);

plan tests => 2;

edo supz => sub { ok(1) } or die "woah: $@";
edo supz => sub { die "hiya\n" }  or ok($EDO_ERR, "hiya\n");
