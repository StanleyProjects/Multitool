#!/usr/local/bin/bash

if test $# -lt 3; then
 echo 'Wrong arguments!'; exit 1; fi

ACTUAL="$1"

if test -z "${ACTUAL}"; then
 echo 'Value is empty'; exit 1; fi

for (( INDEX=2; INDEX<=$#; INDEX++ )); do
 EXPECTED="${!INDEX}"
 if [ "${ACTUAL}" == "${EXPECTED}" ]; then
  exit 0; fi
done

echo "Value \"${ACTUAL}\" not found!"
exit 1
