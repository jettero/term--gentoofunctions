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

our $VERSION = '1.3600';

our @EXPORT_OK = qw(einfo eerror ewarn ebegin eend eindent eoutdent einfon edie edo start_spinner step_spinner end_spinner);
our %EXPORT_TAGS = (all=>[@EXPORT_OK]);

use base qw(Exporter);

BEGIN {
    # use Data::Dumper;
    # die Dumper(\%ENV) unless defined $ENV{RC_INDENTATION};
    $ENV{RC_DEFAULT_INDENT} = 2  unless defined $ENV{RC_DEFAULT_INDENT};
    $ENV{RC_INDENTATION}    = "" unless defined $ENV{RC_INDENTATION};
}


sub edie(@) {
    my $msg = (@_>0 ? shift : $_);
    eerror($msg);
    eend(0);
    exit 0x65;
}

sub einfon($) {
    my $msg = wash(shift);

    local $| = 1;
    print " ", BOLD, GREEN, "*", RESET, $msg;
}

sub eindent()  {
    my $i = shift || $ENV{RC_DEFAULT_INDENT};

    $ENV{RC_INDENTATION} .= " " x $i;
}

sub eoutdent() {
    my $i = shift || $ENV{RC_DEFAULT_INDENT};

    $ENV{RC_INDENTATION} =~ s/ // for 1 .. $i;
}

sub wash($) {
    my $msg = shift;
       $msg =~ s/^\s+//s;

    chomp $msg;
    return "$ENV{RC_INDENTATION} $msg";
}

sub einfo($) {
    my $msg = wash(shift);

    print " ", BOLD, GREEN, "*", RESET, "$msg\n";
}

sub ebegin($) {
    goto &einfo;
}

sub eerror($) {
    my $msg = wash(shift);

    print " ", BOLD, RED, "*", RESET, "$msg\n";
}

sub ewarn($) {
    my $msg = wash(shift);

    print " ", BOLD, YELLOW, "*", RESET, "$msg\n";
}

sub eend(@) {
    my $res = (@_>0 ? shift : $_);

    my ($columns, $rows) = eval 'Term::Size::chars *STDOUT{IO}';
       ($columns, $rows) = eval 'Term::Size::Win32::chars *STDOUT{IO}' if $@;

    die "couldn't find a term size function to use" if $@;

    print up(1), right($columns - 6), BOLD, BLUE, "[ ", 
        ($res ?  GREEN."ok" : RED."!!"), 
        BLUE, " ]", RESET, "\n";

    $res;
}

my $do_depth = 0;
sub edo($&) {
    my ($begin_msg, $code) = @_;

    $do_depth ++;
    eindent if $do_depth>1;

    ebegin $begin_msg;
    my ($cr, @cr);

    my $wa = wantarray;
    my $r = eval { if( $wa ) { @cr = $code->() } else { $cr = $code->() } 1 };
    edie $@ unless $r;

    eoutdent if $do_depth>1;
    $do_depth --;
    eend 1;

    return @cr if $wa;
    return $cr;
}

{
    my $spinner_state;
    my $spinner_msg;
    sub start_spinner($) {
        my $msg = wash(shift);

        $spinner_state = "-";
        $spinner_msg = $msg;

        einfon $spinner_msg;
    }

    my $spinext = {"-"=>'\\', '\\'=>'|', "|"=>"/", "/"=>"-"};
    sub step_spinner(;$) {
        # NOTE: really I should use savepost and clline from ANSIScreen, but he doesn't have [0G at all.  Meh

        print "\e[0G\e[K";

        if( $_[0] ) {
            einfon("$spinner_msg $spinner_state ... $_[0]");

        } else {
            einfon("$spinner_msg $spinner_state ");
        }

        $spinner_state = $spinext->{$spinner_state};
    }

    sub end_spinner($) {
        print "\e[0G\e[K";
        einfo $spinner_msg;
        goto &eend;
    }
}

"this file is true";
