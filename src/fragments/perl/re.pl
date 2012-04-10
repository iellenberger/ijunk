#!/usr/bin/perl -w

use strict;

my $foo = 'hello';
(my $bar = $foo) =~ s/l/L/g;
print qq[$foo $bar\n];

my %regexes = (
	'one' => '1',
	'two' => '2',
	'(four)ty(six)' => '($3)ty($2)',
);
my $search = join '|', keys %regexes;

my $string = ' one and two and three and fourtysix ';

print "before:\t$string\n\t$search\n";
# $string =~ s/($search)/$1 $regexes{$1}/msg;
$string =~ s/($search)/&replace($1)/msg;
print "after : $string\n";

sub replace {
	return $regexes{shift};
}
