#!/bin/bash

if pgrep firefox; then
    echo "Firefox is running make sure it's closed."
    exit 1
else
    for f in ${HOME}/.mozilla/firefox/*.default/*.sqlite; do
	echo -n "Vacuuming ${f} ... "
	sqlite3 "${f}" 'VACUUM'
	echo "done"
    done
fi
