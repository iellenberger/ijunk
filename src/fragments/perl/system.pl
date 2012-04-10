#!/usr/bin/perl -w

use strict;
use warnings;

prun(@ARGV);

sub prun {
	print join(' ', @_) ."\n";
	run(@_);
}

sub run {
	my @cmd = @_;

	# --- run the command ---
	system(@cmd) == 0 && return 0;

	# --- error executing command ---
	print STDERR "\nerror executing '". join(' ', @cmd) ."'\n";
	if ($? == -1) {
		print STDERR "   failed to execute: $!\n";
	} elsif ($? & 127) {
		printf STDERR "   child died with signal %d, %s coredump\n",
			($? & 127),  ($? & 128) ? 'with' : 'without';
	} else {
		printf STDERR "   child exited with value %d\n", $? >> 8;
	}
	print "\n";

	exit 1;
}
