#!/usr/bin/perl -w

print commify(1234567890.123) ."\n";
print commify(1234567890.123, 2) ."\n";
print commify(1234567890.123, 4) ."\n";

sub commify {
	my ($num, $places) = (shift, shift || 0);

	# --- grab each side of the fraction ---
	my $int = int $num;
	my $fraction = (($num =~ /\.(\d+)$/)[0] || 0) . (0 x $places);

	# --- format the int crop the fraction ---
	$int =~ s/(\d{1,3})(?=(?:\d\d\d)+(?:\.|$))/$1,/g;
	$fraction = substr $fraction, 0, $places;

	# --- return formatted number, no fraction if places = 0 ---
	return $places ? "$int.$fraction" : $int;
}
