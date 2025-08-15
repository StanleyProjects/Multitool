#!/usr/local/bin/bash

if test $# -ne 2; then
 echo 'No string!'; exit 1; fi

if test -z "$1"; then
 echo "$2"; exit 1; fi
