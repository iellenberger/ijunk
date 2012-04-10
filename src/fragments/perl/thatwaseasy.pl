#!/usr/bin/perl -w

open INFO, '-';
@input = <INFO>;
close INFO;
($string, $times) = @input;
print $string x $times;

