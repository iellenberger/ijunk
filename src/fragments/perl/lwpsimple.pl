#!/usr/bin/perl -w

use LWP::Simple;

use strict;
use warnings;

my $content = get("http://localhost/");

print $content;
