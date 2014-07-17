#!/usr/bin/env perl -w

use feature qw( switch );
use strict;
# --- example of disabling switch warnings in perl >= 5.18 ---
use warnings; no if $] >= 5.018, warnings => "experimental::smartmatch";
         
my $random = rand(2);
print "$random ";

given (int($random)) {
	when (0) { print "< 1\n" }
	default  { print "> 1\n" }
}
