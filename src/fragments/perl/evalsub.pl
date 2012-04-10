#!/usr/bin/env perl


use strict;

sub evalTest { print "unevaluated\n"; }
evalTest();

eval {
	evalTest();
	eval { sub evalTest { print "evaluated block\n" } };
	evalTest();

	# eval q[ sub evalTest { print "evaluated string\n" } ];
	evalTest();
};

evalTest();

