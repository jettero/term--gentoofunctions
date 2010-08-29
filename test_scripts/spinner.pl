
use strict;
use warnings;
use Term::GentooFunctions qw(start_spinner step_spinner end_spinner);
use Time::HiRes qw(sleep);

start_spinner "testing spinner";
for( 1 .. 20 ) {
    step_spinner;
    sleep 0.1;
}
end_spinner 1;

start_spinner "testing spinner";
for( 1 .. 20 ) {
    step_spinner "$_/20";
    sleep 0.1;
}
end_spinner 1;

