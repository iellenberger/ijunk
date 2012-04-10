#!/usr/bin/perl -w

use lib '.';

use Override qw( system );

use strict;
use warnings;

system "echo Hello";
CORE::system "echo Hello";
