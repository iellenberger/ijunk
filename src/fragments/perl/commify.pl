#!/usr/bin/perl -w

print commify(1234567890) ."\n";

sub commify {
	(my $num = shift) =~ s/\G(\d{1,3})(?=(?:\d\d\d)+(?:\.|$))/$1,/g;
	return $num;
}

