unit module PS2OTF;

use Inline::Python;
use File::Find;

sub process-input($arg) is export {
}

sub show() is export {
    my $pdir = ".".IO.parent(1).dirname; #/fonts;
    my $fdir = "$pdir/fonts";
    my @f = find :dir($fdir), :type<file>;
    for @f {
        say "  $_";
    }

#    say $fdir;
    exit;
}


