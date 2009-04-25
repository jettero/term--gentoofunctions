package Term::GentooFunctions;

require 5.006001;

use strict;

BEGIN {
    eval "use Term::Size;";               my $old = $@;
    eval "use Term::Size::Win32" if $old; my $new = $@;
    die $old if $old and $new;
    die $new if $new;
}

use Exporter;
use Term::ANSIColor qw(:constants);
use Term::ANSIScreen qw(:cursor);

our $VERSION = 1.3001;

our @EXPORT_OK = qw(einfo eerror ewarn ebegin eend eindent eoutdent einfon edie);
our %EXPORT_TAGS = (all=>[@EXPORT_OK]);

use base qw(Exporter);

BEGIN {
    # use Data::Dumper;
    # die Dumper(\%ENV) unless defined $ENV{RC_INDENTATION};
    $ENV{RC_DEFAULT_INDENT} = 2  unless defined $ENV{RC_DEFAULT_INDENT};
    $ENV{RC_INDENTATION}    = "" unless defined $ENV{RC_INDENTATION};
}


1;

sub edie {
    &eerror($_) for @_;
    &eend(0);
    exit 1;
}

sub einfon {
    my $msg = &wash(shift);

    local $| = 1;
    print " ", BOLD, GREEN, "*", RESET, $msg;
}

sub eindent  {
    my $i = shift || $ENV{RC_DEFAULT_INDENT};

    $ENV{RC_INDENTATION} .= " " x $i;
}

sub eoutdent {
    my $i = shift || $ENV{RC_DEFAULT_INDENT};

    $ENV{RC_INDENTATION} =~ s/ // for 1 .. $i;
}

sub wash {
    my $msg = shift;
       $msg =~ s/[\r\n]//sg;
       $msg =~ s/^\s+//s;
     # $msg =~ s/\s+$//s;  # NOTE: do not wash this off.  When we call einfon() we expect to keep trailing spaces.!!

    return "$ENV{RC_INDENTATION} $msg";
}

sub einfo {
    my $msg = &wash(shift);

    print " ", BOLD, GREEN, "*", RESET, "$msg\n";
}

sub eerror {
    my $msg = &wash(shift);

    print " ", BOLD, RED, "*", RESET, "$msg\n";
}

sub ewarn {
    my $msg = &wash(shift);

    print " ", BOLD, YELLOW, "*", RESET, "$msg\n";
}

sub ebegin {
    &einfo(@_);
}

sub eend {
    my $res = (@_>0 ? shift : $_);
    my ($columns, $rows) = eval 'Term::Size::chars *STDOUT{IO}';
       ($columns, $rows) = eval 'Term::Size::Win32::chars *STDOUT{IO}' if $@;

    die "couldn't find a term size function to use" if $@;

    print up(1), right($columns - 6), BOLD, BLUE, "[ ", 
        ($res ?  GREEN."ok" : RED."!!"), 
        BLUE, " ]", RESET, "\n";

    $res;
}
