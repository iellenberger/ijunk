#!/bin/bash

source slog.sh

levelone() {
	leveltwo
}
leveltwo() {
	slogstack
	slogstack 0
	slogstack 0 Sample stack trace
}

echo "=== Prints one message to each level and call stack ===
 * You won't see Debug and Info because logging level is default
 * LS_WARNING_LEVEL = 30"
echo
slog 2 Verbose message
slog 1 Debug message
slog 0 Info message
slog -1 Warning message
slog -2 Error message
slog -3 Critical message

echo
echo "=== Set level to LS_DEBUG_LEVEL 10 ==="
echo "=== Prints one message to each level ==="
echo
sloglevel 0

slog 2 Verbose message
slog 1 Debug message
slog 0 Info message
slog -1 Warning message
slog -2 Error message
slog -3 Critical message
levelone

echo
echo "=== Prints 1 to 5 via pipe ==="
echo " * for ... | LSINFO"
echo

for i in {1..5}; do
  echo $i
done | slog 0

echo
echo "=== Prints one message to level 35 ==="
echo
slog 35 Message for level 35

echo
echo "=== Log on to /dev/stderr ==="
echo " * Try to rerun with $0 > /dev/null"
echo
LS_OUTPUT=/dev/stderr
slog -2 Error message to stderr

