#!/usr/local/bin/bash

if test $# -ne 2; then
 echo 'Wrong arguments!'; exit 1; fi

if test -z "$2"; then
 echo 'No message!'; exit 1; fi

if test $1 -ne 0; then
 echo "$2"; exit 1; fi
