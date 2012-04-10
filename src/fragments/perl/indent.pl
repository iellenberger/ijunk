#!/usr/bin/perl -w

use strict;
use warnings;

# --- sub call wrapper ---
sub show(@) {
	my ($sub, $depth) = (shift, shift);
	unless ($depth =~ /^[\d\W]+$/) {
		unshift @_, $depth;
		$depth = undef;
	}
	my $text = join "\n   - ", $sub, @_;

	eval "
		my \$tmp;
		print $sub(". ($depth ? "'$depth', " : '') ."\$tmp = '$text\n')
	";
	warn $@ if $@;
}

# --- tests ---
print "\nFixed Width:\n";
show qw( indentCFv compact fixed-width(3) varonly );
show qw( indentCF compact fixed-width(3));
show qw( indentEF expanded fixed-width(3) );

print "\nVariable Width:\n";
show qw( indentCVv 4 compact variable-width(4) varonly );
show qw( indentCV 4 compact variable-width(4));
show qw( indentEV 4 expanded variable-width(4) );

print "\nVariable Width or Arbitrary String:\n";
show qw( indentEA 8 expanded variable-width(8) );
show qw( indentEA ), "\t" ,qw( expanded tab );
show qw( indentCA ), " ------ " ,qw( compact string );
show qw( indentEA ), " ------ " ,qw( expanded string );

print "\n";

# === Indent Subroutines ====================================================

# --- compact, fixed width, varonly ---
sub indentCFv {$_[0]=~s/^/   /mg;shift}
# --- compact, variable width, varonly ---
sub indentCVv {my $i=' 'x shift;$_[0]=~s/^/$i/mg;shift}
# --- compact, fixed width ---
sub indentCF {my $s=shift;$s=~s/^/   /mg;$s}
# --- compact, variable width ---
sub indentCV {my($i,$s)=(' 'x shift,shift);$s=~s/^/$i/mg;$s}
# --- compact, variable width or arbitrary string ---
sub indentCA {my($i,$s)=@_;$i=~/^\d+$/and$i=' 'x$i;$s=~s/^/$i/mg;$s}

# --- expanded, fixed width ---
sub indentEF {
	my $text = shift;
	$text =~ s/^/   /mg;
	return $text;
}

# --- expanded, variable width ---
sub indentEV {
	my ($indent, $text) = (' ' x shift, shift);
	$text =~ s/^/$indent/mg;
	return $text;
}

# --- expanded, arbitrary string ---
sub indentEA {
	my ($indent, $text) = @_;
	$indent = ' ' x $indent if $indent =~ /^\d+$/;
	$text =~ s/^/$indent/mg;
	return $text;
}
