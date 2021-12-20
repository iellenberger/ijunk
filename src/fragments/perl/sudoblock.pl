#!/usr/bin/perl -w

use English;

use strict;
use warnings;

sudo("
	echo running as \$USER 
	sleep 1
");

# --- execute multiline bash as superuser ---
sub sudo {
	my $block = shift;
	my $tmpfile = "/tmp/sudoblock.$$.tmp";

	open TMPFILE, ">$tmpfile" || die;
	print TMPFILE $block;
	close TMPFILE;

	my @cmd = ("bash", $tmpfile);
	@cmd = "sudo", @cmd if $UID != 0;
	system $cmd;
	unlink $tmpfile;
}

