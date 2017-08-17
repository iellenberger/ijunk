#!/bin/bash

# Evaluating a boolean variable

# --- test function ---
testbool() {
	echo "MYBOOL $*:"

	# --- test if it's set ---
	if [ ! -z ${MYBOOL+x} ]; then
		echo '   ! -z ${MYBOOL+x}  : true'
	else
		echo '   ! -z ${MYBOOL+x}  : false'
	fi

	# --- test if it evaluates ---
	if [ $MYBOOL ] ; then
		echo '   $MYBOOL           : true'
	else
		echo '   $MYBOOL           : false'
	fi

	# --- test if it evaluates to true without quotes ---
	if [ $MYBOOL = true ] ; then
		echo '   $MYBOOL = true    : true'
	else
		echo '   $MYBOOL = true    : false'
	fi

	# --- test if it evaluates to true with quotes ---
	# NOTE: this seems the most likely solution you're looking for
	if [ "$MYBOOL" = true ] ; then
		echo '   "$MYBOOL" = true  : true'
	else
		echo '   "$MYBOOL" = true  : false'
	fi

	echo
}

# --- test various states of MYBOOL ---
unset MYBOOL
testbool "unset" 

MYBOOL=""
testbool "blank"

MYBOOL=0
testbool $MYBOOL

MYBOOL=1
testbool $MYBOOL

MYBOOL="false"
testbool "'$MYBOOL'"

MYBOOL="true"
testbool "'$MYBOOL'"

MYBOOL="two words"
testbool "'$MYBOOL'"

