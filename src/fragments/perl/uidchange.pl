#!/usr/bin/perl -w

#! Note: this doesn't work as I'd like :(

# --- use English names for vars ---
# $UID = $<   $EUID = $>
# $GID = $(   $EGID = $)
use English;

use strict;
use warnings;

print "starting:\n";
print "   e u/g = $EUID/$EGID\n";
print "     u/g = $UID/$GID\n";

$> = 10166;
$) = 20;

print "change effective:\n";
print "   e u/g = $EUID/$EGID\n";
print "     u/g = $UID/$GID\n";
system "touch $0.effective\n";

$< = 10166;
$( = 20;

print "change actual:\n";
print "   e u/g = $EUID/$EGID\n";
print "     u/g = $UID/$GID\n";
system "touch $0.actual\n";

system "ls -l $0*";
system "rm $0.effective $0.actual";


