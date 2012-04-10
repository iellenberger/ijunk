#!/usr/bin/perl -w

use lib '.';

use InheritBase;
use InheritSub;

use strict;
use warnings;

InheritBase->printName();
InheritBase->printMe();
InheritSub->printName();
InheritSub->printMe();

printMe();
