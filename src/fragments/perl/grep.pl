#!/usr/bin/env perl

use Data::Dumper; $Data::Dumper::Indent=1; $Data::Dumper::Sortkeys=1; # for debugging only

use strict;
use warnings;

# --- predeclare a few things ---
my (@in, @out);

# --- input array ---
@in = ( undef, 'foo', undef, 'bar', undef );
print Dumper(\@in);

# --- remove undef values ---
@out = grep { $_ if defined $_ } @in;
print Dumper(\@out);

# --- replace undef values ---
@out = grep { if (defined $_) { $_ } else { $_ = 'UNDEF' } } @in;
print Dumper(\@out);

# --- return more then unde value per element ---
@out = map { ($_, $_ .'-2') } @in;
print Dumper(\@out);


