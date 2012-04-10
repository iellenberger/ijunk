#!/usr/bin/perl -w

use IPC::Open3;
use Symbol;

use strict;
use warnings;

my ($in, $out, $err) = (undef, gensym, gensym);

# can use 'undef' instead of $in for 1st param
my $pid = open3 $in, $out, $err, "ls -d /usr; ls /doesnotexist";
waitpid $pid, 0; 
my $stat = $? >> 8;

local $/;

print "STDOUT:\n". <$out> ."\n";
print "STDERR:\n". <$err> ."\n";
print "PID   : $pid\n";
print "Status: $stat\n\n";

