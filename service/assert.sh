#!/usr/local/bin/bash

if test $# -ne 3; then
 echo 'Wrong arguments!'; exit 1; fi

if test -z "$1"; then
 echo 'No issuer!'; exit 1; fi

if [ "$2" != "$3" ]; then
 echo "Expected is \"$3\", but actual is \"$2\"!"; echo "Issuer \"$1\" error!"; exit 1; fi
