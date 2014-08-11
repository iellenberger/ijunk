#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent=0; $Data::Dumper::Sortkeys=$Data::Dumper::Terse=1; # for debugging only

use strict;
use warnings;

my $version = "v1.0.5-r6";

print "old: $version\n";
$version =~ s/(\d+)/sprintf("%03d",$1)/ge;
print "new: $version\n";
