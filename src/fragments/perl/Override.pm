package Override;
use base qw( Exporter );

@EXPORT_OK = qw( system );

sub system {
	my $text = shift;
	print qq[You want me to run "$text?"\n];
}

1;
