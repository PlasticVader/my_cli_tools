#!/usr/bin/env perl
# This looks like a mess, but it was not intended for readability in the first place
use strict;
use warnings;
use threads;
use HTTP::Tiny;
use FindBin qw{ $Bin $Script };
my $buff;
my $usr1        = 0;
my $selfunlink  = ($ENV{USER} =~ /^plast/) ? 0 : 1;
my $base        = q{https://raw.githubusercontent.com/PlasticVader/my_cli_tools/master/scripts};
my $bin         = qq{$ENV{HOME}/bin};
my $bashrc      = qq{$ENV{HOME}/.bashrc};
my $export_path = q{export PATH="$HOME/bin:$PATH"};
@SIG{qw{INT TERM HUP}} = (q{IGNORE}, q{IGNORE}, q{IGNORE});
$SIG{USR1} = sub {
    $_->join for threads->list;
    $usr1 = 1;
    if ($selfunlink) {
        print qq{Self-destructing\n};
        unlink qq{$Bin/$Script};
    }
    exit;
};
sub download_script {
    my ($url, $path) = @_;
    HTTP::Tiny->new->mirror($url, $path);
    chmod oct q{0755}, $path if $path;
    print qq{Downloaded: [$path]\n};
    return 1;
}
sub killusr1 {
    kill q{USR1}, $$;
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
else {
    print qq{Directory: [$bin] is present in PATH\n};
}
print qq{Getting the available scripts from [$base/available]\n};
my $res = HTTP::Tiny->new->get(qq{$base/available});
my @available = split / /, $res->{content};
if (@available) {
    print qq{Fetch successful, launching the options menu\n};
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
    $buff .= qq{  (.r)    - reload program  \n};
    $buff .= qq{  (.q)    - exit program \n\n};
    print $buff and undef $buff;
    INST_INPUT:
    while (my $i = <>) {
        chomp $i;
        next INST_INPUT if $i =~ /^\s*$/;
        if ($i eq q{.q}){
            killusr1
        }
        if ($i eq q{.all}) {
            for my $scr (@available) {
                threads->create(
                    \&download_script,
                    qq{$base/$scr},
                    qq{$bin/$scr},
                );
            }
            next INST_INPUT;
        }
        if ($i eq q{.r}) {
            goto INST_BEGIN;
        }
        if ($i !~ /^\d+$/) {
            print qq{Invalid input => [$i]\n}
                and next INST_INPUT;
        }
        if ($available[$i]) {
            print qq{Downloading: [$available[$i]]\n};
            threads->create(
                \&download_script,
                qq{$base/$available[$i]},
                qq{$bin/$available[$i]},
            );
            next INST_INPUT;
        }
        else {
            print qq{Option id => [$i] is unavailable\n}
                and next INST_INPUT;
        }
    }
} until ($usr1);
