#!/usr/bin/perl -w
$VERSION=0.1;

use lib qw( . );

use Capture qw(capture);

use strict;

my $text = capture {
	print "stdout\n";
	print STDERR "stderr\n";
};

print "--- Text ---\n$text\n";
