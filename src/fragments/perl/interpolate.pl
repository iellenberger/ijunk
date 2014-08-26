#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent=$Data::Dumper::Sortkeys=$Data::Dumper::Terse=1; # for debugging only

use feature qw( switch );

use strict;
use warnings;

# --- text for interpolation ---
my $text = '
	This is a ${key1} of the ${hash1.key2} ${hash1.hash2.key3} system
	This is not how to count: ${array:0} ${array:1} ${array:2} ${array:3} ${array:4}
';
# --- datastruct of values ---
my $hash = {
	key1 => 'test',
	hash1 => {
		key2 => 'variable',
		hash2 => {
			key3 => 'interpolation',
		},
	},
	array => [ qw( one tow 3 for fyve ) ],
		
};

# --- show results ---
print "Original Hash: ". Dumper($hash) ."\n";
my $flat = flatten($hash);
print "Flattened Hash: ". Dumper($flat) ."\n";
print "Original Text:\n". $text ."\n";
print "Interpolated Text:\n". interpolate($text, $flat) ."\n";

# --- interpolate hash into text ---
sub interpolate {
	my ($text, $hash) = @_;
	while (my ($key, $value) = each %$hash) {
		$key =~ s/\./\\./g;  # escape '.' in keys to make sure we donly match actual dots
		$text =~ s/\${$key}/$value/;
	}
	return $text;
}

# --- flatten a datastructure ---
sub flatten {
	my ($ds, $prefix) = @_;
	my $flat = {};

	given (ref $ds) {
		when ('HASH') {
			foreach my $key (keys %$ds) {
				my $subhash = flatten($ds->{$key}, defined $prefix ? "$prefix.$key" : $key);
				map { $flat->{$_} = $subhash->{$_} } keys %$subhash;
		}	}
		when ('ARRAY') {
			for (my $key = 0; $key < @$ds; $key++) {
				my $subhash = flatten($ds->[$key], defined $prefix ? "$prefix:$key" : $key);
				map { $flat->{$_} = $subhash->{$_} } keys %$subhash;
		}	}
		default { $flat = { $prefix => $ds } }
	}

	return $flat;
}
