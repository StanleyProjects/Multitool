#!/usr/local/bin/bash

ISSUER="${mt}/checks/eq.sh"

ACTUAL_VALUE="$(${ISSUER})"
. $asserts/eq.sh $? 1
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1)"
. $asserts/eq.sh $? 1
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1 2)"
. $asserts/eq.sh $? 1
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

ACTUAL_VALUE="$(${ISSUER} 1 2 3 4)"
. $asserts/eq.sh $? 1
. $asserts/eq.sh "${ACTUAL_VALUE}" 'Wrong arguments!'

EXPECTED_VALUE='test message'

ACTUAL_VALUE="$(${ISSUER} 1 2 "${EXPECTED_VALUE}")"
. $asserts/eq.sh $? 1
. $asserts/eq.sh "${ACTUAL_VALUE}" "${EXPECTED_VALUE}"

ACTUAL_VALUE="$(${ISSUER} 1 1 "${EXPECTED_VALUE}")"
. $asserts/eq.sh $? 0
. $asserts/eq.sh "${ACTUAL_VALUE}" ''
