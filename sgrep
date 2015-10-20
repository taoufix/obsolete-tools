#!/bin/bash

IGNORE=".svn target target-eclipse"

_to_ignore=""
_append=""
for i in ${IGNORE}; do
	_to_ignore="${_to_ignore}${_append}-name ${i}"
	_append=" -o "
done

find . -type d  \( ${_to_ignore} \) -prune -o -print0 |\
    xargs  --null grep -E -n --color "$@"
