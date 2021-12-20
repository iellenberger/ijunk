#!/usr/bin/perl -w

# --- one-liner method ---
$> && exec "sudo", $0, @ARGV; # always run as superuser

use English;

use strict;
use warnings;

# --- multiline method ---
# Store arguments for possible sudo call 
# Add this line before and calls to GetOptions();
my @args = @ARGV;

# add conditions for sudo call here
if ($UID != 0) {
	my @cmd = ("sudo", $0, @ARGV);
	exec @cmd;
}

exec 'whoami';

# --- an example of being a particular user ---
# using jimbob(1058) for this example
$> != 1058 and exec qw( sudo -i -u 1058 ), $0, @ARGV; # via uid
$ENV{USER} != 'jimbob' and exec qw( sudo -i -u jimbob ), $0, @ARGV; # via username
