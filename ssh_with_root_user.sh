#!/bin/bash
host="$(sed 's/^@//' <<<"$@")"

if [[ x"${TERM}" == x"screen" ]]; then
    screen -t "${host}" ssh root@${host}
else
    ssh root@${host}
fi
