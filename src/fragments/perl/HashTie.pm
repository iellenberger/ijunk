package HashTie;

use Data::Dumper; $Data::Dumper::Indent=0; $Data::Dumper::Sortkeys=1; # for debugging
sub tdump { my $t = Dumper(@_); $t =~ s/^\$VAR\d+\s=\s//msg; $t }

# === Class Variables ======================================================= 
# --- obscure string for hiding class' own settings ---
our $obscure = __PACKAGE__ . join("\b", split('', "#^&(){}-=_+[];:<>,./?!")) ."\b";

# === Constructor ===========================================================
sub new {
	my $class = shift; $class = ref($class) || $class;
	my $seedhash = ref $_[0] eq 'HASH' && @_ == 1 ? shift : { @_ };

	# --- create a hash-tied object ---
	tie my(%hash), $class, $seedhash; # tie hash with seed data
	my $self = bless \%hash, $class;  # bless ref to hash into class (for object)

	return $self;
}

# --- test to show what things look like internally ---
sub barf {
	my $self = shift;
	return
		'self          :       '.        tdump($self) ."\n".
		'self->public  :              '. tdump($self->public) ."\n".
		'self->private : '.              tdump($self->private) ."\n";
}

# === Accessors =============================================================
# --- private and public hashes ---
sub private { shift->{"private $obscure"} }
sub public  { shift->{"public $obscure"} }

# === Hash Tie Stuff ========================================================
sub TIEHASH  {
	my $class = shift; $class = ref($class) || $class;
	my $hashref = shift || {}; 

	# --- bless new hash and create base structure ---
	my $self = bless {}, $class;
	$self->{private} = { public => $self->{public} = $hashref };

	return $self;
}

sub FETCH {
	my ($self, $value) = @_;

	# --- if special keys are fetched, return special data ---
	return $self->{private} if $value eq "private $obscure";
	return $self->{public} if $value eq "public $obscure";

	# --- otherwise do the normal thing ---
	$self->{public}->{$value};
}

sub STORE    { $_[0]->{public}->{$_[1]} = $_[2] }
sub FIRSTKEY { my $a = scalar keys %{$_[0]->{public}}; each %{$_[0]->{public}} }
sub NEXTKEY  { each %{$_[0]->{public}} }
sub EXISTS   { exists $_[0]->{public}->{$_[1]} }
sub DELETE   { delete $_[0]->{public}->{$_[1]} }
sub CLEAR    { %{$_[0]->{public}} = () }
sub SCALAR   { scalar %{$_[0]->{public}} }

1;
