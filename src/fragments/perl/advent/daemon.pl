#!/usr/bin/perl -w 

use lib '/opt/qpass/emtools/lib';

use Cwd;
use Proc::Daemon;
use Proc::PID::File;  #! This is a shitty piece of code.  Rewrite it and put it Puma

use strict;

# --- get program name ---
my $progname = ($0 =~ /([^\/]*)$/)[0] || $0;
my $cwd = cwd;

# --- process stop command ---
if (@ARGV && $ARGV[0] eq "stop") {

	# --- test to see if daemon is running ---
	my $pid = Proc::PID::File->running(dir  => $cwd, name => $progname);
	die "Not already running!" unless $pid;

	# -- send a signal to kill process ---
	kill 2, $pid;  # 2 = SIGINT
	print "Stop signal sent!\n";
	exit;
}

# --- fork into the background ---
Proc::Daemon::Init;

# --- write the pid file, exiting if there's one there already ---
if (Proc::PID::File->running(dir => $cwd, name => $progname)) {
	die "Already running!"
}

# --- watch for INT signal ---
$SIG{INT} = sub { $::exit = 1 };

my $count = 0;
while ($count++ < 120) { # don't loop forever, this is only a test
	exit if $::exit;
	# print "FOO\n";
	sleep(5);
	exit if $::exit;
}

1;
