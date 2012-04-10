#!/bin/bash

# --- sudo one-liner ---
if [ "$EUID" != 0 ]; then sudo $0 $*; exit; fi

# --- do something ---
whoami
