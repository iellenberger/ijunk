#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent=0; $Data::Dumper::Sortkeys=1; # for debugging

use strict;
use warnings;

# === Test Script ===========================================================
# For hash and array ref ties of this sort, we can happily use the 'new'
#    method as a constructor.  We cannot for the same for a scalar because
#    it is not a reference, so we must tie directly to the declared variable.
tie my $stie, 'ScalarTie', 1;
barf("Scalar with seed value '1'");

$stie = 'two';
barf("Direct assignment 'two'");

$stie->value(3);
barf("Method assignment '3'");

print "\n";
print "External view (\$stie)\n   ". Dumper($stie) ."\n";
$stie->barf;
print "\n";

exit;

# --- convenience sub ---
sub barf {
	my $title = shift;
	print "\n$title
   \$stie          : $stie
   \$stie->{value} : $stie->{value}
   \$stie->value   : ". $stie->value ."\n";
}

# === Scalar Object Class ===================================================
package ScalarObj;

use Data::Dumper; $Data::Dumper::Indent=0; $Data::Dumper::Sortkeys=1; # for debugging

use overload 
	# --- work directly on tied scalar when obj used as scalar ---
	'""'     => sub { shift->{value} },
	'-'      => sub { shift->{value} -= shift },
	'+'      => sub { shift->{value} += shift },
	fallback => 1;

# --- Constructor -----------------------------------------------------------
sub new {
	my $class = shift; $class = ref($class) || $class;
	my $seedvalue = shift;

	# --- create and seed object ---
	my $self = bless {}, $class;
	$self->{value} = $seedvalue if $seedvalue;

	return $self;
}
sub scalarobj(\$;@) {
	my ($s, $v) = @_;
	tie ${$s}, 'ScalarTie', $v;
}

# --- test to show what things look like internally ---
sub barf { print "Internal view (\$self)\n   ". Dumper(shift) ."\n" }

# --- Accessor --------------------------------------------------------------
sub value {
	my $self = shift;
	$self->{'value'} = shift if @_;
	return $self->{'value'};
}

# === Scalar Tie Class ======================================================
package ScalarTie;

sub TIESCALAR {
	my ($class, $seed) = @_;

	# --- fully resolve class and seed value ---
	$class = ref($class) || $class;
	$seed = $seed->value
		if ref $seed && $seed->isa('ScalarObj');

	# --- create tie and blessed object --
	my $self = bless {}, $class;
	$self->{obj} = new ScalarObj($seed);

	return $self;
}
sub STORE {
	my ($self, $value) = @_;

	# --- fully resolve value ---
	$value = $value->value
		if ref $value && $value->isa('ScalarObj');

	# --- assign and return new value ---
	return $self->{obj}->{value} = $value;
}
sub FETCH { $_[0]->{obj} }

1;
