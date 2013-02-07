#!/bin/bash

function bar() {
    per=${!#}
    echo -n $* | sed "s+${per}\$++"
	
    if echo "$per" | grep -q "^[0-9][0-9]*$"; then
	per=$((per /2))
	if (($per > 37)); then
	    color="[31;01m"
	elif (( $per > 25 )); then
	    color="[33;01m"
	else
	    color="[32;01m"
	fi
	echo -ne ${color}
	i=0
	while ((++i <= $per)); do
	    echo -ne "█"
	done
	while ((i++ <= 50)); do
	    echo -ne "_"
	done
	echo "[00;00m"
    fi
    echo
}

df -h | sed -e '1d' -e "/^[^[:blank:]]*$/N; s/\n//" | (
    while true; do
	read n
	[[ $n == "" ]]   && exit
	bar `echo $n | sed "s/\(.\+\) \([0-9]\+\)%\(.\+\)/\1 \2%\3 \2/" `
    done
) | column -t
