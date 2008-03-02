package Term::GentooFunctions;

require 5.008;

use strict;

use Exporter;
use Term::Size;
use Term::ANSIColor qw(:constants);
use Term::ANSIScreen qw(:cursor);

our $VERSION = "1.01.4";
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
    my ($columns, $rows) = Term::Size::chars *STDOUT{IO};

    print up(1), right($columns - 6), BOLD, BLUE, "[ ", 
        ($res ?  GREEN."ok" : RED."!!"), 
        BLUE, " ]", RESET, "\n";

    $res;
}

__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

    Term::GentooFunctions - provides gentoo's einfo, ewarn, eerror, ebegin and eend.

=head1 SYNOPSIS

    use Term::GentooFunctions qw(:all)

    einfo "this is kinda neat...";

    ebegin "I hope this works...";
     ....
    eend $truefalse; # the result is backwards of gentoo; ie, 0 is bad, 1 is good.

=head1 prints

einfo, ewarn, and error show informative lines

=head1 ebegin and eend

ebegin and eend show the beginning and ends of things.

Additionally, eend returns the result passed in for handy returns at the bottom of functions...

    sub eg {
        eend 0; # eg now returns a false!!  Huzzah!
    }

Lastly, eend will use $_ if it is not passed any arguments.

=head1 indents

you can also use eindent and eoutdent to show trees of things happening:

einfo "something"
eindent 
einfo "something else" # indented
eoutdent
einfo "something else (again)" # un-dented

=head1 bash

BTW, Term::GentooFunctions will use RC_INDENTATION and RC_DEFAULT_INDENT from /sbin/functions.sh...  So you can eindent in a
bash_script.sh and your perl_script.pl will use the indent level!  However, to get it to work you must 

    export RC_INDENTATION RC_DEFAULT_INDENT 
    
before you fork to perl.  Also, T::GF won't be able to modify the indent level in a way that will propagate back up to bash
(obviously).

=head1 AUTHOR

Paul Miller <paul@cpan.org>

I am using this software in my own projects...  If you find bugs, please
please please let me know. :) Actually, let me know if you find it handy at
all.  Half the fun of releasing this stuff is knowing that people use it.

=head1 COPYRIGHT

Copyright (c) 2007 Paul Miller -- LGPL [attached]

=head1 SEE ALSO

Term::Size, Term::ANSIColor, Term::ANSIScreen
