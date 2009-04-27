use strict;
no warnings;

use Test;
use Term::GentooFunctions qw(:all);

plan tests => (my $tests = 5);

$SIG{PIPE} = sub { skip_all("received sig pipe") };
open PIPE, "$^X test_scripts/test_edo_returns.pl|" or skip_all("popen failure: $!");
$/ = undef; my $slurp = <PIPE>;
my $exit = close PIPE;
if( not $exit and $! == 0 ) {
    skip_all("pclose failure ($?)") if ($?>>8) != 0x65;
}

$slurp =~ s/\e\[[\-\d;]*[ACm]//g;
$slurp =~ s/(?:\s*\[\s+ok\s+\]\s*)//sg;
$slurp =~ s/[\s\*]+\$VAR1\s+=\s+/: /sg;

#use Data::Dump qw(dump);
#die dump($slurp);
die $slurp;

#ok( $slurp =~ m/\* making/ );
#ok( $slurp =~ m/\*   rming/ );
#ok( $slurp =~ m/file or directory/ );
#ok( $slurp =~ m/x: 79/ );

sub skip_all {
    warn " $_[0], skipping tests\n";
    skip(1,1,1) for 1 .. $tests;
    exit 0;
}

__END__

result when test created:
* list2calar returns: \4;
* list2arr returns: [];
* arr2arr returns: [];
* list2hash returns: {};
* hash2hash returns: {};

