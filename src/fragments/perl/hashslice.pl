#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent=1; $Data::Dumper::Sortkeys=1; # for debugging

use strict;
use warnings;

my %hash = (
	one   => 1,
	two   => 2,
	three => 3,
	four  => 4,
);
my $hashref = \%hash;
print Dumper($hashref);

my @keys = qw(two four);

# --- gotta predeclare or it won't work ---
my (%slice, $sliceref);

print "\nHash -> Slice\n";
@slice{@keys} = @hash{@keys};
print Dumper(\%slice);

print "\nHashref -> Slice\n";
@slice{@keys} = @{$hashref}{@keys};
print Dumper(\%slice);

print "\nHashref -> Sliceref\n";
@{$sliceref}{@keys} = @{$hashref}{@keys};
print Dumper($sliceref);

