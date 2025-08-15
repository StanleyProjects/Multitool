#!/usr/local/bin/bash

if test $# -eq 0; then
 echo 'No arguments!'; exit 1; fi

for (( INDEX=1; INDEX<=$#; INDEX++ )); do
 ARGUMENT="${!INDEX}"
 if test -z "${!ARGUMENT}"; then
  echo "Argument \"$ARGUMENT\" is empty!"; exit $((100+INDEX)); fi
done
