#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent=1; $Data::Dumper::Sortkeys=1; # for debugging only
use List::Util qw( max );
use Storable qw( dclone );

use strict;
use warnings;

# This snippet was originally inspired by the Data::Merger module
#    though I stripped it down big-time to a minimalistic implementation
# For simplicity's sake, I did a few things:
#    * clone both DSs to ensure originals are not modified
#    * the second DS overrides values in the first
#
# Data::Merger - Copyright 2007 Hugo Cornelis, distributed under the Artistic License

# === Main Body of Code =====================================================

printMerge(1, 2);
printMerge(undef, 2);
printMerge(1, undef);
printMerge(
	{ one => 1 },
	{ two => 1 },
);
printMerge(
	[ 1, 2, { three => 3 }, 4, 'five', { six => '6.0', six1 => '6.1' } ],
	[ { one => 1 }, 2, 3, 'four', 5, { six => '6.zero', six2 => '6.2' }, 7 ],
);

# --- wrapper sub that prints ins and outs ---
sub printMerge {
	my ($ds1, $ds2) = @_;
	print "Merging data structures:\n".
		Data::Dumper->Dump([$ds1, $ds2], ['ds1', 'ds2']);

	# --- this line is the secret-sauce ---
	my $dsmerged = merge($ds1, $ds2);

	print Data::Dumper->Dump([$dsmerged], ['dsmerged']) ."\n";
	return $dsmerged;
}

# === Main Entry Point ======================================================
sub merge {
	my ($ds1, $ds2) = _refClone(@_);
	# --- a one-liner for the rest of this sub for those so inclined ---
	# return defined $ds1 ? (defined $ds2 ? _merge($ds1, $ds2) : $ds1) : (defined $ds2 ? $ds2 : undef);

	# --- if either DS is undef, return the other ---
	if (!defined $ds1) {
		return $ds2 if defined $ds2;
		return undef;  # if we got here, both DSs are undef
	} elsif (!defined $ds2) {
		return $ds1;
	}

	# --- run the main merge routine ---
	return _merge($ds1, $ds2);
}

# === Private Subs ==========================================================
# --- merge any type ---
sub _merge {
	my ($ds1, $ds2) = @_;

	# --- if the DSs are of different type, just return the second ---
	return $ds2 if ref $ds1 ne ref $ds2;

	# --- call separate subs for hashes and arrays ---
	return _mergeHash($ds1, $ds2)  if UNIVERSAL::isa($ds1, 'HASH');
	return _mergeArray($ds1, $ds2) if UNIVERSAL::isa($ds1, 'ARRAY');

#	# --- shortened alternative for the above 2 lines w/o using separate subs ---
#	if (UNIVERSAL::isa($ds1,'HASH')) {
#		map { $ds1->{$_} = _merge($ds1->{$_}, $ds2->{$_}) } keys %$ds2;
#		return $ds1;
#	}
#	if (UNIVERSAL::isa($ds1, 'ARRAY')) {
#		map { $ds1->[$_] = _merge($ds1->[$_], $ds2->[$_]) } 0 .. max(scalar @$ds1, scalar @$ds2) - 1;
#		return $ds1;
#	}

	# --- if we got here, it's a scalar ---
	return $ds2;
}

# --- merge two hashes ---
sub _mergeHash {
	my ($ds1, $ds2) = @_;

	foreach my $key (keys %$ds2) {
		$ds1->{$key} = _merge($ds1->{$key}, $ds2->{$key});
	}

	return $ds1;
}

# --- merge two arrays ---
sub _mergeArray {
	my ($ds1, $ds2) = @_;

	my $maxindex = max scalar @$ds1, scalar @$ds2;
	for (my $index = 0; $index < $maxindex; $index++) {
		$ds1->[$index] = _merge($ds1->[$index], $ds2->[$index]);
	}

	return $ds1;
}

# --- dclone multiple DSs w/o undef ref errors ---
sub _refClone { map { ref $_ ? dclone($_) : $_ } @_ }
