#!/bin/bash

EXEC="/cygdrive/c/MCS/apps/Sublime Text 3/subl.exe"

DIR="${PWD}"

for f in "$@"; do
    cd "${DIR}"
    if [[ "$f" =~ "/" ]]; then
        cd "${f%/*}"
    fi
    "$EXEC" "${f##*/}"
done
