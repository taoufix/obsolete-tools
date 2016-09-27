#!/bin/bash

EXEC="/cygdrive/c/MCS/apps/Sublime Text 3/subl.exe"

if [[ "$1" =~ "/" ]]; then
    cd "${1%/*}"
fi

"$EXEC" "${1##*/}"
