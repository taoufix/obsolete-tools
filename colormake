#!/bin/bash
#
# Usage: colormake [-w | -s PATTERN] MAKE_OPTIONS
#
#  -w           Yellow warnings
#  -s PATTERN   Make lines containing PATTERN green

# Colors
_ESC="$(echo -en '\e')"
C_NULL="${_ESC}[00;00m"
C_RED="${_ESC}[31;01m"
C_GREEN="${_ESC}[32;01m"
C_YELLOW="${_ESC}[33;01m"
C_LIGHTBLUE="${_ESC}[36;01m"

if [ "${1}" == "-s" ] && [ ! -z "${2}" ]; then
    pattern="${2}"
    shift 2
    exec make "$@" 2>&1 | sed \
	-e "s/\(^make.*\)/${C_LIGHTBLUE}\1${C_NULL}/" \
	-e "s/\(.* [Ee]rror:.*\)/${C_RED}\1${C_NULL}/" \
	-e "s/\(.*${pattern}.*\)/${C_GREEN}\1${C_NULL}/"
elif [ "${1}" == "-w"  ]; then
    shift
    exec make "$@" 2>&1 | sed \
	-e "s/\(^make.*\)/${C_LIGHTBLUE}\1${C_NULL}/" \
	-e "s/\(.* [Ee]rror:.*\)/${C_RED}\1${C_NULL}/" \
	-e "s/\(.* [Ww]arning:.*\)/${C_YELLOW}\1${C_NULL}/"
else 
    exec make "$@" 2>&1 | sed \
	-e "s/\(^make.*\)/${C_LIGHTBLUE}\1${C_NULL}/" \
	-e "s/\(.* [Ee]rror:.*\)/${C_RED}\1${C_NULL}/"
fi
