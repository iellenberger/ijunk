#!/usr/bin/perl -w

use FindBin qw( $Bin $Script );

use strict;
use warnings;

my $filename = "$Bin/$Script.eval";
my $foo = 0;

if (-e $filename) {
		open INFILE, $filename;
			my $content = ''; { local $/; $content = <INFILE>; }
				close INFILE;

					eval $content;
}
print "eval start value = $foo\n";

$foo++;

open OUTFILE, ">$filename";
print OUTFILE "\$foo = $foo\n";
close OUTFILE;

print "eval end value   = $foo\n";
