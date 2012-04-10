#!/usr/bin/perl -w

use Data::Dumper;

use strict;

if (@ARGV) {
	my $message = shift @ARGV;

	print "\nenvchild $message\n". Dumper(\%ENV);

} else {
	$ENV{'envchild'} = 'Ingmar is a dweeb';

	system "$0 'Using System' | grep envchild";
	exec "$0 'Using Exec' | grep envchild";
}

