#!/usr/bin/perl -w

use POSIX 'isatty';

use strict;

print '-t STDIN : '. (-t STDIN  ? 'yes' : 'no') ."\n";
print '-t STDOUT: '. (-t STDOUT ? 'yes' : 'no') ."\n";
# print '-t       : '. (-t        ? 'yes' : 'no') ."\n";
print 'isatty   : '. (isatty()  ? 'yes' : 'no') ."\n";
