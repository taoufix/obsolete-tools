#!/bin/bash

command="${@}"

if [[ -z $command ]]; then
    echo "Usage: $0 GIT_COMMAND"
    exit 1
fi

for i in arabic-news-*; do
    echo "-----------------------------------------------------"
    echo "--- $i"
    echo "-----------------------------------------------------"
    (cd $i && git $command);
done
