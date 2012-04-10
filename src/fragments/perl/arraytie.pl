#!/usr/bin/perl -w

use Data::Dumper; $Data::Dumper::Indent=0; $Data::Dumper::Sortkeys=1; # for debugging

use strict;
use warnings;

# === Test Script ===========================================================
my $obj = new ArrayTie(1, 2, 3);
#my $obj = new ArrayTie([1, 2, 3]); # alternate constructor params

print "\nDumping Object:\n";
print "   ". Data::Dumper->Dump([\@$obj], ['@$obj']) ."\n";
print "   ". Data::Dumper->Dump([$obj],   ['$obj  ']) ."\n";

print "\nAccessing elements:\n";
foreach my $ii (0 .. 2) { print "   \$obj->[$ii] = $obj->[$ii]\n"; }
print "setting \$obj->[2] to 'two'\n";
$obj->[1] = 'two';
foreach my $ii (0 .. 2) { print "   \$obj->[$ii] = $obj->[$ii]\n"; }

print "\nDumping Self:\n";
$obj->barf;
print "\n";

exit;

# ===========================================================================
package ArrayTie;

use Data::Dumper; $Data::Dumper::Indent=0; $Data::Dumper::Sortkeys=1; # for debugging

use overload
	# --- work directly on tied array when obj used as arrayref ---
	'@{}' => sub { shift->{array} },
	fallback => 1;

use strict;
use warnings;

# === Constructor ===========================================================
sub new {
	my $class = shift; $class = ref($class) || $class;
	my $seedarray = ref $_[0] eq 'ARRAY' && @_ == 1 ? shift : [ @_ ];

	# --- return an object with an internal tied array ---
	return bless tie(my(@array), $class, $seedarray), $class;

	# --- functional equivalent of the above line ---
	#my $self = tie my(@array), $class, $seedarray;
	#bless $self, $class;
	#return $self;
}

# --- test to show what things look like internally ---
sub barf {
	my $self = shift;
	print "   ". Data::Dumper->Dump([\@$self], ['@$self']) ."\n";
	print "   ". Data::Dumper->Dump([$self],   ['$self  ']) ."\n";
}

# === Array Tie Stuff =======================================================
sub TIEARRAY  {
	my $class = shift; $class = ref($class) || $class;
	my $arrayref = shift || [];

	my $self = bless { array  => $arrayref }, $class;

	return $self;
}

sub FETCH { shift->{array}->[shift] }
sub STORE { $_[0]->{array}->[$_[1]] = $_[2] }

sub FETCHSIZE { scalar @{shift->{array}} }
sub STORESIZE { $#{shift->{array}} = shift() - 1 }

sub PUSH    { push    @{shift->{array}}, @_ }
sub POP     { pop     @{shift->{array}}     }
sub UNSHIFT { unshift @{shift->{array}}, @_ }
sub SHIFT   { shift   @{shift->{array}}     }
