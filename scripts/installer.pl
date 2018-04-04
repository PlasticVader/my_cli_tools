#!/usr/bin/env perl
# This is a bit of a mess, but it was not intended for readability in the first place
# Just list the options, read the input and let the thread worker download the script(s)
use strict;
use warnings;
use threads;
use sigtrap 'handler' => \&normsig_handler, qw{ untrapped normal-signals };
use HTTP::Tiny;
use FindBin qw{ $Bin $Script };
my $buff;
my $term        = 0;
my $usr1        = 0;
my $selfunlink  = (-d qq{$Bin/../.git}) ? 0 : 1;
my $base        = q{https://raw.githubusercontent.com/PlasticVader/my_cli_tools/master/scripts};
my $bin         = qq{$ENV{HOME}/bin};
my $bashrc      = qq{$ENV{HOME}/.bashrc};
my $export_path = q{export PATH="$HOME/bin:$PATH"};

sub normsig_handler {
    exit if not threads->list;
    $term++;
    print qq{Termination attempt no. $term\n};
    return 1;
}

$SIG{USR1} = sub {
    $_->join for threads->list;
    $usr1 = 1;
    if ($selfunlink) {
        print qq{Self-destructing\n};
        unlink qq{$Bin/$Script};
    }
    exit 0;
};

sub thrworker_download {
    my ($url, $path) = @_;
    HTTP::Tiny->new->mirror($url, $path);
    chmod oct q{0755}, $path if $path;
    print qq{[Thread] Download finished: [$path]\r\n};
    return 1;
}

sub thrworker_create {
    my ($sub, $params) = @_;
    threads->create(
        \&{$sub},
        $params->[0],
        $params->[1],
    );
    return 1;
}

sub clear {
    system q{/usr/bin/clear};
    return 1;
}

if (not -d $bin) {
    mkdir $bin, oct q{0755};
    print qq{Directory: [$bin] did not exist and was created\n};
}
my ($bin_in_path) = grep { /^$bin$/ } split /:/, $ENV{PATH};
if (not $bin_in_path and -f $bashrc) {
    print qq{Directory: [$bin] is not present in PATH\n};
    open my $fh, '>>', $bashrc or die $!;
    print $fh qq{$export_path\n};
    close $fh or die $!;
    print qq{Added: [$export_path] to [$bashrc]};
    system qq{source $bashrc};
    print qq{Sourced: [$bashrc]};
}

clear;
print qq{Getting the available scripts from [$base/available]\n};
my $res = HTTP::Tiny->new->get(qq{$base/available});
my @available = split / /, $res->{content};
if (@available) {
    print qq{Fetch successful, launching the options menu\n\n};
    undef $res;
}
else {
    die qq{Fetch failed!\n};
}

INST_BEGIN:
do {
    $buff  = qq{Please input on of the commands in parens (cmd)\n};
    $buff .= qq{Available downloads from [$base] are:\n};
    for my $i ('0' .. $#available) {
        chomp $available[$i];
        if (-f qq{$bin/$available[$i]}) {
            $buff .= qq{  ($i)    - [$available[$i]]  (Already exists, choosing this will overwrite the file)\n};
        }
        else {
            $buff .= qq{  ($i)    - [$available[$i]]  (Ready to be downloaded)\n};
        }
    }
    $buff .= q{  (.all)  - [} . (join q{ }, @available) . qq{"\n};
    $buff .= qq{  (.r)    - reload interface  \n};
    $buff .= qq{  (.q)    - exit program \n\n};
    print $buff and undef $buff;
    INST_INPUT:
    while (my $i = <>) {
        chomp $i;
        next INST_INPUT if $i =~ /^\s*$/;
        if ($i eq q{.q}){
            kill q{USR1}, $$
        }
        if ($i eq q{.all}) {
            for my $scr (@available) {
                thrworker_create(
                    q{thrworker_download},
                    [qq{$base/$scr}, qq{$bin/$scr}],
                );
            }
            next INST_INPUT;
        }
        if ($i eq q{.r}) {
            clear;
            goto INST_BEGIN;
        }
        if ($i !~ /^\d+$/) {
            print qq{Invalid input => [$i]\r\n}
                and next INST_INPUT;
        }
        if ($available[$i]) {
            thrworker_create(
                q{thrworker_download},
                [qq{$base/$available[$i]}, qq{$bin/$available[$i]}],
            );
            next INST_INPUT;
        }
        else {
            print qq{Option id => [$i] is unavailable\r\n}
                and next INST_INPUT;
        }
    }
} until ($usr1);


