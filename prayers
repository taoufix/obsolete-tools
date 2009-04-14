#!/bin/bash

F=${HOME}/.prayers.data
if [[ ! -f "$F" ||  "$(ls -l --full-time ${F} | awk '{print $6}')" != "$(date +%Y-%m-%d)" ]]; then
    wget -q -O - "http://www.zitounafm.net/prieres.php" |  grep -A15 "بنزرت" | egrep -o '[0-9]{2}:[0-9]{2}' > "${F}"
fi

echo -e "Sobh Dohr Asr Maghreb Icha\n" `cat ${F}` | column -t

