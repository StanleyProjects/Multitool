#!/usr/local/bin/bash

if test $# -lt 3; then
 echo 'Too few arguments!'; exit 1; fi

ACTUAL="$1"

if test -z "${ACTUAL}"; then
 echo 'Value is empty!'; exit 1; fi

FOUND='false'
for (( INDEX=2; INDEX<=$#; INDEX++ )); do
 EXPECTED="${!INDEX}"
 if [ "${ACTUAL}" == "${EXPECTED}" ]; then
  FOUND='true'; break; fi
done

if [ "${FOUND}" != 'true' ]; then
 echo "Value \"${ACTUAL}\" not found!"; exit 1; fi
