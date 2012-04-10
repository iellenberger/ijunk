#!/usr/bin/perl -w

# --- one-liner method ---
$> && exec "sudo $0 ". join(' ', @ARGV); # always run as superuser

use English;

use strict;
use warnings;

# --- multiline method ---
# Store arguments for possible sudo call 
# Add this line before and calls to GetOptions();
my @args = @ARGV;

# add conditions for sudo call here
if ($UID != 0) {
	my $cmd = "sudo $0 ". join(' ', @args);
	exec $cmd;
}

exec 'whoami';

# --- an example of being a particular user ---
# using infact(1058) for this example
$> != 1058 and exec "sudo -i -u infact $0 ". join(' ', @ARGV); # via uid
$ENV{USER} != 'infact' and exec "sudo -i -u infact $0 ". join(' ', @ARGV); # via username

