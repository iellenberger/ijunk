#!/usr/bin/perl -w

use Symbol;
use Data::Dumper;
use IO::Handle;

use strict;

my $fh = new IO::Handle;

print $fh->opened ? 0 : 1 ."\n";
$fh->fdopen("foo", "w");
print $fh->opened ? 0 : 1 ."\n";
$fh->close;
print $fh->opened ? 0 : 1 ."\n";

