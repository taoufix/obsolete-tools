#!/bin/bash

if (( $# == 0)); then
    echo "Usage: ${0} MAC"
    exit 1
fi

wget -qO - "http://www.coffer.com/mac_find?string=${1}" | egrep -A1 "Prefix +Vendor" | sed -n 's/.*<a .*>\(.\+\)<\/a>/\1/p'
