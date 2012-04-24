#!/usr/bin/perl -w

# === Import Bash Vars from a Child Script ==================================
# This example shows how to import shell variables from a child shell script
#
# We are using three variables for this exmaple:
#    FOO - to test exporting from Perl to Bash
#    BAR - to test importing from Bash to Perl
#    BAZ - to test detecting changes to existing variables

use Data::Dumper; $Data::Dumper::Indent=1; $Data::Dumper::Sortkeys=1; # for debugging only
use Storable qw( retrieve );

use strict;
use warnings;

# --- temporary file name ---
my $tmpfile = "import.tmp";

# --- set a few vars ---
$ENV{FOO} = "foo";
$ENV{BAZ} = "huh?";

# --- show Perl values before setting vars ---
print "pl pre  : FOO is ". (defined $ENV{FOO} ? "'$ENV{FOO}'" : "undef") ."\n";
print "pl pre  : BAR is ". (defined $ENV{BAR} ? "'$ENV{BAR}'" : "undef") ."\n";
print "pl pre  : BAZ is ". (defined $ENV{BAZ} ? "'$ENV{BAZ}'" : "undef") ."\n";
print "\n";

# --- run the script ---
system qq[
	# --- show Bash values before setting vars ---
	echo "sh pre  : FOO is '\$FOO'"
	echo "sh pre  : BAR is '\$BAR'"
	echo "sh pre  : BAZ is '\$BAZ'"
	echo

	# --- auto-export ALL newly set or changed variables ---
	# NOTE: If you only want capture exported vars, don't do this
	set -a

	# --- do something ---
	# NOTE: 'source' any scripts to capture their vars
	BAR="bar"   # set a new var
	BAZ="baz"   # change an existing one

	# --- show Bash values after setting vars ---
	echo "sh post : FOO is '\$FOO'"
	echo "sh post : BAR is '\$BAR'"
	echo "sh post : BAZ is '\$BAZ'"
	echo

	# --- store off the new environment hash ---
	perl -e 'use Storable; store \\\%ENV, "$tmpfile"'
];

# --- retrieve the new env hash and delete the tempfile ---
my $newenv = retrieve $tmpfile;
unlink $tmpfile;

# --- one-liner to copy everything ------------------------------------------
# Not really sure this is advisable
#%ENV = map { $_ => $newenv->{$_} } keys %$newenv;

# --- example that only copies new keys or changed values -------------------
# --- there are some keys we want to ignore ---
my $ignore = join '|', qw( _ PWD SHLVL USER );

# --- walk through list to find new and changed vars ---
while (my ($key, $value) = each %$newenv) {

	# --- ignore specified keys ---
	next if $key =~ /^(?:$ignore)$/;

	# --- new key ---
	if (!exists $ENV{$key}) {
		print "new key added : $key = $value\n";
		$ENV{$key} = $value;
		next;
	}

	# --- changed value ---
	if (!defined $ENV{$key} || $ENV{$key} ne $value) {
		print "value changed : $key = $value\n";
		$ENV{$key} = $value;
		next;
	}
}
print "\n";

# --- same as above, but more compact ---
#foreach my $key (keys %$newenv) {
#	next if $key =~ /^(?:$ignore)$/;
#	$ENV{$key} = $newenv->{$key}
#		if !exists $ENV{$key} || !defined $ENV{$key} || $ENV{$key} ne $newenv->{$key};
#}

# --- show Perl values after setting vars ---
print "pl post : FOO is ". (defined $ENV{FOO} ? "'$ENV{FOO}'" : "undef") ."\n";
print "pl post : BAR is ". (defined $ENV{BAR} ? "'$ENV{BAR}'" : "undef") ."\n";
print "pl post : BAZ is ". (defined $ENV{BAZ} ? "'$ENV{BAZ}'" : "undef") ."\n";
