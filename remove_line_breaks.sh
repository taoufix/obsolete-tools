#!/bin/bash

for f in "$@"; do
  echo "${f}"
  cp "${f}" ".${f}.tmp" \
    && sed 's/^[[:blank:]]*//' ".${f}.tmp" | tr -d '[:cntrl:]' > "${f}" \
    && rm -f ".${f}.tmp"
done
