#!/bin/bash

# Evaluating a boolean variable

# --- function to display a result line ---
results() {
	# --- params: returval, index ---
	RETVAL=$1; INDEX=$2

	# --- format the display value ---
	if [ -z "${MYBOOL[$INDEX]+x}" ];    then DISPLAYVAL='<unset>'
	elif [ "${MYBOOL[$INDEX]}" == '' ]; then DISPLAYVAL='<blank>'
	else                                   DISPLAYVAL=${MYBOOL[$INDEX]}
	fi

	if [ $RETVAL = 0 ]; then
		printf "   %-10s : true\\n" "$DISPLAYVAL"
	elif [ $RETVAL == 2 ]; then
		printf "   %-10s :              error\\n" "$DISPLAYVAL"
	else
		printf "   %-10s :       false\\n" "$DISPLAYVAL"
	fi

}

# --- set the array ---
MYBOOL=( 'true' 'false' 1 0 'two words' '' );

# --- test if value is set ---
echo '[ ! -z ${MYBOOL+x} ] - is the value set?'
for ii in "${!MYBOOL[@]}" 99; do
	[ ! -z ${MYBOOL[$ii]+x} 2> /dev/null ]
	results $? $ii
done
echo

echo '[ $MYBOOL ] -> does it have a value? (unquoted)'
for ii in "${!MYBOOL[@]}" 99; do
	[ ${MYBOOL[ii]} 2> /dev/null ]
	results $? $ii
done

echo
echo '[ "$MYBOOL" ] -> does it have a value? (quoted)'
for ii in "${!MYBOOL[@]}" 99; do
	[ "${MYBOOL[ii]}" 2> /dev/null ]
	results $? $ii
done

echo
echo '[ $MYBOOL = true ] -> does it evaluate as true? (unquoted)'
for ii in "${!MYBOOL[@]}" 99; do
	[ ${MYBOOL[ii]} = true 2> /dev/null ]
	results $? $ii
done

echo
echo '[ "$MYBOOL" = true ] -> does it evaluate as true? (quoted)'
for ii in "${!MYBOOL[@]}" 99; do
	[ "${MYBOOL[ii]}" = true 2> /dev/null ]
	results $? $ii
done
