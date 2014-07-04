
sub _trim {
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

