#!/usr/bin/env raku

use Inline::Python;
use File::Find;

use lib "./lib";
#use PS2OTF;

my $py = Inline::Python.new();
if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <Type 1 font file name or basename> | show

    Converts a Type 1 font to an OpenType font.

    Entering 'show' will list the test font file basenames.  Any one 
    of those can be used to demonstrate the conversion process.

    HERE
    exit;
}

sub process-input($arg) is export {
}
sub show() is export {
    my $pdir = ".".IO.parent(1).dirname; #/fonts;
    my $fdir = "$pdir/fonts";
    my @f = find :dir($fdir), :type<file>;
    my %fonts;
    # collect and organize data
    for @f {
         my $file = $_.IO.basename;
         my $stem = $file;
         $stem ~~ s/'.' .* $//;
         unless %fonts{$stem}:exists {
             %fonts{$stem} = [];
         }
         %fonts{$stem}.push: $file;
    }
    my @fonts = %fonts.keys.sort;
    for @fonts {
        my $stem = $_;
        say "  Font: $_";
        say "    files:";
        my @files = @(%fonts{$_});
        for @files {
            say "      $_";
        }
    }
    exit;
}
for @*ARGS {
    if $_.IO.r {
        say "Processing file '$_'...";
        process-input $_;
    }
    when /^ :i s/ {
        say "Showing included font files...";
        show;
    }
    default {
        say "Unknown arg '_'. Exiting.";
        exit;
    }
}

my $psfil = @*ARGS.head;
if not $psfil.IO.r {
    say "ERROR: File '$psfil' cannot be opened.";
    exit;
}


=finish

#!/usr/bin/env fontforge
import fontforge

f=fontforge.open("../test.sfd")       
fontforge.logWarning( "font name: " + f.fullname )


#!/usr/bin/env fontforge

#
# Load the test.sfd and expand the 'A' by a magnification factor
#
import fontforge

f=fontforge.open("../test.sfd")       
g = f['A']
l = g.layers[g.activeLayer]
c = l[0]

fontforge.logWarning( "have glyph  : " + g.glyphname )
fontforge.logWarning( "glyph has  layer count: " + str(len(g.layers)))
fontforge.logWarning( "glyph has active layer: " + str(g.activeLayer) )
fontforge.logWarning( "layer has contour count: " + str(len(l)))
fontforge.logWarning( "contour.is_quad: " + str(c.is_quadratic))
fontforge.logWarning( "contour.len    : " + str(len(c)))

# double the size to make sure the user knows it!
mag = 2

for x in range(0, len(c)):
    p = c[x]
    fontforge.logWarning( "old x:" + str(p.x) + " y:" + str(p.y) )
    p.x = p.x * mag
    p.y = p.y * mag

for x in range(0, len(c)):
    p = c[x]
    fontforge.logWarning( "new x:" + str(p.x) + " y:" + str(p.y) )
 
g.layers[g.activeLayer] = l

fontforge.logWarning( "saving..." )
f.save("/tmp/out.sfd")

# let the user know we completed successfully
fontforge.logWarning( "script is done. output at /tmp/out.sfd" )
