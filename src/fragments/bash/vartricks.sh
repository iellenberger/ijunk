#!/bin/bash

# --- interolating variable names ---
LIST="one two four"
VAR_one="won"
VAR_two="too"
VAR_three="trees"
VAR_four="fore"

getvar() {
	prefix=
}

for NAME in $LIST; do
	var="VAR_$NAME"
	echo $var ${!var}
done
