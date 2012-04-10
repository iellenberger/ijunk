#!/usr/bin/perl -w

use strict;

my @array = qw( a b aardvark a b z z n m o o p );

print "original     : ". join(' ', @array) ."\n";
print "uniq1        : ". join(' ', uniq1(@array)) ."\n";
print "uniq1 + sort : ". join(' ', sort(uniq1(@array))) ."\n";
print "uniq2        : ". join(' ', uniq2(@array)) ."\n";
print "uniq2 + sort : ". join(' ', sort(uniq2(@array))) ."\n";

# --- don't givacrap about order ---
sub uniq1 { keys %{{ map { $_, 1 } @_ }} }
# --- keep order ---
sub uniq2 { my %h; grep { !$h{$_}++ } @_ }
