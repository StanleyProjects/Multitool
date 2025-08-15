#!/usr/local/bin/bash

if test $# -ne 1; then
 echo 'Wrong arguments!'; exit 1; fi

if test -z "${ISSUER}"; then
 echo 'No issuer!'; exit 1; fi

if [ "$1" != '' ]; then
 echo "Issuer \"${ISSUER}\" error!"
 echo "Value \"$2\" is not empty!"
 exit 1
fi
