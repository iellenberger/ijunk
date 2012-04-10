package Capture;
use base Exporter;

use Symbol;

@EXPORT_OK = qw( capture );

use strict;
use warnings;

# --- redirect flags ---
sub out2out {}
sub err2err {}
sub err2out {}

# --- where to send out/err ---
sub outfile {
	my $self = shift;
	$self->{outfile} = shift if @_;
	return $self->{outfile};
}
sub errfile {
	my $self = shift;
	$self->{errfile} = shift if @_;
	return $self->{errfile};
}

# --- accessors for filehandles ---
sub outfh {
	my $self = shift;
	$self->{outfh} = shift if @_;
	return $self->{outfh};
}
sub errfh {
	my $self = shift;
	$self->{errfh} = shift if @_;
	return $self->{errfh};
}

# === Handle Tie for Capture ================================================
package Capture::Tie;

sub parent {
	my $self = shift;

	# --- accessor set ----
	$self->{parent} = shift if @_;

	# --- accessor get ---
	return $self->{parent};
}

# --- flush the buffer, return flushed contents ---
sub flush {
	my $self = shift;
	my $buffer = $self->buffer;
	$self->buffer('');
	return $buffer;
}
# --- append content to buffer ---
sub append {
	my $self = shift;
	my $buffer = $self->buffer;
	#! TODO: there has to be a more efficient way!
	while (my $arg = shift) { $buffer .= $arg if defined $arg; }
	return $self->buffer($buffer);
}

# === Handle Tie ============================================================
# --- tie and die ---
sub TIEHANDLE { bless {}, ref($_[0]) || $_[0] }
sub CLOSE {}
# === implemented like a pipe ===
# --- write ---
sub PRINT  { shift->append(@_) }
sub PRINTF { shift->append(sprintf shift, @_) }
sub WRITE  { $_[0]->append(defined $_[2] ? substr($_[1], 0, $_[2]) : $_[1]) }
# --- read ---
#! TODO: implement methods below properly
sub READ { $_[0]->flush } #! PARAMS: this, n/a, len, offset
sub READLINE { $_[0]->flush }
sub GETC { $_[0]->flush }

1;

__END__

# === Constructor ===========================================================
sub new {
	# --- tie a handle and call it self ---
	my ($this, $handle) = (shift, gensym);
	my $self = tie *{$handle}, ref($this) || $this;

	# --- store handle and return ---
	$self->handle($handle);
	return $self;
}

# === Accessors =============================================================
sub handle { defined $_[1] ? $_[0]->{_handle} = $_[1] : $_[0]->{_handle} }
sub buffer { defined $_[1] ? $_[0]->{_buffer} = $_[1] : $_[0]->{_buffer} }

# === Capturing =============================================================
# --- start and stop a capture ---
sub start {
	my $self = shift;
	$self->{_oldfh} = select($self->handle);
	return $self->handle;
}
sub stop {
	my $self = shift;
	if ($self->{_oldfh}) { select $self->{_oldfh} }
	else                 { select STDIN }
	return $self->flush();
}

# --- standalone capture method ---
sub capture(&) {
	my $code = shift;
	my $self = new Capture;
	$self->start;
	$code->();
	return $self->stop;
}

# === Buffer Management =====================================================
# --- flush the buffer, return flushed contents ---
sub flush {
	my $self = shift;
	my $buffer = $self->buffer;
	$self->buffer('');
	return $buffer;
}
# --- append content to buffer ---
sub append {
	my $self = shift;
	my $buffer = $self->buffer;
	#! TODO: there has to be a more efficient way!
	while (my $arg = shift) { $buffer .= $arg if defined $arg; }
	return $self->buffer($buffer);
}

# === Handle Tie ============================================================
# --- tie and die ---
sub TIEHANDLE { bless {}, ref($_[0]) || $_[0] }
sub CLOSE {}
# === implemented like a pipe ===
# --- write ---
sub PRINT  { shift->append(@_) }
sub PRINTF { shift->append(sprintf shift, @_) }
sub WRITE  { $_[0]->append(defined $_[2] ? substr($_[1], 0, $_[2]) : $_[1]) }
# --- read ---
#! TODO: implement methods below properly
sub READ { $_[0]->flush } #! PARAMS: this, n/a, len, offset
sub READLINE { $_[0]->flush }
sub GETC { $_[0]->flush }

1;
