#!/bin/env raku

use Pod::To::PDF::Lite;
use PDF::Lite;
use PDF::Font::Loader;
use RakupodObject;

# Source Code Pro (Google font) # font used by Tony-o for cro article
my @fonts = (
    %(:file<SourceCodePro/static/SourceCodePro-Regular.ttf>),
    %(:file<SourceCodePro/static/SourceCodePro-Bold.ttf>, :bold),
    %(:file<SourceCodePro/static/SourceCodePro-Italic.ttf>, :italic),
    %(:file<SourceCodePro/static/SourceCodePro-BoldItalic.ttf>, :bold, :italic),
);

my enum Paper <Letter A4>;
my $debug   = 0;
my $left    = 1 * 72; # inches => PS points
my $right   = 1 * 72; # inches => PS points
my $top     = 1 * 72; # inches => PS points
my $bottom  = 1 * 72; # inches => PS points
my $margin  = 1 * 72; # inches => PS points
my Paper $paper = Letter;
my $page-numbers = False;

if not @*ARGS.elems {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <pod file> [...options...]

    Options
      paper=X    - Paper name: A4, Letter [default: Letter]
      margin=X   - default: 1"
      numbers    - Produces page numbers on each page
                   (bottom right of page: 'Page N of M')

    Converts Rakupod to PDF
    HERE
    exit
}

# defaults for US Letter paper
my $height = 11.0 * 72;
my $width  =  8.5 * 72;
# for A4
# $height =; # 11.7 in
# $width = ; #  8.3 in

my $pod-fil;
my $pdf-fil;
for @*ARGS {
    when $_.IO.f {
        $pod-fil = $_;
    }
    when /^ :i n[umbers]? / {
        $page-numbers = True;
    }
    when /^ :i p[aper]? '=' (\S+) / {
        $paper = ~$0;
        if $paper ~~ /^ :i a4 $/ {
            $height = 11.7 * 72;
            $width  =  8.3 * 72;
        }
        elsif $paper ~~ /^ :i L / {
            $height = 11.0 * 72;
            $width  =  8.5 * 72;
        }
        else {
            die "FATAL: Unknown paper type '$paper'";
        }
    }
    when /^ :i l[eft]? '=' (\S+) / {
        $left = +$0 * 72;
    }
    when /^ :i r[ight] '=' (\S+) / {
        $right = +$0 * 72;
    }
    when /^ :i t[op]? '=' (\S+) / {
        $right = +$0 * 72;
    }
    when /^ :i b[ottom]? '=' (\S+) / {
        $bottom = +$0 * 72;
    }
    when /^ :i m[argin]? '=' (\S+) / {
        $margin = +$0 * 72;
    }
    when /^ :i d / { ++$debug }
}

unless $pod-fil and $pod-fil.IO.r {
    note "FATAL: Unable to access a POD file.";
    exit
}
if $pod-fil ~~ /^:i (\S+) '.' rakudoc|pod $/ {
    # just use the basename
    $pdf-fil = ~$0.IO.basename ~ '.pdf';
}
else {
    note "FATAL: Pod file suffix not '.rakudoc' or '.pod'.";
    exit
}


# Extract the pod object from the pod
my $pod-obj = extract-rakupod-object $pod-fil.IO;
if $debug {
    say $pod-obj.raku;
    say "DEBUG exit"; exit;
}

# Then convert the pod object to pdf
my PDF::Lite $pdf = pod2pdf $pod-obj,
    :$height, :$width, :$margin, :$page-numbers; #, :@fonts;

# manipulate the PDF some more

$pdf.save-as: $pdf-fil;
say "See output pdf file: $pdf-fil";

