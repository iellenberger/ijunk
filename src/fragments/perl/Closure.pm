package Closure;
use base 'Exporter';

@EXPORT = qw( &closure $closure );

our $closure = 'hello';

sub closure(&) {
	my $code = shift;
	$code->();
}

1;
