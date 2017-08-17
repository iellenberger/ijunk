#!/bin/bash

# --- replacement for the stoch Bash pathmunge() help function ---
# This is a replacement for the pathmunge() helper distributed in various
# versions of *nix.  It uses iTools' pathmunge.pl for processing and is fully
# backwards compatible with ye pathmunge() of olde.
pathmunge() {
	export PATH=$(pathmunge.pl $@)
}
