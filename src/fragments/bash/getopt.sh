#!/bin/bash

# --- useful resources ---
# http://wiki.bash-hackers.org/howto/getopts_tutorial

# --- if there are no arguments, run some examples ---
if [ -z $1 ]; then
	echo; echo "valid flag:";
	$0 -a
	echo; echo "invalid flag:";
	$0 -z
	echo; echo "valid parameter:";
	$0 -b value
	echo; echo "mixed and bundled:"
	$0 -aa -bvalue1 -ab value2 -abvalue3

	echo; exit
fi

# --- get the script name ---
SCRIPTNAME=`basename $0`

# --- show usage ---
usage() {
	echo "  $*"
	echo "  usage $SCRIPTNAME -a[aa] -b VALUE"
	exit 1
}

echo "  $SCRIPTNAME $*"

# --- parse options ---
INVALID="0";
while getopts ":ab:" OPT; do
	case $OPT in
		a)
			echo "    -a was triggered" >&2
			;;
		b)
			echo "    -b was triggered, Parameter: $OPTARG" >&2
			;;
		\?)
			echo "    invalid option: -$OPTARG" >&2
			INVALID=1
			;;
	esac
done

# --- ending message ---
if [ "$INVALID" -eq 1 ]; then
	usage error: invalid argument
else
	echo "  done"
fi
