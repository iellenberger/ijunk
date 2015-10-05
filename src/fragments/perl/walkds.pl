#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent=$Data::Dumper::Sortkeys=$Data::Dumper::Terse=1;

#use List::Util qw( max );
#use Storable qw( dclone );

use strict;
use warnings;

my $ds = {
	change => 'not',
	keep   => 'me',
	array  => [
		[
			change => 'not',
			keep   => 'me',

		],
		{
			change => 'not',
			keep   => 'me',
		},
	],
	hash => {
		array => [
			change => 'not',
			keep   => 'me',
		],
		hash => {
			change => 'not',
			keep   => 'me',
		},
	},
};

sub changeme {
	my $subds = shift;

	if (ref $subds eq 'HASH') {
		while (my ($key, $value) = each %$subds) {
			$subds->{$key} = changeme($value);
		}
	} elsif (ref $subds eq 'ARRAY') {
		for (my $ii = 0; $ii < @$subds; $ii++) {
			$subds->[$ii] = changeme($subds->[$ii]);
		}
	} else {
		$subds = 'you' if $subds eq 'not';
	}

	return $subds;
}

print Dumper($ds);
changeme($ds);
print Dumper($ds);
