#!/usr/local/bin/bash

if test $# -ne 1; then
 echo 'Wrong arguments!'; exit 1; fi

if test -z "$1"; then
 echo 'No file name!'; exit 1
elif [[ ! -f "$1" ]]; then
 echo "No file \"$1\"!"; exit 1
elif [[ ! -s "$1" ]]; then
 echo "File \"$1\" is empty!"; exit 1;
fi
