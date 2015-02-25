#!/bin/bash -x

# --- sudo one-liner ---
if [ "$EUID" != 0 ]; then sudo $0 $*; exit; fi

# --- do something ---
whoami
exit;

# === Other Examples ========================================================

# --- as explicit user ---
if [ "$USER" != "root" ]; then sudo -u root $0 $*; exit; fi

# --- as explicit user w/ login shell ---
if [ "$USER" != "root" ]; then sudo -i -u root $(cd $(dirname $0); pwd)/$(basename $0) $*; exit; fi
