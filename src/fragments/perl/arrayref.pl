#!/usr/bin/perl -w

use strict;

sub foo { [qw(this is an array)] }

print join('-', @{foo()}) ."\n";

