#!/bin/bash

# slog - simple logging library for Bash
#
# Copyright (c) 2001-2016 by Ingmar Ellenberger. Distributed under The Artistic License.
# For the text the license, see https://github.com/iellenberger/itools/blob/master/LICENSE
# or read the LICENSE in the root of the iTools distribution.

# --- globals ---
slogSCRIPTDIR=$(cd $(dirname $0); pwd)
slogSCRIPTNAME=$(basename $0)
slogLEVEL=${slogLEVEL:-0}
slogFILE=${slogFILE:-/dev/stdout}

# --- accessors ---
sloglevel () { slogLEVEL=${1:-0}; } # maximum log level
slogfile () { slogFILE=${1:-0}; }   # log file

# --- main logging function ---
# usage: slog LEVEL [MESSAGE]
slog () {
	# --- get log level, do nothing if out of range ---
	local LEVEL=$1; shift
	(( LEVEL > slogLEVEL )) && return 1

	# --- get message from params or STDIN (pipe) ---
	[[ $# -ne 0 ]] && MESSAGE="$@" || MESSAGE="$(cat)"

	# --- get timestamp and log message ---
	local STAMP=$(date +'%Y-%m-%d %H:%M:%S')
	echo "$STAMP [$slogSCRIPTNAME ${FUNCNAME[1]}:${BASH_LINENO[0]}] $MESSAGE" >> "$slogFILE"
}

# --- dump a stacktrace ---
# usage: slogstack [LEVEL [MESSAGE]]
slogstack () {
	# --- get log level, do nothing if out of range ---
	local LEVEL=${slogLEVEL:-$1}; shift
	(( LEVEL > slogLEVEL )) && return 1

	# --- log message before stacktrace ---
	local MESSAGE=${@:-<stacktrace requested>}
	local STAMP=$(date +'%Y-%m-%d %H:%M:%S')
	echo "$STAMP [$slogSCRIPTNAME ${FUNCNAME[1]}:${BASH_LINENO[0]}] $MESSAGE" >> "$slogFILE"

	# --- generate stacktrace ---
	for (( ii=1; ii <= ${#BASH_LINENO[@]}-2; ii++ )); do
		# --- build and echo message ---
		MESSAGE="${FUNCNAME[ii + 1]}[${BASH_LINENO[ii]}] $(sed -n "${BASH_LINENO[ii]}{s/^[ 	]*//;p;}" "${BASH_SOURCE[ii + 1]}")"
		echo "      $MESSAGE" >> "$slogFILE"
	done
	echo "   in script $slogSCRIPTDIR/$slogSCRIPTNAME" >> "$slogFILE"
}
