#!/usr/local/bin/bash

if test $# -ne 3; then
 echo 'Wrong arguments!'; exit 1; fi

if test -z "$3"; then
 echo 'No message!'; exit 1; fi

if [ "$1" == "$2" ]; then
 echo "$3"; exit 1; fi
