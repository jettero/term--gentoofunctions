
die "you're not running this right, use make test" unless -d "blib/lib";
BEGIN { unshift @INC, "blib/lib" }

use strict;
use warnings;
use Term::GentooFunctions qw(:all);

edo "making file" => sub {
    open OUT, ">file" or die $!; close OUT;

    edo "rming file" => sub { unlink "file" or die $! };
};

edo "rming file again (fail)" => sub { unlink "file" or die $! };
