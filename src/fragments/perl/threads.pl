#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent=1; $Data::Dumper::Sortkeys=1; # for debugging only
use threads;

use strict;
use warnings;

my $thr = new threads(\&sysloop);
foreach my $ii (1..2) {
	print "main: $ii\n";
	sleep 1;
}
$thr->join;

sub sysloop {
	my $cmd = join "; sleep 1; ", map { "echo '   sysloop: $_'" } 1..4;
	#print "$cmd\n";
	system $cmd;
}

