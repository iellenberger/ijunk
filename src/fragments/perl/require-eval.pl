#!/usr/bin/env perl

use strict;
use warnings;

# --- demo on how to use eval to test a require ---
foreach my $class (qw( POSIX POZIX )) {
	my $loaded = eval "require $class";

	if ($loaded) {
		print "loaded class '$class'\n";
	} else {
		print "failed to load class '$class'\n";
	}
}
